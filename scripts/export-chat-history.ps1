# Posle krupnyh izmenenij obnovite datu v docs/CHAT_HISTORY.md
# Polnaja istorija — v docs/CHAT_HISTORY.md (vruchnaja, bez staryh bekapov)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$historyFile = Join-Path $projectRoot 'docs\CHAT_HISTORY.md'

if (-not (Test-Path $historyFile)) {
    Write-Error "Missing docs/CHAT_HISTORY.md"
}

$content = Get-Content -LiteralPath $historyFile -Raw -Encoding UTF8
$today = Get-Date -Format 'yyyy-MM-dd'
$content = [regex]::Replace($content, '(> Обновлено: )\d{4}-\d{2}-\d{2}', "`${1}$today")
[System.IO.File]::WriteAllText($historyFile, $content, [System.Text.UTF8Encoding]::new($false))
Write-Host "OK: date -> $today in CHAT_HISTORY.md"
