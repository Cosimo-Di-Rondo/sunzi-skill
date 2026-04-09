$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PluginRoot = Split-Path -Parent $ScriptDir
$SkillPath = Join-Path $PluginRoot 'skills' 'strategic-thinking' 'SKILL.md'

if (-not (Test-Path $SkillPath)) {
    Write-Error "Error: missing skill file at $SkillPath"
    exit 1
}

$content = Get-Content -Path $SkillPath -Raw -Encoding UTF8
$escaped = $content -replace '\\', '\\\\' -replace '"', '\"' -replace "`r`n", '\n' -replace "`n", '\n' -replace "`r", '\r' -replace "`t", '\t'

$sessionContext = "<SUNZI_SKILL>\n已加载 sunzi:strategic-thinking。请先遵守用户指令、项目约束和宿主平台规则，再在明确适用时把这份方法论作为补充的路由与校验框架。\n\n$escaped\n\n</SUNZI_SKILL>"

if ($env:CURSOR_PLUGIN_ROOT) {
    Write-Output "{`n  `"additional_context`": `"$sessionContext`"`n}"
} elseif ($env:CLAUDE_PLUGIN_ROOT) {
    Write-Output "{`n  `"hookSpecificOutput`": {`n    `"hookEventName`": `"SessionStart`",`n    `"additionalContext`": `"$sessionContext`"`n  }`n}"
} else {
    Write-Output "{`n  `"additional_context`": `"$sessionContext`"`n}"
}

exit 0
