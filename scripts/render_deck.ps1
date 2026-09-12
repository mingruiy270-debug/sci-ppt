[CmdletBinding()]
param(
 [Parameter(Mandatory=$true)][string]$PresentationPath,
 [Parameter(Mandatory=$true)][string]$OutputDirectory,
 [switch]$Overwrite
)
$ErrorActionPreference='Stop'
if($PSVersionTable.PSEdition -ne 'Desktop'){throw 'Use Windows PowerShell 5.1.'}
$path=(Resolve-Path -LiteralPath $PresentationPath).Path
$out=[IO.Path]::GetFullPath($OutputDirectory)
if((Test-Path -LiteralPath $out) -and (Get-ChildItem -LiteralPath $out -File) -and !$Overwrite){throw 'Preview directory is not empty. Use -Overwrite for intended updates.'}
[IO.Directory]::CreateDirectory($out)|Out-Null
try {$app=[Runtime.InteropServices.Marshal]::GetActiveObject('PowerPoint.Application')}
catch {$app=New-Object -ComObject PowerPoint.Application}
$app.Visible=-1
$deck=$null
for($i=1;$i -le $app.Presentations.Count;$i++){
 $candidate=$app.Presentations.Item($i)
 if([string]::Equals($candidate.FullName,$path,[StringComparison]::OrdinalIgnoreCase)){$deck=$candidate; break}
}
$opened=$false
if($null -eq $deck){$deck=$app.Presentations.Open($path,-1,0,-1);$opened=$true}
$issues=@()
try {
 for($s=1;$s -le $deck.Slides.Count;$s++){
  $slide=$deck.Slides.Item($s)
  $slide.Export((Join-Path $out ('slide_{0:D2}.png' -f $s)),'PNG',1920,1080)
  foreach($shape in $slide.Shapes){
   if($shape.HasTextFrame -eq -1 -and $shape.TextFrame.HasText -eq -1){
    $tf=$shape.TextFrame2
    $tr=$tf.TextRange
    if($tr.BoundHeight -gt ($shape.Height-$tf.MarginTop-$tf.MarginBottom+3) -or $tr.BoundWidth -gt ($shape.Width-$tf.MarginLeft-$tf.MarginRight+3)){
     $issues += ('Slide {0}: {1}: text exceeds box' -f $s,$shape.Name)
    }
   }
  }
 }
 Write-Output ('Rendered {0} slides; text geometry findings: {1}' -f $deck.Slides.Count,$issues.Count)
 $issues | Write-Output
} finally {if($opened){$deck.Close()}}
if($issues.Count -gt 0){exit 2}
