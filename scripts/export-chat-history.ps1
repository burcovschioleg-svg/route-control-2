# Export Cursor chat transcripts -> docs/CHAT_HISTORY.md
# Run: powershell -ExecutionPolicy Bypass -File scripts/export-chat-history.ps1

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$transcriptRoot = Join-Path $env:USERPROFILE '.cursor\projects\c-projects\agent-transcripts'
$outDir = Join-Path $projectRoot 'docs'
$outFile = Join-Path $outDir 'CHAT_HISTORY.md'
$contextFile = Join-Path $outDir 'PROJECT_CONTEXT.md'

if (-not (Test-Path $transcriptRoot)) {
    Write-Error "Transcripts not found: $transcriptRoot"
}

function Get-MessageText([object]$Entry) {
    if (-not $Entry.message.content) { return $null }
    $parts = @()
    foreach ($c in @($Entry.message.content)) {
        if ($c.type -eq 'text' -and $c.text) {
            $t = [string]$c.text
            if ($t -match '<user_query>\s*([\s\S]*?)\s*</user_query>') { $t = $Matches[1] }
            $t = $t -replace '\[REDACTED\]', ''
            $t = $t.Trim()
            if ($t.Length -gt 0) { $parts += $t }
        }
    }
    if ($parts.Count -eq 0) { return $null }
    return ($parts -join "`n`n")
}

function Export-Transcript([string]$Path) {
    $parent = Split-Path $Path -Parent
    $sessionId = Split-Path $parent -Leaf
    if ($sessionId -eq 'subagents') {
        $sessionId = (Split-Path $Path -Leaf) -replace '\.jsonl$', ''
    }
    $isSub = ($Path -match '\\subagents\\')
    $messages = @()
    foreach ($line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try { $entry = $line | ConvertFrom-Json } catch { continue }
        $text = Get-MessageText $entry
        if (-not $text) { continue }
        $messages += [PSCustomObject]@{ Role = $entry.role; Text = $text }
    }
    return [PSCustomObject]@{
        SessionId  = $sessionId
        IsSubagent = $isSub
        Path       = $Path
        Messages   = $messages
        FileTime   = (Get-Item -LiteralPath $Path).LastWriteTime
    }
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$header = if (Test-Path $contextFile) {
    Get-Content -LiteralPath $contextFile -Raw -Encoding UTF8
} else {
    "# Route Control`n`nContext file missing: docs/PROJECT_CONTEXT.md`n"
}

$files = Get-ChildItem -Path $transcriptRoot -Recurse -Filter '*.jsonl' | Sort-Object LastWriteTime
$sessions = foreach ($f in $files) { Export-Transcript $f.FullName }

$sb = New-Object System.Text.StringBuilder
[void]$sb.Append($header.TrimEnd())
[void]$sb.AppendLine('')
[void]$sb.AppendLine('')
[void]$sb.AppendLine("> Chat log exported: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
[void]$sb.AppendLine('')
[void]$sb.AppendLine('---')
[void]$sb.AppendLine('')
[void]$sb.AppendLine('## Полный лог чатов')
[void]$sb.AppendLine('')

$sessionNum = 0
foreach ($s in $sessions) {
    if ($s.Messages.Count -eq 0) { continue }
    $sessionNum++
    $label = if ($s.IsSubagent) { "Subagent $($s.SessionId)" } else { "Session $sessionNum / $($s.SessionId)" }
    [void]$sb.AppendLine("## $label")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("*$($s.Path) | $($s.FileTime.ToString('yyyy-MM-dd HH:mm'))*")
    [void]$sb.AppendLine('')
    foreach ($m in $s.Messages) {
        $roleLabel = if ($m.Role -eq 'user') { '**Oleg**' } else { '**Agent**' }
        [void]$sb.AppendLine($roleLabel)
        [void]$sb.AppendLine('')
        [void]$sb.AppendLine($m.Text)
        [void]$sb.AppendLine('')
        [void]$sb.AppendLine('---')
        [void]$sb.AppendLine('')
    }
}

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))

$sizeKB = [math]::Round((Get-Item $outFile).Length / 1KB, 1)
$msgCount = ($sessions | ForEach-Object { $_.Messages.Count } | Measure-Object -Sum).Sum
Write-Host "OK: $outFile ($sizeKB KB, $msgCount msgs, $sessionNum sessions)"
