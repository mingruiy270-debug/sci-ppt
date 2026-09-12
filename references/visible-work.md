# 可见阶段与会话复用

优先使用当前可用 PowerPoint 控制接口。模型已在一个文档会话中制作时直接沿用，不重复打开、保存或生成同一页。

Windows 可选辅助接口：

```powershell
. ./scripts/ppt_session.ps1
$session = Get-SciPptSession -PresentationPath 'D:\work\Final_editable.pptx'
# 模型用 $session.Deck 自由执行当前批次的制作操作。
Show-SciPptStage -Session $session -Slide 1
```

使用 Windows PowerShell 5.1。`Get-SciPptSession` 按绝对路径复用已打开文档，不默认取任意活动页；`Show-SciPptStage` 激活对应窗口并跳转到指定页。尽量在同一个执行会话中调用并保留变量。辅助接口不负责生成 PPT，也不会自行保存或关闭。

主体完成、页面完成、重要修改完成时调用刷新即可。无需每个图元都切换窗口或截图。不要设置人为延时。

批量文件生成方式可以在阶段文件保存完成后展示快照。若文件在外部更新而 PowerPoint 仍持有旧版本，应先检查未保存修改；不能关闭有未保存编辑的文档来强行刷新。可打开独立阶段副本或展示最新 PNG，明确称作阶段预览。

桌面不可控时继续当前最佳生成方式，提供简短进度与最终预览，不承诺实时编辑。前台展示不能通过重画全页或逐笔 UI 操作显著拖慢制作。
