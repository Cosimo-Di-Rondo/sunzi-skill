$ErrorActionPreference = 'Continue'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Errors = 0
$Warnings = 0

function Pass($msg) { Write-Host "  ✅ $msg" }
function Fail($msg) { Write-Host "  ❌ $msg"; $script:Errors++ }
function Warn($msg) { Write-Host "  ⚠️  $msg"; $script:Warnings++ }

Write-Host "🔍 sunzi-skill 安装验证"
Write-Host "========================"
Write-Host ""

Write-Host "📋 检查 JSON 配置文件..."
foreach ($f in @('.claude-plugin/plugin.json', '.cursor-plugin/plugin.json', 'hooks/hooks.json', 'package.json')) {
    $path = Join-Path $Root $f
    if (Test-Path $path) {
        try {
            Get-Content $path -Raw | ConvertFrom-Json | Out-Null
            Pass "$f 有效"
        } catch {
            Fail "$f JSON 格式无效"
        }
    } else {
        Fail "$f 不存在"
    }
}
Write-Host ""

Write-Host "📋 检查 Hook 文件..."
foreach ($f in @('hooks/session-start', 'hooks/session-start.ps1', 'hooks/run-hook.cmd')) {
    $path = Join-Path $Root $f
    if (Test-Path $path) { Pass "$f 存在" } else { Fail "$f 不存在" }
}
Write-Host ""

Write-Host "📋 检查 Skill 文件..."
$skills = @(
    'strategic-thinking', 'strategic-calculation', 'void-solid-analysis',
    'know-both-sides', 'orthodox-unorthodox', 'momentum-timing',
    'win-before-fighting', 'adapt-to-win', 'swift-resolution',
    'indirect-approach', 'workflows'
)
foreach ($s in $skills) {
    $path = Join-Path $Root "skills/$s/SKILL.md"
    if (Test-Path $path) {
        $firstLine = Get-Content $path -TotalCount 1
        if ($firstLine -eq '---') {
            Pass "skills/$s/SKILL.md 存在且有 frontmatter"
        } else {
            Warn "skills/$s/SKILL.md 存在但缺少 frontmatter"
        }
    } else {
        Fail "skills/$s/SKILL.md 不存在"
    }
}
Write-Host ""

Write-Host "📋 检查 Command 文件..."
$commands = @(
    'strategic-calculation', 'void-solid-analysis', 'know-both-sides',
    'orthodox-unorthodox', 'momentum-timing', 'win-before-fighting',
    'adapt-to-win', 'swift-resolution', 'indirect-approach', 'workflows'
)
foreach ($c in $commands) {
    $path = Join-Path $Root "commands/$c.md"
    if (Test-Path $path) { Pass "commands/$c.md 存在" } else { Fail "commands/$c.md 不存在" }
}
Write-Host ""

Write-Host "========================"
if ($Errors -eq 0 -and $Warnings -eq 0) {
    Write-Host "✅ 全部通过！sunzi-skill 安装完整。"
} elseif ($Errors -eq 0) {
    Write-Host "⚠️  通过，但有 $Warnings 条警告。"
} else {
    Write-Host "❌ 有 $Errors 个错误，$Warnings 条警告。请修复后重新验证。"
    exit 1
}
