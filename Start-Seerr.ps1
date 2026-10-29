$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$node = Join-Path $root 'runtime\node-v22.23.4-win-x64\node.exe'
$app = Join-Path $root 'app'
$logs = Join-Path $root 'logs'
$pidFile = Join-Path $root 'seerr.pid'
if (-not (Test-Path -LiteralPath $node)) { throw "Seerr's local Node runtime is missing: $node" }

if (Test-Path -LiteralPath $pidFile) {
    $existingPid = 0
    if ([int]::TryParse((Get-Content -LiteralPath $pidFile -Raw), [ref]$existingPid)) {
        $existing = Get-Process -Id $existingPid -ErrorAction SilentlyContinue
        if ($existing -and $existing.Path -eq $node) {
            Start-Process 'http://127.0.0.1:5055'
            exit 0
        }
    }
}

$env:PORT = '5055'
$env:HOST = '0.0.0.0'
$env:NODE_ENV = 'production'
$process = Start-Process -FilePath $node -ArgumentList 'dist/index.js' -WorkingDirectory $app -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $logs 'seerr-out.log') -RedirectStandardError (Join-Path $logs 'seerr-error.log')
Set-Content -LiteralPath $pidFile -Value $process.Id -NoNewline
Start-Sleep -Seconds 8
if ($process.HasExited) { throw "Seerr stopped during startup. Check $logs\seerr-error.log" }
Write-Host 'Seerr is running at http://127.0.0.1:5055'
Start-Process 'http://127.0.0.1:5055'
