---
name: sci-ppt
description: Create evidence-led academic PowerPoint presentations from papers, documents and figure assets, or reconstruct reference diagrams as editable PowerPoint. Use for journal clubs, lab meetings, thesis talks, paper-to-PPT and scientific image-to-PPT tasks, with speaker notes and rendered slide checks.
metadata:
  version: "1.2.1"
---

# sci-ppt skill

版本 1.2.1。默认中文沟通。模型自主理解科学问题、选择证据、决定版式和工具，交付真正可用的可编辑 PPTX。

## 按任务读取

- 论文、DOCX、PDF、Markdown、报告或组会汇报：先读 [paper-to-deck.md](references/paper-to-deck.md)。以科学论证组织幻灯片，配套讲稿与图源。允许按用户要求重新设计视觉表达。
- 参考图或单张示意图复现：按下面的原有图形复现流程，保持参考语义和视觉关系。
- 两者结合：结果图保留原始证据，讲解文字与新示意流程原生可编辑。复杂组件按需导出。

## 可用工具

跨平台生成入口为 `scripts/build_deck.py`，输入格式见 [deck-spec.md](references/deck-spec.md)。依赖可在项目独立 venv 中通过 `pip install -r requirements.txt` 安装。Windows 桌面有 PowerPoint 时，使用 `scripts/render_deck.ps1` 实际打开、渲染和检查文字溢出；也可使用已有 PowerPoint MCP。无 Office 时如实说明仅完成结构检查，不能把结构检查称作视觉检查。

公开技能时仅打包通用脚本、说明和合成示例。论文、未发表图像、讲稿、作者信息、账号信息、虚拟环境与测试输出留在用户工作区；公开这些材料需单独明确授权。不要默认计算文件哈希。

## 执行

1. 接收参考图与目标，沿用已有理解。目标明确即开始；只有缺少必需输入或科学语义歧义才提问，不提供模式菜单。不要求预先写完整对象清单。
2. 自主制作。以可编辑复现为目标：普通文字、箭头和简单框尽可能原生；能合理表达的复杂示意结构也倾向原生形状或真实路径，不因复杂、图元多、组件化或导出方便改用参考裁片。照片、实验影像、真实纹理与复杂效果可保留栅格；主体能可靠分离时可直接去背景，无需重绘。模型结合当前图像、内部编辑需求和源素材灵活选择，不按语义名称写死路线，不要求先尝试失败。重要组件随制作保留关联，复用已有生成结构，不另建分析阶段。
3. 展示进展。桌面可控时读取 [visible-work.md](references/visible-work.md)，尽早显示工作页并在关键阶段更新，允许批量制作。只有阶段快照时如实说明。不要为展示而重写生成流程或逐笔等待。
4. 整理导出。复杂组件或替换任务按需读取 [components.md](references/components.md)。保持语义边界和原有遮挡，不为了分组打乱层级。只导出重要复杂组件，已有合格资产直接复用，原生文字、箭头、简单框不单独导出。
5. 快速交付。复用最终渲染，检查关键文字、主体比例、缺件、连接、遮挡与透明边缘；并确认文件可打开、重要组件完整。仅集中修正明显问题，再复查受影响区域。没有实质问题即停止。可用 `scripts/check_delivery.py` 快检，默认不输出报告。

## 边界

不使用整页或局部裁片伪装可编辑示意结构；独立源素材不等于参考页裁片。栅格边界不能夹带邻接标签、箭头和其他组件。有 Alpha 不等于边界干净。已经完成的原生对象按语义组合后导出副本，PPT 母版保留原生子对象，禁止用导出图片替换。含位图的 SVG 不称纯矢量。禁止默认美化或改变语义；实际卡顿时仅调整对应组件。

后续修改复用未变化对象与资产，只更新相关组件和页面。默认不启用全局缓存或逐组件深检；用户主动要求精修时才读取 [deep-review.md](references/deep-review.md)。

用户交付后可指定“把这个组件改为原生矢量”或“这里保留原图只去背景”。沿用页面位置和关系，重新评估可行性，仅替换指定组件、更新相应导出和预览；无法达到的内部编辑性如实说明，不重跑全页。

图形复现交付 `Final_editable.pptx`、最终预览及实际存在的 `Components/`。论文汇报交付 PPTX、逐页预览和带来源的讲稿；内部工程与成品分目录。真矢量提供 SVG 与透明 PNG，栅格提供 PNG，混合素材如实保留子资产。简短说明原生、矢量与栅格的实际编辑边界。Skill 不切换模型，不保证零额外耗时。
