ideavim配置文件备份
```txt
" ================================================================================================  
" = 软件全局设置 =====================================" ================================================================================================  
" 这些快捷键都是设置在软件快捷键中的，为了在软件的任何位置都可以触发，在这里记录一下  
" 1.ctrl + shift + f增强，在finder中打开(设置于全局快捷键) => RevealIn  
" 2.常用区域切换：编辑区option + , 文件目录区：option + . 终端 option + /  
  
" ================================================================================================  
" = 基础设置 =====================================" ================================================================================================  
" 共享系统粘贴板  
set clipboard+=unnamed  
" 搜索忽略大小写  
set ignorecase  
" 上下方保留5行预览代码  
set scrolloff=5  
" 设置命令历史记录条数  
set history=200  
" 显示当前行的绝对行号  
set nonumber  
" 其它行显示相对行号  
set norelativenumber  
" 打开增量搜索模式,随着键入即时搜索  
set incsearch  
" 搜索高亮  
set hlsearch  
" 保证normal模式是英文键盘  
" set keep-english-in-normal  
" set keep-english-in-normal-and-restore-in-insert  
  
" ================================================================================================  
" = 插件 =====================================" ================================================================================================  
" https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins  
set NERDTree  
set easymotion  
set multiple-cursors  
" set commentary  
" set argtextobj  
" set textobj-entire  
" set ReplaceWithRegister  
" set exchange  
" set vim-paragraph-motion  
" set textobj-indent  
" set sneak  
" set surround  
  
" ================================================================================================  
" = 插件设置 =====================================" ================================================================================================  
" == AceJump  
" f激活搜索 F激活目标模式，搜索并选择目标 g激活行模式  
" 使用技巧：1.搜索完成后，跳转到目标位置时，按住shift，可以选中当前位置到目标位置 2.搜索之后按enter可以在多个目标中跳转  
map f <Action>(AceAction)  
map F <Action>(AceTargetAction)  
" map g <Action>(AceLineAction)  
  
" multiple-cursors  多光标  
" 用法：mc开启多光标选择功能，可以先选中需要的文本再开启,再次按mc结束选择完成多光标选中  
" mx跳过当前，选择下一个，mp放弃当前选中的这个，用于多次按mc选中多个位置的同一单词时  
map mc <A-n>  
map mx <A-x>  
map mp <A-p>  
  
" == NERDTree  
" https://github.com/JetBrains/ideavim/blob/master/doc/NERDTree-support.md完整命令  
" 1.在目录树中，使用空格预览文件  
" 2.o打开文件/目录，s右侧拆分打开文件，i垂直拆分打开文件，O循环打开目录下的文件夹  
" 3.x关闭当前目录 p跳转到当前父目录，P跳转到根目录,m打开文件操作菜单  
" 4.注意不要开启单次点击就打开文件  
  
" 在目录树中定位当前文件(tip: 使用gf代替了)  
" 必须在这个设置，否则ctrl + f为vim的默认行为，在软件快捷键中设置会无效  
"nnoremap <C-f> :NERDTreeFind<CR>  
"nmap <C-f> <action>(SelectInProjectView)  
"vmap <C-f> <action>(SelectInProjectView)  
  
" ===============================================================================================  
" = 按键映射 =====================================" ================================================================================================  
" == 在普通和插入模式下，向下交换行/向上交换行  
" nmap <leader>mu <action>(MoveStatementUp)  
" nmap <leader>md <action>(MoveStatementDown)  
nnoremap <C-s-j> :m +1<CR>  
nnoremap <C-s-k> :m -2<CR>  
inoremap <C-s-j> <Esc> :m +1<CR>gi  
inoremap <C-s-k> <Esc> :m -2<CR>gi  
xnoremap <C-s-j> :m '>+1<cr>gv=gv  
xnoremap <C-s-k> :m '<-2<cr>gv=gv  
  
" == 跳转 & 移动  
" 移动通常绑定HJKL  
" 上下左右  
nnoremap H ^  
nnoremap L g_  
nnoremap J 10j  
nnoremap K 10k  
  
vnoremap H ^  
vnoremap L g_  
vnoremap J 10j  
vnoremap K 10k  
" w下一单词 e当前单词词尾 b前一单词  
  
" Tab切换  
nnoremap <tab> gt  
vnoremap <tab> gt  
nnoremap <s-tab> gT  
vnoremap <s-tab> gT  
  
"跳转到下一个错误或警告  
"nmap ge <action>(GotoNextError)  
"在源代码和测试代码之间快速切换  
"nmap gt <action>(GotoTest)  
"将光标移动到上一个方法的声明处  
nmap gm <action>(MethodUp)  
"跳转到当前接口或抽象类的实现处  
nmap ga <action>(GotoImplementation)  
"gd跳转到实现，同时可以反向跳转到使用的地方  
"跳转到当前接口或抽象类的实现处  
nmap gf <action>(SelectInProjectView)  
  
" 窗口之间光标移动, ctrl+h更快，但是被系统全局分屏占用了  
nnoremap gh <c-w>h  
nnoremap gl <c-w>l  
nnoremap gj <c-w>j  
nnoremap gk <c-w>k  
  
" 跳转常用窗口  
" 常用区域切换：编辑区option + , 文件目录区：option + . 终端 option + /  
" == GIT相关 (option + u开头 粘滞键)  
" 提交：option + y  
" GIT面板: option + u  
" 推送：option + i  
" 提交面板： option + o" 拉取：option + p  
" 回撤：option + h  
" 分支：option + b  
" 查看差异：option + l  
" 查看文件历史: option + n  
" nnoremap g- <action>(PreviousDiff)  
" nnoremap g= <action>(NextDiff)  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
let g:WhichKeyDesc_LeaderKeymap= "<leader> 🌟🌟🌟紫色为二级目录🌟🌟🌟"  
let g:WhichKeyDesc_RunOrRe_Run = "<leader>ru 运行"  
map <leader>ru <action>(Run)  
  
  
nmap <CR> o<Esc>  
nmap <S-Enter> O<Esc>
```

完整配置还未移植：
```txt
  
" ===============================================================================================  
" = 无引导键映射 =====================================" ================================================================================================  
" e: Extract  
" extract method/function 将选中的代码片段提取为一个独立的方法(Ctrl + Alt + M)  
vmap <leader>em <action>(ExtractMethod)  
" extract constant （引入常量）的重构操作:将选中的代码片段抽取为一个常量，并自动替换选中的代码片段为新的常量引用(Ctrl + Alt + C)  
vmap <leader>ec <action>(IntroduceConstant)  
" extract field （引入字段）的重构操作:将选中的代码片段转化为一个新的字段，并自动将选中的代码片段替换为对该字段的引用(Ctrl + Alt + F)  
vmap <leader>ef <action>(IntroduceField)  
" extract variable （引入变量）的重构操作:将选中的代码片段抽取为一个新的变量，并自动替换选中的代码片段为新的变量引用(Ctrl + Alt + V)  
vmap <leader>ev <action>(IntroduceVariable)  
  
  
  
  
" input in somewhere  
" 在标签内输入  
nmap ti f>a  
" 在函数参数末输入  
nmap mi gmf)i  
  
  
" 标记和书签  
map ma <action>(ToggleBookmark)  
  
map ms mS  
map md mD  
map mf mF  
  
map 's 'S  
map 'd 'D  
map 'f 'F  
" map ' `  
  
" 窗口拆分  
nnoremap <c-\> :action SplitVertically<CR>  
nnoremap <c--> :action SplitHorizontally<CR>  
nnoremap <c-m> :action MoveEditorToOppositeTabGroup<CR>  
nnoremap ;q :action Unsplit<CR>  
nnoremap ;a :action UnsplitAll<CR>  
  
  
  
  
  
" ================================================================================================  
" = 引导键映射 =====================================" ================================================================================================  
" 引导键 推荐空格  
let mapleader=" "  
  
  
" ================================================================================================  
"  Which-Key  
" ================================================================================================  
set which-key  
set notimeout  
  
let g:WhichKeyDesc_LeaderKeymap= "<leader> 🌟🌟🌟紫色为二级目录🌟🌟🌟"  
" a ⭐️  
let g:WhichKeyDesc_a = "<leader>a 作者"  
nmap <leader>a <action>(Annotate)  
  
  
  
" b ⭐️  
let g:WhichKeyDesc_b = "<leader>b 断点"  
nmap <leader>b <action>(ToggleLineBreakpoint)  
  
  
" c ⭐️  
let g:WhichKeyDesc_c = "<leader>c 关闭/拷贝"  
  
let g:WhichKeyDesc_c_CloseCurrentFile = "<leader>cc 关闭当前标签"  
nmap <leader>cc <action>(CloseContent)  
  
let g:WhichKeyDesc_c_CloseAllEditors = "<leader>ca 关闭所有标签"  
nmap <leader>ca <action>(CloseAllEditors)  
  
let g:WhichKeyDesc_c_CloseAllEditorsButActive = "<leader>co 关闭其他标签"  
nmap <leader>co <action>(CloseAllEditorsButActive)  
  
let g:WhichKeyDesc_c_CopyFunction = "<leader>cf 拷贝当前函数"  
nmap <leader>cf Vg_%y  
  
let g:WhichKeyDesc_CodeAndClose_CodeCompletion = "<leader>cq 代码自动补全"  
nmap <leader>cq <action>(CodeCompletion)  
  
  
" d ⭐️  
let g:WhichKeyDesc_d = "<leader>d 删除/勿扰"  
  
let g:WhichKeyDesc_d_DeleteObject = "<leader>do 删除{}"  
nmap <leader>do S<space>{Vg_%D  
  
let g:WhichKeyDesc_d_DeleteFunction = "<leader>df 删除函数"  
nmap <leader>df gmVg_%d  
  
let g:WhichKeyDesc_d_NotDisturbMode = "<leader>dd 勿扰模式"  
nmap <leader>dd <action>(ToggleDistractionFreeMode)  
  
  
" f ⭐  
let g:WhichKeyDesc_f = "<leader>f 查找/格式化"  
  
let g:WhichKeyDesc_f_FindInCurrentFile = "<leader>ff 当前文件查找"  
nmap <leader>ff <action>(Find)  
vmap <leader>ff <action>(Find)  
  
let g:WhichKeyDesc_f_FindInAllFile = "<leader>fa 全文件查找"  
nmap <leader>fa <action>(FindInPath)  
vmap <leader>fa <action>(FindInPath)  
  
let g:WhichKeyDesc_f_FindUsages = "<leader>fu 查找用法"  
nmap <leader>fu <action>(FindUsages)  
vmap <leader>fu <action>(FindUsages)  
  
let g:WhichKeyDesc_f_FormatCode = "<leader>fc 格式化代码"  
nmap <leader>fc <action>(ReformatCode) \| <action>(OptimizeImports)  
vmap <leader>fc <action>(ReformatCode) \| <action>(OptimizeImports)  
  
let g:WhichKeyDesc_f_FullScreen = "<leader>fs 全屏"  
nmap <leader>fs <action>(ToggleZenMode)  
vmap <leader>fs <action>(ToggleZenMode)  
"打开 "Find Action"（查找动作）对话框(Ctrl + Shift + A)  
let g:WhichKeyDesc_FindOrFormat_Commands = "<leader>fq 查找动作"  
nmap <leader>fq <action>(GotoAction)  
  
  
" g ⭐️  
let g:WhichKeyDesc_Git = "<leader>g Git"  
  
let g:WhichKeyDesc_Git_GitPull = "<leader>gu 拉取"  
nmap <leader>gu <action>(Git.Pull)  
vmap <leader>gu <action>(Git.Pull)  
  
let g:WhichKeyDesc_Git_GitCommit = "<leader>gc 提交"  
nmap <leader>gc <action>(CheckinProject)  
vmap <leader>gc <action>(CheckinProject)  
  
let g:WhichKeyDesc_Git_GitPush = "<leader>gp 推送"  
nmap <leader>gp <action>(Vcs.Push)  
vmap <leader>gp <action>(Vcs.Push)  
  
let g:WhichKeyDesc_Git_GitCommitPush = "<leader>gp 提交并推送"  
nmap <leader>gp <action>(Git.Commit.And.Push.Executor)  
vmap <leader>gp <action>(Git.Commit.And.Push.Executor)  
  
let g:WhichKeyDesc_Git_GitReset = "<leader>gr 回滚"  
nmap <leader>gr <action>(ChangesView.Revert)  
vmap <leader>gr <action>(ChangesView.Revert)  
  
"diff 显示文件的版本控制历史(git)  
let g:WhichKeyDesc_DebugOrDelete_ShowTabbedFileHistory = "<leader>gd 显示文件的版本控制历史"  
nmap <leader>gd <action>(Vcs.ShowTabbedFileHistory)  
  
"生成构造器  
let g:WhichKeyDesc_GitOrGenerate_GenerateConstructor = "<leader>gc 生成构造器"  
nmap <leader>gc :action GenerateConstructor<CR>  
"生成getter  
let g:WhichKeyDesc_GitOrGenerate_GenerateGetter = "<leader>gg 生成getter"  
nmap <leader>gg :action GenerateGetter<CR>  
"生成setter  
let g:WhichKeyDesc_GitOrGenerate_GenerateSetter = "<leader>gs 生成setter"  
nmap <leader>gs :action GenerateSetter<CR>  
"生成setter和getter  
let g:WhichKeyDesc_GitOrGenerate_GenerateGetterAndSetter = "<leader>ga 生成setter和getter"  
nmap <leader>ga <action>(GenerateGetterAndSetter)  
"生成 equals() 和 hashcode() 的重写方法  
let g:WhichKeyDesc_GitOrGenerate_GenerateEquals = "<leader>ge 生成equals和hashcode的重写"  
nmap <leader>ge <action>(GenerateEquals)  
"生成toString  
let g:WhichKeyDesc_GitOrGenerate_GenerateToString = "<leader>ge 生成toString"  
nmap <leader>gt <action>(Actions.ActionsPlugin.GenerateToString)  
  
  
  
" h ⭐️  
let g:WhichKeyDesc_TagLeft = "<leader>h 左切标签"  
nnoremap <leader>h gT  
vnoremap <leader>h gT  
  
  
" j ⭐️  
let g:WhichKeyDesc_Jump = "<leader>j 跳转"  
  
let g:WhichKeyDesc_Jump_EveryWhere = "<leader>je 任意跳转"  
nmap <leader>je :action AceAction<CR>  
vmap <leader>je :action AceAction<CR>  
  
let g:WhichKeyDesc_Jump_JumpAndSelect = "<leader>js 跳转并选择"  
map <leader>js :action AceTargetAction<CR>  
  
let g:WhichKeyDesc_Jump_JumpFile = "<leader>jf 跳转到文件"  
nmap <leader>jf <action>(GotoFile)  
  
let g:WhichKeyDesc_Jump_OpenedProject = "<leader>jp 跳转到已打开项目"  
nmap <leader>jp <action>(OpenProjectWindows)  
  
  
" l ⭐️  
let g:WhichKeyDesc_TagRight = "<leader>l 右切标签"  
nnoremap <leader>l gt  
vnoremap <leader>l gt  
  
  
" n ⭐️  
let g:WhichKeyDesc_n = "<leader>n 取消"  
  
  
let g:WhichKeyDesc_No_NoAllNotice = "<leader>nn 清除所有通知"  
nmap <leader>nn <action>(ClearAllNotifications)  
vmap <leader>nn <action>(ClearAllNotifications)  
  
let g:WhichKeyDesc_No_Highlight = "<leader>nh 取消高亮"  
nmap <leader>nh :nohlsearch<CR>  
vmap <leader>nh :nohlsearch<CR>  
  
  
" r ⭐️  
let g:WhichKeyDesc_r = "<leader>r 运行/替换/重构"  
  
let g:WhichKeyDesc_r_Run = "<leader>ru 运行"  
nmap <leader>ru <action>(Run)  
  
let g:WhichKeyDesc_r_RunDebug = "<leader>rd 调试"  
nmap <leader>rd <action>(DebugClass)  
"调试  
let g:WhichKeyDesc_DebugOrDelete_DeBug = "<leader>db 调试"  
nmap <leader>db <Action>(Debug)  
  
let g:WhichKeyDesc_r_RunConfiguration = "<leader>rg 运行配置"  
nmap <leader>rg <action>(RunConfiguration)  
  
let g:WhichKeyDesc_r_ReopenClosedTab = "<leader>rc 重开最近关闭标签"  
nmap <leader>rc <action>(ReopenClosedTab)  
  
let g:WhichKeyDesc_r_ExtractMethod = "<leader>rm 提取方法"  
nmap <leader>rm <action>(ExtractMethod)  
vmap <leader>rm <action>(ExtractMethod)  
  
let g:WhichKeyDesc_r_RenameElement = "<leader>rn 重构变量名"  
nmap <leader>rn <action>(RenameElement)  
vmap <leader>rn <action>(RenameElement)  
  
let g:WhichKeyDesc_r_ReplaceInCurrentFile = "<leader>rr 当前文件替换"  
nmap <leader>rr <action>(Replace)  
vmap <leader>rr <action>(Replace)  
  
let g:WhichKeyDesc_r_ReplaceInAllFile = "<leader>ra 全文件替换"  
nmap <leader>ra <action>(ReplaceInPath)  
vmap <leader>ra <action>(ReplaceInPath)  
  
let g:WhichKeyDesc_r_RollbackChangedLines = "<leader>rl 回滚行"  
nmap <leader>rl <action>(Vcs.RollbackChangedLines)  
vmap <leader>rl <action>(Vcs.RollbackChangedLines)  
  
  
" s ⭐️  
let g:WhichKeyDesc_Show = "<leader>s 显示/停止"  
  
let g:WhichKeyDesc_s_ShowCurrentChange = "<leader>sc 显示光标下的变更"  
nmap <leader>sc <action>(VcsShowCurrentChangeMarker)  
  
let g:WhichKeyDesc_s_ShowErrorDescription = "<leader>se 显示错误描述"  
nmap <leader>se <action>(ShowErrorDescription)  
  
let g:WhichKeyDesc_Show_Bookmarks = "<leader>sb 书签列表"  
nmap <leader>sb <action>(ShowBookmarks)  
  
let g:WhichKeyDesc_Show_ShowFileStructure = "<leader>ss 文件结构"  
nmap <leader>ss <action>(FileStructurePopup)  
  
let g:WhichKeyDesc_s_StopRun = "<leader>st 停止运行"  
nmap <leader>st <action>(Stop)  
  
  
" z 折叠 ⭐️  
let g:WhichKeyDesc_Zip = "<leader>z 折叠"  
  
let g:WhichKeyDesc_Zip_unZipAll = "<leader>zo 展开所有"  
nmap <leader>zo <action>(ExpandAllRegions)  
vmap <leader>zo <action>(ExpandAllRegions)  
  
let g:WhichKeyDesc_Zip_ZipAll = "<leader>zc 折叠所有"  
nmap <leader>zc <action>(CollapseAllRegions)  
vmap <leader>zc <action>(CollapseAllRegions)  
  
  
" ================================================================================================  
" = 额外的 =====================================" ================================================================================================  
  
" 重新加载 .ideavimrclet g:WhichKeyDesc_ReloadVimRc = "<leader>~ ReloadVimRc"  
nmap <leader>~ <action>(IdeaVim.ReloadVimRc.reload)  
  
"激活项目工具窗口(Alt + 1)  
let g:WhichKeyDesc_ToggleExplorerOrExtract = "<leader>e 打开文件列表"  
nmap <leader>e <action>(ActivateProjectToolWindow)  
  
"在当前目录新建文件夹  
let g:WhichKeyDesc_NERDTreeOrNew_NewDir = "<leader>nd 新建文件夹"  
nmap <leader>nd <action>(NewDir)  
"在当前目录新建类  
let g:WhichKeyDesc_NERDTreeOrNew_NewClass = "<leader>nc 新建.Class"  
nmap <leader>nc <action>(NewClass)  
  
"从剪切板粘贴到下面行  
let g:WhichKeyDesc_PasteClipboardDown = "<leader>p 从剪切板粘贴到下面行"  
nmap <leader>p o<esc>p  
"从剪切板粘贴到上面行  
let g:WhichKeyDesc_PasteClipboardUp = "<leader>P 从剪切板粘贴到上面行"  
nmap <leader>P "+P  
"在可视模式中：从剪切板粘贴到下面行  
let g:WhichKeyDesc_PasteClipboardDown = "<leader>p 从剪切板粘贴到下面行"  
vmap <leader>p "+p  
"在可视模式中：从剪切板粘贴到上面行  
let g:WhichKeyDesc_PasteClipboardUp = "<leader>P 从剪切板粘贴到上面行"  
vmap <leader>P "+P  
  
let g:WhichKeyDesc_RunOrRe = "<leader>r 运行&重新"  
  
"运行当前编辑器中的文件或类(Shift + F10)  
let g:WhichKeyDesc_RunOrRe_RunCalss = "<leader>rc 运行当前文件"  
nmap <leader>rc :action RunClass<CR>  
"重新运行最近一次运行的程序或测试(Ctrl+Shift + F10)  
let g:WhichKeyDesc_RunOrRe_ReRun = "<leader>rr 重新运行"  
nmap <leader>rr <action>(Rerun)  
"重新运行最近一次运行的测试（Unit Tests）(Ctrl + Shift + F10)  
let g:WhichKeyDesc_RunOrRe_ReRunTests = "<leader>rt 重新运行Test"  
nmap <leader>rt <action>(RerunTests)  
"在代码中快速更改一个标识符的名称，并自动处理所有相关的引用(Shift + F6)  
let g:WhichKeyDesc_RunOrRe_Rename = "<leader>rn 重构"  
map <leader>rn <action>(RenameElement)  
"运行  
let g:WhichKeyDesc_RunOrRe_Run = "<leader>ru 运行"  
map <leader>ru <action>(Run)  
  
let g:WhichKeyDesc_Show = "<leader>s 显示&停止"  
  
"显示当前打开文件的文件结构弹出窗口，其中包含文件中的类、方法、字段等结构(Alt + 7)  
let g:WhichKeyDesc_Show_FileStructure = "<leader>ss 显示文件结构"  
nmap <leader>ss <action>(FileStructurePopup)  
"显示书签（Bookmarks）工具窗口，其中包含当前文件中设置的书签列表(Ctrl + F11)  
let g:WhichKeyDesc_Show_Bookmarks = "<leader>sb 显示书签工具窗口"  
nmap <leader>sb <action>(ShowBookmarks)  
"用于显示方法或函数的参数信息(Ctrl + p)  
let g:WhichKeyDesc_Show_ParameterInfo = "<leader>sp 显示方法或函数的参数信息"  
nmap <leader>sp <action>(ParameterInfo)  
"Stop  
let g:WhichKeyDesc_Show_Stop = "<leader>st 停止运行"  
nmap <leader>st <action>(Stop)  
  
"向右拆分标签页  
let g:WhichKeyDesc_Windows_Move_MoveTabRight = "<leader>wml 向右拆分标签页"  
nmap <leader>wml <action>(MoveTabRight)  
"向下拆分标签页  
let g:WhichKeyDesc_Windows_Move_MoveTabDown = "<leader>wmd 向下拆分标签页"  
nmap <leader>wmd <action>(MoveTabDown)  
"在另一边打开（前提是有另一边的分割窗口）  
let g:WhichKeyDesc_Windows_Move_MoveEditorToOppositeTabGroup = "<leader>wmo 在另一边打开"  
nmap <leader>wmo <action>(MoveEditorToOppositeTabGroup)  
"向右复制标签页  
let g:WhichKeyDesc_Windows_Move_SplitVertically = "<leader>wmc 向右复制标签页"  
nmap <leader>wmc <action>(SplitVertically)  
  
"取消所有分割窗口  
let g:WhichKeyDesc_Windows_UnsplitAll = "<leader>wa 取消所有分割窗口"  
nmap <leader>wa <action>(UnsplitAll)  
"关闭当前窗口或分割窗格  
let g:WhichKeyDesc_Windows_closeActiveWindow = "<leader>wc 关闭当前分割窗口"  
nmap <leader>wc <c-w>c  
"取消拆分当前分割窗口  
let g:WhichKeyDesc_Windows_Unsplit = "<leader>wu 取消拆分当前分割窗口"  
nmap <leader>wu <action>(Unsplit)  
  
"关闭提示窗口  
let g:WhichKeyDesc_Windows_Hide_HideActiveWindow = "<leader>wwa 关闭提示窗口"  
nmap <leader>wwa <action>(HideActiveWindow)  
  
let g:WhichKeyDesc_Zip = "<leader>z 折叠"  
  
"展开所有代码折叠区域(Ctrl + Shift + 加号键)  
let g:WhichKeyDesc_Zip_unZipAll = "<leader>zo 展开所有折叠"  
nmap <leader>zo <action>(ExpandAllRegions)  
"折叠所有代码折叠区域(Ctrl + Shift + 减号键)  
let g:WhichKeyDesc_Zip_ZipAll = "<leader>zc 折叠所有代码"  
nmap <leader>zc <action>(CollapseAllRegions)
```