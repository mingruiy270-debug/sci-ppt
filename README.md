# sci-ppt

**将论文、报告和科研参考图制作成讲得清、看得懂、可编辑的学术 PPT。**

适用于 Codex 的科研演示技能，支持论文组会汇报和参考示意图复现，默认中文，保留科学结果。

## 功能

| 输入 | 输出 |
| --- | --- |
| PDF、Word、Markdown论文和单panel图源 | 学术汇报PPT、逐页讲稿、来源说明及渲染预览 |
| 科研流程图、参考示意图 | 可编辑文字与结构、语义组件、适用的SVG与透明PNG |
| 已有PPT与修改要求 | 调整叙事、图文组合与排版，保留原有证据 |

## 汇报设计

- **问题串联证据**：研究问题 → 设计 → 关键结果 → 综合解释 → 后续讨论。
- **按听众解释方法**：跨专业汇报先说明方法解决什么问题，再介绍算法名称。首次出现的术语配简短解释。
- **相关多图组合**：同页组合主证据与佐证图，减少无效留白；不以缩小坐标与图例换取页数减少。
- **编辑范围清晰**：标题、解释、流程和有出处的概括数值使用原生对象；实验照片和统计图保留原图。
- **讲稿承载细节**：备注说明读图顺序、统计单位、关键数值与页间过渡。
- **实际检查**：检查对象边界，并在有PowerPoint时渲染，复查图例、比例尺和遮挡。

## 安装

在项目根目录运行：

```bash
git clone https://github.com/mingruiy270-debug/sci-ppt.git .agents/skills/sci-ppt
python -m venv .venv-sci-ppt
# 按操作系统激活虚拟环境后：
python -m pip install -r .agents/skills/sci-ppt/requirements.txt
```

下一轮Codex对话使用 `$sci-ppt`；若尚未发现技能，重启会话。依赖建议独立安装，避免影响科研分析环境。

## 使用示例

**导师组会汇报**

> 使用 $sci-ppt，根据论文和单panel图源制作约20分钟的中文组会汇报。听众熟悉实验生物学，但不熟悉生信算法。按论文最终叙事组织，以相关多图解释每个问题，保留完整图例，提供中文讲稿和逐页预览。

**科研示意图复现**

> 使用 $sci-ppt，将参考图复现为可编辑PPT。普通文字、箭头和简单结构使用原生对象，实验照片保持真实图像，并导出重要组件。

## 可选脚本入口

不需要用户手工写JSON，Codex可以根据材料准备输入。需要复用或调试时可运行合成示例：

```bash
python .agents/skills/sci-ppt/scripts/build_deck.py .agents/skills/sci-ppt/examples/synthetic_deck.json --output output/example.pptx
python .agents/skills/sci-ppt/scripts/check_delivery.py --pptx output/example.pptx
```

字段说明见 [deck-spec.md](references/deck-spec.md)。合成示例不包含科研结果。

生成器可跨平台运行。桌面渲染工具需要Windows PowerShell 5.1和Microsoft PowerPoint：

```powershell
powershell.exe -NoProfile -File .agents/skills/sci-ppt/scripts/render_deck.ps1 -PresentationPath output/example.pptx -OutputDirectory output/previews
```

组件导出见 [components.md](references/components.md)。可使用已有PowerPoint控制接口，不绑定特定MCP名称。

## 编辑范围与数据

原生文字、形状、箭头及数值概括可编辑。嵌入的科研图不能在PPT内直接修改其中的数据点。结构检查不等于科学核查或视觉检查；未实际渲染时会说明验证范围。

不自动上传论文、数据或图像。本仓库只有通用技能与合成示例。未附加开源许可证，公开可见本身不构成额外许可授权。

版本 **1.2.1**：保留1.1.0示意图工具，增加论文汇报及面向不同听众的多图叙事。
