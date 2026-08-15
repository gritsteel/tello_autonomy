[CmdletBinding()]
param(
    [string]$Weights = "tello_autonomy\ffca_yolo\weights\best.pt",
    [string]$Data = "tello_autonomy\ffca_yolo\data\AITOD.yaml",
    [string]$Targets = "person,vehicle",
    [double]$Duration = 60.0,
    [string]$Device = "0",
    [switch]$Half,
    [switch]$NoView,
    [switch]$SaveVideo
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$python = Join-Path $repoRoot ".venv-tello\Scripts\python.exe"
if (-not (Test-Path -LiteralPath $python -PathType Leaf)) {
    throw "Tello environment not found. Run .\setup_tello_windows.ps1 first."
}

$arguments = @(
    "-m", "tello_autonomy", "observe",
    "--weights", (Join-Path $repoRoot $Weights),
    "--data", (Join-Path $repoRoot $Data),
    "--targets", $Targets,
    "--duration", "$Duration",
    "--device", $Device
)
if ($Half) { $arguments += "--half" }
if ($NoView) { $arguments += "--no-view" }
if ($SaveVideo) {
    $arguments += @("--output", (Join-Path $repoRoot "outputs\tello_observe.mp4"))
}

Push-Location $repoRoot
try {
    & $python @arguments
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
