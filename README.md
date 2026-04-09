# 孙子 Skill

**给 AI Agent 装上 2500 年前的战略操作系统。**

《孙子兵法》十三篇，5000 余字，被翻译成 29 种语言，至今仍是西点军校、哈佛商学院的参考教材。它的价值不在于教人打仗，而在于提供了一套**通用的决策与行动框架**。

本项目将这套框架提取为 9 个可执行的 AI Agent Skill，让 AI 在面对复杂任务时不再"蛮力推进"，而是先算、先看、先想，再动。

> 灵感来自 [qiushi-skill](https://github.com/HughYau/qiushi-skill) 和 [superpowers](https://github.com/obra/superpowers)。

---

## Quick Start

```bash
# Claude Code
git clone https://github.com/Cosimo-Di-Rondo/sunzi-skill
cd sunzi-skill && claude --plugin-dir .

# Cursor — 克隆后将目录加入插件路径即可
# 通用 — 将 skills/strategic-thinking/SKILL.md 注入 system prompt
```

安装后 AI 会自动加载"兵法思维"路由器。不需要记命令，它会根据场景自动判断是否调用下游 skill。

想手动触发？直接输入 `/strategic-calculation`、`/void-solid-analysis` 等命令。

验证安装：`bash tests/validate.sh`（Windows: `powershell tests/validate.ps1`）

---

## 它做什么

一句话：**让 AI 在动手之前多想一步。**

| AI 的坏习惯 | 孙子怎么说 | 对应的 Skill |
|------------|-----------|-------------|
| 不评估就开干 | "多算胜，少算不胜，而况于无算乎" | `/strategic-calculation` 庙算决策 |
| 硬刚最难的部分 | "兵之形，避实而击虚" | `/void-solid-analysis` 虚实分析 |
| 不了解情况就下判断 | "知彼知己者，百战不殆" | `/know-both-sides` 知彼知己 |
| 方案千篇一律 | "以正合，以奇胜" | `/orthodox-unorthodox` 奇正结合 |
| 不懂借力和造势 | "善战者，求之于势，不责于人" | `/momentum-timing` 势节把握 |
| 没准备好就冲上去 | "胜兵先胜而后求战" | `/win-before-fighting` 先胜后战 |
| 计划失效还死磕 | "兵无常势，水无常形" | `/adapt-to-win` 因敌制胜 |
| 追求完美不交付 | "兵闻拙速，未睹巧之久也" | `/swift-resolution` 速战速决 |
| 一条路走到黑 | "以迂为直，以患为利" | `/indirect-approach` 以迂为直 |

---

## 架构

```
知彼知己（总原则）
│
├── 战略层 ── 庙算决策 · 虚实分析
│               做不做？打哪里？
│
├── 方法层 ── 知彼知己 · 奇正结合 · 势节把握
│               怎么看？怎么想？什么时候动？
│
└── 执行层 ── 先胜后战 · 因敌制胜 · 速战速决 · 以迂为直
                怎么准备？怎么变？怎么快？怎么绕？
```

每个 Skill 都包含：
- **触发条件** — 什么时候该用（以及什么时候不该用）
- **方法流程** — 分步操作指南，每步附《孙子兵法》原文
- **操作规程** — 强制输出格式（庙算评估表、虚实地图、奇正方案……），确保 AI 真正执行而不是空谈
- **常见错误表** — 错误 → 孙子的警告 → 正确做法
- **互引关系** — 各 skill 之间的协作点

还有 3 条预置工作流把多个 skill 串联：

| 场景 | 工作流 |
|------|--------|
| 新项目，不知从何下手 | 知彼知己 → 庙算决策 → 虚实分析 → 先胜后战 |
| 技术难题，需要突破 | 知彼知己 → 虚实分析 → 奇正结合 → 势节把握 → 速战速决 |
| 计划遇阻，需要调整 | 因敌制胜 → 虚实分析 → 以迂为直 → 速战速决 → 因敌制胜(循环) |

---

## 项目结构

```
sunzi-skill/
├── skills/                    # 核心：11 个方法论 Skill
│   ├── strategic-thinking/    # 入口路由器（自动注入）
│   ├── strategic-calculation/ # 庙算决策
│   ├── void-solid-analysis/   # 虚实分析
│   ├── know-both-sides/       # 知彼知己
│   ├── orthodox-unorthodox/   # 奇正结合
│   ├── momentum-timing/       # 势节把握
│   ├── win-before-fighting/   # 先胜后战
│   ├── adapt-to-win/          # 因敌制胜
│   ├── swift-resolution/      # 速战速决
│   ├── indirect-approach/     # 以迂为直
│   └── workflows/             # 工作流编排
├── commands/                  # 手动命令入口（10 个）
├── hooks/                     # Session 自动注入
├── agents/                    # 可派遣的 subagent
├── tests/                     # 安装验证脚本
├── .claude-plugin/            # Claude Code 插件配置
├── .cursor-plugin/            # Cursor 插件配置
└── .codex/                    # Codex 安装入口
```

---

## 与 qiushi-skill 的关系

本项目受 [qiushi-skill](https://github.com/HughYau/qiushi-skill) 启发，采用了相同的 skill 规范（frontmatter + 操作规程 + hooks 注入）。两者定位互补：

| | qiushi-skill | sunzi-skill |
|---|---|---|
| 思想来源 | 毛泽东思想 | 《孙子兵法》 |
| 核心关注 | 如何分析问题（矛盾、实践、调查） | 如何做出决策（评估、取舍、时机） |
| 总原则 | 实事求是 | 知彼知己 |
| 强项 | 长期复杂任务的方法论 | 竞争环境下的战略决策 |

两者可以同时安装、互不冲突。

---

## 关于原文引用

所有引用均出自《孙子兵法》传世文本，标注篇名。这是一部公元前 5 世纪的公共领域著作，本项目仅提取其方法论用于 AI 决策框架，不涉及军事应用。

## 许可证

MIT

---

*善战者之胜也，无智名，无勇功。—— 最好的胜利，看起来毫不费力。*
