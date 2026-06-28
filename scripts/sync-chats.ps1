# Sync Cursor chat sessions <-> Git (bidirectional)
# Usage:
#   powershell -File scripts/sync-chats.ps1          # merge both ways
#   powershell -File scripts/sync-chats.ps1 -Push    # this PC -> git only
#   powershell -File scripts/sync-chats.ps1 -Pull    # git -> this PC only

param(
    [switch]$Push,
    [switch]$Pull
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$gitSessions = Join-Path $projectRoot 'docs\cursor-sessions'
$manifestPath = Join-Path $gitSessions 'manifest.json'
$cursorRoot = Join-Path $env:USERPROFILE '.cursor\projects\c-projects\agent-transcripts'

if (-not (Test-Path $cursorRoot)) {
    New-Item -ItemType Directory -Force -Path $cursorRoot | Out-Null
}
New-Item -ItemType Directory -Force -Path $gitSessions | Out-Null

function Get-SessionIdFromPath([string]$Path) {
    $name = [System.IO.Path]::GetFileName($Path)
    if ($name -match '\.jsonl$') { return $name -replace '\.jsonl$', '' }
    return $name
}

function Get-LocalSessions() {
    $map = @{}
    Get-ChildItem -Path $cursorRoot -Recurse -Filter '*.jsonl' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\subagents\\' } |
        ForEach-Object {
            $id = Get-SessionIdFromPath $_.FullName
            if ($_.Length -gt 0) { $map[$id] = $_ }
        }
    return $map
}

function Get-GitSessions() {
    $map = @{}
    Get-ChildItem -Path $gitSessions -Filter '*.jsonl' -ErrorAction SilentlyContinue |
        ForEach-Object {
            $id = Get-SessionIdFromPath $_.FullName
            $map[$id] = $_
        }
    return $map
}

function Copy-SessionToGit([string]$Id, [string]$SourcePath) {
    $dest = Join-Path $gitSessions "$Id.jsonl"
    Copy-Item -LiteralPath $SourcePath -Destination $dest -Force
}

function Copy-SessionToCursor([string]$Id, [string]$SourcePath) {
    $dir = Join-Path $cursorRoot $Id
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $dest = Join-Path $dir "$Id.jsonl"
    Copy-Item -LiteralPath $SourcePath -Destination $dest -Force
}

function Clean-ChatText([string]$Text) {
    $t = $Text
    $t = $t -replace '(?s)\[Image\].*?</image_files>\s*', ''
    $t = $t -replace '(?s)<image_files>.*?</image_files>\s*', ''
    $t = $t -replace '<timestamp>[^<]*</timestamp>\s*', ''
    if ($t -match '<user_query>\s*([\s\S]*?)\s*</user_query>') { $t = $Matches[1] }
    $t = $t -replace '\[REDACTED\]', ''
    return $t.Trim()
}

function Get-MessageText([object]$Entry) {
    if (-not $Entry.message.content) { return $null }
    $parts = @()
    foreach ($c in @($Entry.message.content)) {
        if ($c.type -eq 'text' -and $c.text) {
            $t = Clean-ChatText ([string]$c.text)
            if ($t.Length -gt 0) { $parts += $t }
        }
    }
    if ($parts.Count -eq 0) { return $null }
    return ($parts -join "`n`n")
}

function Write-ReadableMarkdown([string]$JsonlPath, [string]$Id) {
    $mdPath = Join-Path $gitSessions "$Id.md"
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# Cursor session $Id")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine("> Readable export for other PC. Source: ``$Id.jsonl``")
    [void]$sb.AppendLine('')
    foreach ($line in Get-Content -LiteralPath $JsonlPath -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try { $entry = $line | ConvertFrom-Json } catch { continue }
        $text = Get-MessageText $entry
        if (-not $text) { continue }
        $role = if ($entry.role -eq 'user') { '**Oleg**' } else { '**Agent**' }
        [void]$sb.AppendLine($role)
        [void]$sb.AppendLine('')
        [void]$sb.AppendLine($text)
        [void]$sb.AppendLine('')
        [void]$sb.AppendLine('---')
        [void]$sb.AppendLine('')
    }
    [System.IO.File]::WriteAllText($mdPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
}

function Write-AllChatsSingleFile([string]$ProjectRoot, [string]$SessionsDir) {
    $outTxt = Join-Path $ProjectRoot 'docs\ALL_CHATS.txt'
    $outMd = Join-Path $ProjectRoot 'docs\ALL_CHATS.md'
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('ROUTE CONTROL - FULL CURSOR CHAT TEXT')
    [void]$sb.AppendLine("Built: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('Other PC: open this file in Cursor or paste into new chat.')
    [void]$sb.AppendLine('Say: read ALL_CHATS.txt and CHAT_HISTORY.md - continue v2')
    [void]$sb.AppendLine('')
    [void]$sb.AppendLine('================================================================================')
    [void]$sb.AppendLine('')

    $msgTotal = 0
    $files = Get-ChildItem -Path $SessionsDir -Filter '*.jsonl' | Sort-Object LastWriteTime
    foreach ($f in $files) {
        if ($f.Length -eq 0) { continue }
        $id = Get-SessionIdFromPath $f.FullName
        [void]$sb.AppendLine("########## SESSION $id ##########")
        [void]$sb.AppendLine("File date: $($f.LastWriteTime.ToString('yyyy-MM-dd HH:mm'))")
        [void]$sb.AppendLine('')

        foreach ($line in Get-Content -LiteralPath $f.FullName -Encoding UTF8) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            try { $entry = $line | ConvertFrom-Json } catch { continue }
            $text = Get-MessageText $entry
            if (-not $text) { continue }
            $msgTotal++
            $role = if ($entry.role -eq 'user') { '--- OLEG ---' } else { '--- AGENT ---' }
            [void]$sb.AppendLine($role)
            [void]$sb.AppendLine($text)
            [void]$sb.AppendLine('')
            [void]$sb.AppendLine('--------------------------------------------------------------------------------')
            [void]$sb.AppendLine('')
        }
        [void]$sb.AppendLine('')
    }

    $content = $sb.ToString()
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($outTxt, $content, $enc)
    [System.IO.File]::WriteAllText($outMd, $content, $enc)
    $sizeKB = [math]::Round((Get-Item $outTxt).Length / 1KB, 1)
    Write-Host "ALL_CHATS: $outTxt ($sizeKB KB, $msgTotal messages)"
}

$doPush = $Push -or (-not $Push -and -not $Pull)
$doPull = $Pull -or (-not $Push -and -not $Pull)

$local = Get-LocalSessions
$git = Get-GitSessions
$manifest = @{ updated = (Get-Date).ToString('o'); sessions = @{} }
$pushed = 0
$pulled = 0

$allIds = @($local.Keys + $git.Keys | Select-Object -Unique)

foreach ($id in $allIds) {
    $hasLocal = $local.ContainsKey($id)
    $hasGit = $git.ContainsKey($id)

    if ($hasLocal -and $hasGit) {
        $localFile = $local[$id]
        $gitFile = $git[$id]
        if ($doPush -and $doPull) {
            if ($localFile.LastWriteTimeUtc -gt $gitFile.LastWriteTimeUtc) {
                Copy-SessionToGit $id $localFile.FullName
                $pushed++
            } elseif ($gitFile.LastWriteTimeUtc -gt $localFile.LastWriteTimeUtc) {
                Copy-SessionToCursor $id $gitFile.FullName
                $pulled++
            }
        } elseif ($doPush) {
            Copy-SessionToGit $id $localFile.FullName
            $pushed++
        } elseif ($doPull) {
            Copy-SessionToCursor $id $gitFile.FullName
            $pulled++
        }
        $src = if ($localFile.LastWriteTimeUtc -ge $gitFile.LastWriteTimeUtc) { $localFile.FullName } else { $gitFile.FullName }
    } elseif ($hasLocal -and $doPush) {
        Copy-SessionToGit $id $local[$id].FullName
        $src = $local[$id].FullName
        $pushed++
    } elseif ($hasGit -and $doPull) {
        Copy-SessionToCursor $id $git[$id].FullName
        $src = $git[$id].FullName
        $pulled++
    } else {
        continue
    }

    if ($src) {
        Write-ReadableMarkdown $src $id
        $fi = Get-Item -LiteralPath $src
        $manifest.sessions[$id] = @{
            bytes    = $fi.Length
            modified = $fi.LastWriteTimeUtc.ToString('o')
        }
    }
}

$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

Write-AllChatsSingleFile $projectRoot $gitSessions

Write-Host "sync-chats OK: pushed=$pushed pulled=$pulled sessions=$($allIds.Count)"
Write-Host "git folder: $gitSessions"
Write-Host "cursor folder: $cursorRoot"
Write-Host "Next: git add docs/cursor-sessions && git commit && git push  (or pull on other PC first)"
