Set-StrictMode -Version Latest
function Get-SciPptSession {
    param([Parameter(Mandatory=$true)][string]$PresentationPath)
    if ($PSVersionTable.PSEdition -ne 'Desktop') { throw 'Use Windows PowerShell 5.1 (powershell.exe).' }
    $full = (Resolve-Path -LiteralPath $PresentationPath -ErrorAction Stop).Path
    try { $app = [Runtime.InteropServices.Marshal]::GetActiveObject('PowerPoint.Application') }
    catch { $app = New-Object -ComObject PowerPoint.Application }
    $app.Visible = -1
    $deck = $null
    for ($i=1; $i -le $app.Presentations.Count; $i++) {
        $candidate = $app.Presentations.Item($i)
        if ([string]::Equals($candidate.FullName,$full,[StringComparison]::OrdinalIgnoreCase)) { $deck=$candidate; break }
    }
    if ($null -eq $deck) { $deck=$app.Presentations.Open($full,0,0,-1) }
    [pscustomobject]@{ App=$app; Deck=$deck }
}
function Show-SciPptStage {
    param([Parameter(Mandatory=$true)]$Session,[int]$Slide=1)
    if ($Slide -lt 1 -or $Slide -gt $Session.Deck.Slides.Count) { throw 'Slide out of range.' }
    $window=$Session.Deck.Windows.Item(1)
    $window.Activate()
    $window.View.GotoSlide($Slide)
}
