#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ERRORS=0
WARNINGS=0

pass() { printf "  ✅ %s\n" "$1"; }
fail() { printf "  ❌ %s\n" "$1"; ERRORS=$((ERRORS + 1)); }
warn() { printf "  ⚠️  %s\n" "$1"; WARNINGS=$((WARNINGS + 1)); }

echo "🔍 sunzi-skill 安装验证"
echo "========================"
echo ""

echo "📋 检查 JSON 配置文件..."
for f in .claude-plugin/plugin.json .cursor-plugin/plugin.json hooks/hooks.json package.json; do
  if [ -f "${ROOT}/${f}" ]; then
    if python3 -m json.tool "${ROOT}/${f}" > /dev/null 2>&1; then
      pass "${f} 有效"
    else
      fail "${f} JSON 格式无效"
    fi
  else
    fail "${f} 不存在"
  fi
done
echo ""

echo "📋 检查 Hook 文件..."
for f in hooks/session-start hooks/session-start.ps1 hooks/run-hook.cmd; do
  if [ -f "${ROOT}/${f}" ]; then
    pass "${f} 存在"
  else
    fail "${f} 不存在"
  fi
done
if [ -x "${ROOT}/hooks/session-start" ]; then
  pass "hooks/session-start 可执行"
else
  warn "hooks/session-start 不可执行（运行 chmod +x hooks/session-start）"
fi
echo ""

echo "📋 检查 Skill 文件..."
SKILLS=(
  strategic-thinking
  strategic-calculation
  void-solid-analysis
  know-both-sides
  orthodox-unorthodox
  momentum-timing
  win-before-fighting
  adapt-to-win
  swift-resolution
  indirect-approach
  workflows
)
for s in "${SKILLS[@]}"; do
  skill_path="${ROOT}/skills/${s}/SKILL.md"
  if [ -f "${skill_path}" ]; then
    if head -1 "${skill_path}" | grep -q "^---"; then
      pass "skills/${s}/SKILL.md 存在且有 frontmatter"
    else
      warn "skills/${s}/SKILL.md 存在但缺少 frontmatter"
    fi
  else
    fail "skills/${s}/SKILL.md 不存在"
  fi
done
echo ""

echo "📋 检查 Command 文件..."
COMMANDS=(
  strategic-calculation
  void-solid-analysis
  know-both-sides
  orthodox-unorthodox
  momentum-timing
  win-before-fighting
  adapt-to-win
  swift-resolution
  indirect-approach
  workflows
)
for c in "${COMMANDS[@]}"; do
  cmd_path="${ROOT}/commands/${c}.md"
  if [ -f "${cmd_path}" ]; then
    pass "commands/${c}.md 存在"
  else
    fail "commands/${c}.md 不存在"
  fi
done
echo ""

echo "📋 检查 Agent 文件..."
if [ -f "${ROOT}/agents/terrain-assessor.md" ]; then
  pass "agents/terrain-assessor.md 存在"
else
  warn "agents/terrain-assessor.md 不存在"
fi
echo ""

echo "========================"
if [ ${ERRORS} -eq 0 ] && [ ${WARNINGS} -eq 0 ]; then
  echo "✅ 全部通过！sunzi-skill 安装完整。"
elif [ ${ERRORS} -eq 0 ]; then
  echo "⚠️  通过，但有 ${WARNINGS} 条警告。"
else
  echo "❌ 有 ${ERRORS} 个错误，${WARNINGS} 条警告。请修复后重新验证。"
  exit 1
fi
