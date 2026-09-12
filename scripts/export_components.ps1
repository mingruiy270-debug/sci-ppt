[CmdletBinding()]
param(
 [Parameter(Mandatory=$true)][string]$PresentationPath,
 [Parameter(Mandatory=$true)][string]$OutputDirectory,
 [ValidateRange(1,8)][int]$PngScale=2,
 [string]$ComponentId,
 [switch]$Overwrite
)
$ErrorActionPreference='Stop'
. "$PSScriptRoot/ppt_session.ps1"
$session=Get-SciPptSession -PresentationPath $PresentationPath
$deck=$session.Deck
$records=@{}
for($p=1;$p -le $deck.Slides.Count;$p++) {
 $slide=$deck.Slides.Item($p)
 for($i=1;$i -le $slide.Shapes.Count;$i++) {
  $shape=$slide.Shapes.Item($i)
  $id=[string]$shape.Tags.Item('SCI_ID')
  $kind=[string]$shape.Tags.Item('SCI_KIND')
  $order=[string]$shape.Tags.Item('SCI_ORDER')
  if(!$id -and $shape.Name -match '^CMP([VR])_(\d+)_(.+)$') {
   $kind=if($Matches[1] -eq 'V'){'vector'}else{'raster'}
   $order=$Matches[2]; $id=$order+'_'+$Matches[3]
  }
  if(!$id){continue}
  if($ComponentId -and $id -ne $ComponentId){continue}
  if($id -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$'){throw "Unsafe component ID: $id"}
  if($kind -notin @('vector','raster','mixed')){throw "Missing/invalid SCI_KIND: $id"}
  $rank=2147483647
  if($order){if(![int]::TryParse($order,[ref]$rank) -or $rank -lt 1){throw "Invalid order: $id"}}
  if(!$records.ContainsKey($id)) {
   $records[$id]=[pscustomobject]@{Id=$id;Kind=$kind;Page=$p;Rank=$rank;Indices=[Collections.Generic.List[int]]::new()}
  }
  $record=$records[$id]
  if($record.Page -ne $p -or $record.Kind -ne $kind -or $record.Rank -ne $rank){throw "Conflicting component metadata: $id"}
  $record.Indices.Add($i)
 }
}
if($ComponentId -and $records.Count -eq 0){throw "Component not found: $ComponentId"}
$output=[IO.Path]::GetFullPath($OutputDirectory)
$sorted=@($records.Values | Sort-Object Rank,Id)
foreach($record in $sorted){
 $extensions=if($record.Kind -eq 'vector'){@('svg','png')}else{@('png')}
 foreach($ext in $extensions){
  if((Test-Path -LiteralPath (Join-Path $output ($record.Id+'.'+$ext))) -and !$Overwrite){throw 'Output already exists. Use a new directory or -Overwrite for intended updates.'}
 }
}
[IO.Directory]::CreateDirectory($output)|Out-Null
$width=[int]($deck.PageSetup.SlideWidth*$PngScale)
$height=[int]($deck.PageSetup.SlideHeight*$PngScale)
foreach($record in $sorted){
 $shapes=$deck.Slides.Item($record.Page).Shapes
 $target=if($record.Indices.Count -eq 1){$shapes.Item($record.Indices[0])}else{$shapes.Range([object[]]$record.Indices.ToArray())}
 # Stage exports before committing. Do not group or mutate production objects.
 $staging=Join-Path $output ('.export-'+[guid]::NewGuid().ToString('N'))
 [IO.Directory]::CreateDirectory($staging)|Out-Null
 try {
  $png=Join-Path $staging ($record.Id+'.png')
  $target.Export($png,2,$width,$height,1)
  if(!(Test-Path -LiteralPath $png) -or (Get-Item -LiteralPath $png).Length -eq 0){throw "PNG export failed: $($record.Id)"}
  if($record.Kind -eq 'vector'){
   $svg=Join-Path $staging ($record.Id+'.svg')
   $target.Export($svg,6)
   $settings=[Xml.XmlReaderSettings]::new(); $settings.DtdProcessing='Prohibit'; $settings.XmlResolver=$null
   $reader=[Xml.XmlReader]::Create($svg,$settings)
   try {$xml=[Xml.XmlDocument]::new();$xml.XmlResolver=$null;$xml.Load($reader)}finally{$reader.Dispose()}
   if($xml.DocumentElement.LocalName -ne 'svg' -or $xml.SelectNodes("//*[local-name()='image' or local-name()='foreignObject']").Count -gt 0){throw "Not pure vector: $($record.Id). Reclassify or use source assets."}
  }
  foreach($file in Get-ChildItem -LiteralPath $staging -File){Move-Item -LiteralPath $file.FullName -Destination (Join-Path $output $file.Name) -Force:$Overwrite}
 } finally {
  # Only the uniquely-created staging folder inside the resolved output is removed.
  if([IO.Path]::GetFullPath($staging).StartsWith($output+[IO.Path]::DirectorySeparatorChar,[StringComparison]::OrdinalIgnoreCase)) {Remove-Item -LiteralPath $staging -Recurse -Force}
 }
}
Write-Output ('Exported {0} components; presentation left open and unchanged.' -f $sorted.Count)
