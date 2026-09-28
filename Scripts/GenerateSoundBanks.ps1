param([string]$WwiseRoot)

$ErrorActionPreference = 'Stop'
$requiredVersion = '2025.1.11.9262'
$projectRoot = Split-Path -Parent $PSScriptRoot
$consoleRelativePath = 'Authoring\x64\Release\bin\WwiseConsole.exe'

try {
    $candidates = if ($WwiseRoot) {
        @($WwiseRoot)
    } else {
        @(
            $env:WWISEROOT
            "${env:SystemDrive}\Audiokinetic\Wwise_$requiredVersion"
            "${env:ProgramFiles}\Audiokinetic\Wwise_$requiredVersion"
            "${env:ProgramFiles(x86)}\Audiokinetic\Wwise_$requiredVersion"
        )
    }

    $console = $null
    foreach ($candidate in $candidates) {
        if (-not $candidate) { continue }
        $exe = Join-Path $candidate $consoleRelativePath
        if ((Test-Path -LiteralPath $exe -PathType Leaf) -and
            (Get-Item -LiteralPath $exe).VersionInfo.ProductVersion -eq $requiredVersion) {
            $console = $exe
            break
        }
    }

    if (-not $console) {
        throw "Install Wwise Authoring $requiredVersion using Audiokinetic Launcher. Set WWISEROOT to its installation folder, or pass that folder with -WwiseRoot."
    }

    $project = Join-Path $projectRoot 'Gyms_WwiseProject\Gyms.wproj'
    Write-Host "Generating Windows SoundBanks with Wwise $requiredVersion..."
    & $console generate-soundbank $project --platform Windows --language en_US --no-source-control --abort-on-load-issues
    if ($LASTEXITCODE -ne 0) {
        throw "WwiseConsole returned exit code $LASTEXITCODE. See the messages above."
    }
    if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'Gyms_WwiseProject\GeneratedSoundBanks\Windows\Init.bnk'))) {
        throw 'Init.bnk was not generated at the configured output path.'
    }
    Write-Host 'SoundBanks are ready. Open WWISE.uproject in Unreal Engine 5.7.'
    exit 0
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
