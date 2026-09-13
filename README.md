# sci-ppt

**把论文、报告和科研参考图，制作成叙事清楚、证据完整、便于讲解与修改的学术 PowerPoint。**

面向 Codex 的科研演示技能，默认中文交流。两条工作路线：**论文与文件到学术汇报**、**科研参考示意图到可编辑PPT**。支持从头制作及已有演示稿的局部优化。

本技能不是独立的一键PDF转PPT应用。Codex负责阅读材料、设计叙事和版式、调用工具及检查结果；仓库脚本提供生成、桌面会话、渲染和组件检查接口。

## 导航

- [适用场景](#适用场景)
- [完整功能](#完整功能)
- [交付与编辑范围](#交付与编辑范围)
- [安装与环境](#安装与环境)
- [使用示例](#使用示例)
- [脚本入口](#脚本入口)
- [工作流程](#工作流程)
- [限制与数据保护](#限制与数据保护)
- [仓库结构](#仓库结构)

## 适用场景

| 场景 | 输入材料 | 制作重点 |
| --- | --- | --- |
| 导师汇报、组会 | 论文、最终图注、单panel源图 | 沿研究问题串联证据，解释方法与结果 |
| Journal club | PDF、补充材料、阅读笔记 | 区分原文发现、解读与讨论 |
| 答辩、研究进展 | 多份文档、结果图、阶段总结 | 组织研究主线，匹配听众与时长 |
| 科研示意图复现 | 参考图、矢量素材、原始文字 | 可编辑结构与真实图像合理结合 |
| 已有PPT优化 | PPTX、源素材、修改意见 | 调整布局、密度、讲解层次与组件 |

PDF、DOCX、Markdown、图片和已有PPT均可作为任务材料。解析依赖Codex当前可用的文件读取、转换或桌面工具；仓库没有内置通用PDF/DOCX解析器或OCR服务。尽量提供可读取正文、最终图注和清晰源图。

## 完整功能

### 1. 论文叙事与听众适配

- 阅读实际正文、方法、结果及图注，组织“研究问题 → 设计 → 证据 → 综合解释 → 后续讨论”。
- 可沿最终手稿叙事汇报，但不机械逐段复制论文；每页围绕一个问题或判断。
- 按听众、语言和时长调整密度，必要时分主体与备份页。
- 面向非算法背景听众，先解释“输入什么、回答什么、图怎么看”，再介绍算法名称。
- 区分实测、计算推断和拟议实验，保留影响结论的统计单位与来源限定。

### 2. 多图组合与全panel覆盖

- 同页组合相关证据：组成与状态、组织图与定量、主结果与稳定性检查。
- 按真实比例选择并列、上下、大图配解释等布局，不用缩小全部标签换取页数减少。
- 优先使用单panel源图，保留图例、坐标、单位、显著性符号和比例尺。
- 可按要求覆盖全部主图或指定panel，建立“图号/panel → 页码 → 源文件”索引。
- 稠密panel可沿完整子图边界拆开，保留共享图例；不能只截取有利结果。

全panel覆盖和索引由Codex按项目材料实施，不是生成脚本自动识别图号的功能。完整性与少页数冲突时，优先满足用户指定的证据和可读性。

### 3. 中英文图题与讲解层级

- 可保留正式英文图题，并在下方添加忠实的中文译名。
- 正式图题与本页中文讲解标题分层，避免将口头总结误作原文图题。
- 跨图组合页可标明panel来源，并在备注列出对应图题。
- 按实际文字长度调整字号和间距；不保证任意长标题自动适配。

### 4. 讲稿与演讲者备注

- 为每页补充读图顺序、方法解释、统计单位、关键结果和页间过渡。
- 可提供独立Markdown讲稿及PPT内备注。
- 页面突出重点，详细参数放入备注；完整来源可放备注，页脚使用简短图号或出处。

### 5. 科研示意图的可编辑复现

- 文字、简单形状、箭头和结构优先使用PowerPoint原生对象。
- 按结构和编辑价值选择原生路径、独立矢量素材、真实栅格图像或混合组件。
- 照片、实验影像和纹理保留真实像素，可靠分离时可处理背景。
- 不把截图放入PPT后宣称内部可编辑，不把包含位图的SVG称为纯矢量。
- 复杂复现依赖Codex及当前绘图/桌面工具。JSON生成器仅提供文本、图片、矩形与箭头等基础元素，不是任意图形的自动矢量化引擎。

### 6. 语义组件与独立导出

- 重要组件保留稳定ID、类型、页面与对象关联。
- 支持原生组和共享ID的逻辑组件，避免为分组破坏图层顺序。
- 可导出全部已标记组件，或指定单个组件。
- `vector`导出SVG+PNG；`raster`导出PNG；`mixed`导出合成PNG，独立子素材另行保留。
- 导出副本不替换原生母版。SVG导出失败或含位图/foreignObject时明确失败，不冒充纯矢量成功。

标记规则与编辑边界见 [components.md](references/components.md)。

### 7. 桌面可见与迭代修改

- Windows PowerPoint可用时，按绝对路径连接或复用指定演示稿，激活窗口并跳转到指定页。
- 阶段完成时展示，不需逐笔操作UI。桌面不可控时提供文件和阶段预览，不承诺实时编辑。
- 复用未变化对象，只修改相关页面；不强制关闭用户未保存的文档来刷新文件。
- 用户明确要求后可清理旧版本，但先确保最终版及图源、配置、脚本不依赖待删除目录。

### 8. 渲染与质量检查

- 生成时检查对象是否越过页面边界。
- 结构快检支持PPTX、组件目录及可选修改前基线。
- PowerPoint实际渲染输出逐页PNG，并检查文本几何溢出。
- Codex结合预览检查遮挡、缺件、图例、比例尺、清晰度和密度，再集中修复问题页。
- 按需精修与局部复核，不默认生成大量审计文档或文件哈希。

结构检查、对象ID比较和文本溢出数量不能替代科学核查与视觉检查。

## 交付与编辑范围

论文汇报可按项目组织为：

```text
output/
  PPTX/                 # 最终演示稿
  previews/             # 实际渲染的逐页图片
  assets/               # 使用的图像和组件
  speaker_notes.md      # 逐页讲稿
  source_index.md       # 按需提供来源/panel索引
  project/              # 配置和必要的重建脚本
```

讲稿、索引、总览和版本整理由Codex按任务组织，不是每个脚本自动生成。示意图任务通常交付 `Final_editable.pptx`、预览及实际导出的 `Components/`。

| 对象 | 可编辑范围 |
| --- | --- |
| 原生文字、箭头、形状 | 文字、位置、尺寸、样式 |
| 内嵌统计图、组织照片 | 位置和显示大小；不能直接编辑内部数据点 |
| SVG素材 | 取决于素材结构和PowerPoint版本，不自动等于逐对象原生编辑 |
| 混合组件 | 明确区分原生/矢量部分与栅格部分 |

## 安装与环境

在项目根目录运行：

```bash
git clone https://github.com/mingruiy270-debug/sci-ppt.git .agents/skills/sci-ppt
python -m venv .venv-sci-ppt
```

Windows安装依赖：

```powershell
.\.venv-sci-ppt\Scripts\python.exe -m pip install -r .agents/skills/sci-ppt/requirements.txt
```

macOS/Linux安装依赖：

```bash
.venv-sci-ppt/bin/python -m pip install -r .agents/skills/sci-ppt/requirements.txt
```

后续对话使用 `$sci-ppt`，或明确要求读取 `SKILL.md`。未发现技能时重启会话，确认目录被客户端识别。

| 功能 | 环境 |
| --- | --- |
| 基础生成与结构检查 | Python及requirements.txt依赖，可跨平台运行 |
| 本仓库桌面会话、组件导出、实际渲染 | Windows、Windows PowerShell 5.1、桌面Microsoft PowerPoint |
| PDF/DOCX读取、OCR | 当前Codex可用工具，不包含于基础生成器 |
| MCP操作 | 可使用已有PowerPoint接口，不绑定或自动安装特定MCP |

依赖为 `python-pptx>=1.0.2,<2`、`Pillow>=10,<13`。PowerShell通过COM操作PowerPoint，不要求额外安装pywin32。字体需在渲染机器上可用，中文可选Microsoft YaHei；跨机器演示注意字体替换。推荐独立环境，避免干扰分析环境。

## 使用示例

**非算法背景导师汇报**

> 使用 $sci-ppt，依据最终论文、图注和单panel图源制作中文组会汇报。听众熟悉实验研究，但不了解生信算法。按论文叙事多图组合，每页先说明方法回答什么，再讲结果。提供讲稿、演讲者备注及实际渲染预览。

**全部主图panel与双语图题**

> 补齐全部主图panel，保留图例、坐标和统计标记，提供panel到页码及源图的索引。完整性优先于强行压缩页数。英文正式图题下增加中文译名，另保留简短的中文讲解标题。

**示意图复现与组件导出**

> 使用 $sci-ppt 复现科研示意图。文字、箭头及适合原生绘制的结构保持可编辑，实验照片保留真实图像。导出重要组件，明确矢量、栅格及混合类型，并检查连接和遮挡。

**局部修改与最终版整理**

> 只优化指定页面的间距、图像比例和图例位置，不改变结果。实际预览检查后，只保留最终稿及重建材料。删除旧版本前核对依赖，不影响原始论文与数据。

## 脚本入口

无需用户手工写JSON，Codex可准备项目配置。以下 `python` 指已安装依赖的解释器。

### 生成与快检

```bash
python .agents/skills/sci-ppt/scripts/build_deck.py .agents/skills/sci-ppt/examples/synthetic_deck.json --output output/example.pptx
python .agents/skills/sci-ppt/scripts/check_delivery.py --pptx output/example.pptx --details
```

JSON内路径相对配置文件解析。图片按原比例内嵌，不自动裁切；坐标为英寸，字号为pt。默认布局面向16:9横屏，其他比例需调整布局。支持标题、章节、页脚、来源、备注、总结带、图片、文本、矩形及箭头。详见 [deck-spec.md](references/deck-spec.md)。

可选参数：`--components <目录>` 检查组件，`--baseline <修改前PPTX>` 辅助检测原生对象ID丢失；ID变化本身不证明视觉错误。

### 实际渲染

```powershell
powershell.exe -NoProfile -File .agents/skills/sci-ppt/scripts/render_deck.ps1 -PresentationPath output/example.pptx -OutputDirectory output/previews
```

已有输出目录需明确加 `-Overwrite`。仍需检查预览，不能仅依赖退出状态。

### 桌面会话

在Windows PowerShell 5.1中：

```powershell
. ./.agents/skills/sci-ppt/scripts/ppt_session.ps1
$session = Get-SciPptSession -PresentationPath 'output/example.pptx'
Show-SciPptStage -Session $session -Slide 1
```

### 组件导出

```powershell
powershell.exe -NoProfile -File .agents/skills/sci-ppt/scripts/export_components.ps1 -PresentationPath output/Final_editable.pptx -OutputDirectory output/Components
```

需预先按 `SCI_ID`、`SCI_KIND` 等规则标记。`-ComponentId <ID>` 仅导出指定组件，`-PngScale`调整PNG导出倍数，同名覆盖需 `-Overwrite`。普通图片不会自动被识别为语义组件。

## 工作流程

1. 提供权威正文、图注与图像，说明听众、语言、时长及必含内容。
2. Codex阅读实际材料，确定叙事和逐页证据，不将旧摘要当作最新结果。
3. 按清晰度与编辑价值选择素材、原生对象和版式，保留来源。
4. 生成PPT、讲稿及所需索引，实际渲染检查。
5. 局部修复后交付。清理版本前确认最终工程可独立使用。

## 限制与数据保护

- 不创造缺失数据，不改变统计标记以美化结果，不用AI重画实验影像或数据结果。
- 低清源图、缺失字体及被遮挡原文会限制还原，不能凭空补全。
- 不保证任意复杂图自动矢量化；复杂图标签投影阅读困难时，应拆页或放大。
- 无实际渲染环境时明确验证范围，不宣称视觉检查通过。
- 不自动公开论文、作者资料、未发表数据、图像或项目PPT。公共仓库只保存通用技能及合成示例。
- 默认不计算文件哈希、不生成大量审计材料，保留必要来源和重建文件即可。
- 未附加开源许可证，公开可见本身不构成额外许可授权。

## 仓库结构

| 文件 | 用途 |
| --- | --- |
| [SKILL.md](SKILL.md) | 技能入口、工作路线和边界 |
| [agents/openai.yaml](agents/openai.yaml) | 技能展示配置 |
| [paper-to-deck.md](references/paper-to-deck.md) | 论文叙事、证据与听众适配 |
| [deck-spec.md](references/deck-spec.md) | JSON接口 |
| [components.md](references/components.md) | 组件标记与导出 |
| [visible-work.md](references/visible-work.md) | 桌面会话与阶段展示 |
| [deep-review.md](references/deep-review.md) | 按需精修 |
| [build_deck.py](scripts/build_deck.py) | 基础PPTX生成器 |
| [check_delivery.py](scripts/check_delivery.py) | 结构及组件检查 |
| [render_deck.ps1](scripts/render_deck.ps1) | 实际渲染、文本几何检查 |
| [ppt_session.ps1](scripts/ppt_session.ps1) | PowerPoint会话辅助 |
| [export_components.ps1](scripts/export_components.ps1) | 标记组件导出 |
| [synthetic_deck.json](examples/synthetic_deck.json) | 不含科研数据的合成示例 |
| [requirements.txt](requirements.txt) | Python依赖 |

技能版本 **1.2.1**：保留1.1.0的示意图与组件工具，增加论文汇报、讲稿、来源记录和听众适配的多图叙事。本次README完善不改变代码版本。
