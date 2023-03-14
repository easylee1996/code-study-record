## 文件操作

> ### 区域切换
>
> 如果未打开，会打开该区域
>
> - 切换到文件选择区域：`ctrl + ;` 按两下会回到编辑区
>
> ```json
>   // 焦点移动文件选择区
>   {
>     "key": "ctrl+;",
>     "command": "workbench.view.explorer",
>     "when": "viewContainer.workbench.view.explorer.enabled"
>   }
> ```
>
> - 切换到编辑区域：`ctrl+'`
>
> ```json
>   // 焦点移动到文件编辑区域
>   {
>     "key": "ctrl+'",
>     "command": "workbench.action.focusFirstEditorGroup"
>   }
> ```
>
> - 切换到终端区域：`ctrl+esc`
>
> ### 文件区域
>
> - 移动光标选择文件：jk
>
> - 折叠展开文件夹：hl
>
> - 选择文件：l
>
> - 创建文件：
>
>   - 文件选择区域：a
>
>   - 编辑区域：使用vim命令-`leader + n+f`
>
>   - vscode原生命令：command+n，不常用，因为这个命令是创建一个空白文件，然后需要保存到具体目录，而上面的两个命令，都是直接在当前目录创建的
>
> - 创建目录
>
>   - 文件选择区域：A
>
>   - 编辑区域：vim-`leader+n+d`
>
> - 重命名文件：r
>
> - 删除文件：d
>
> - 相关配置文件
>
> ```json
>  // vscode快捷键配置keybingdings.json
> // 创建文件 !inputFocus,也就是不在输入文件名的状态中时
>   {
>     "key": "a",
>     "command": "explorer.newFile",
>     "when": "filesExplorerFocus && !inputFocus"
>   },
> 
> // 创建文件夹
>   {
>     "key": "shift+a",
>     "command": "explorer.newFolder",
>     "when": "filesExplorerFocus && !inputFocus"
>   },
>  // 重命名文件
>   {
>     "key": "r",
>     "command": "renameFile",
>     "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus"
>   },
> // 删除文件
>   {
>     "key": "d",
>     "command": "deleteFile",
>     "when": "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus"
>   }
> 
> // 个人配置文件settings.json
> // 创建文件
>     {
>       "before": ["<leader>","n","f"],
>       "commands": ["explorer.newFile"]
>     },
> // 创建目录
>     {
>       "before": ["<leader>","n","d"],
>       "commands": ["explorer.newFolder"]
>     },
> ```
>
> 

## 操作多个vscode窗口

> - 打开新窗口：`command+shift+n` 不常用，只是打开窗口，没有加载具体项目
> - 打开最近项目：`command+r`
> - 打开最近文件：`command+p`
> - 打开文件或目录：`command+o`
> - 切换多个窗口多个项目：`command+esc` 这个是通用的，系统设置-键盘-键盘快捷键-键盘-将焦点移到下一个窗口
> - 关闭当前窗口当前项目：`shift+command+w` 这是vscode的命令，并不是通用的

## 掌握搜索

> ### 全局搜索
>
> - 打开搜索：`command+shift+f`
> - 选择搜索结果：
>   - `command+上下方向键`：移动到不同搜索面板的不同区域，比如搜索输入区域和结果列表区域，这时候就需要加上 `command`
>   - 不加 `command`： 是在移动到搜索结果区域后，直接使用jk上下选择结果文件，hl折叠展开文件夹
>   - `enter`：结果文件上`enter`进入选择的文件
>   - `shift+方向键`：在编辑区域和搜索区域之间切换
> - `command + shift + j`：打开文件类型筛选选项
>
> ### 搜索函数名和变量名
>
> - 全局搜索变量名和函数名：`command + t`
> - 当前文件函数名和变量名：`command + shift + o`，搜索之后可以键入 `：` 给函数名、变量名排序，类似大纲功能
>
> ### 全局配置搜索
>
> - 打开搜索：`command + shift + p`
> - 键入插件名称，可以筛选插件对应的命令
>
> ### 文件搜索
>
> - 打开搜索：`command + p`，按照最近打开文件的顺序排序
> - 切换到上面几个搜索：
>   - 键入 `>`，切换到配置搜索
>   - 键入 `#`，切换到全局搜索变量和函数名
>   - 键入 `@`，切换到搜索当前文件函数名和变量名
>
> ### 文件切换
>
> - 文件切换：`control + tab`

## 编码ing

> ### 代码提示
>
> 快速修复代码，以及各种插件的命令
>
> - 打开命令：`command + .`\
>
> ### 参数提示
>
> 提示参数的类型，和参数名等信息
>
> - `command + shift+ 空格`
>
> ### 触发补全建议
>
> 代码提示补全
>
> - `command + i`
>
> ### 行操作
>
> - 移动行：`option + 方向键`
> - 增加行：`command + 回车`，下面增加一行，加上 `shift`上面增加一行，和 `o`不同的是增加之后并不会进入插入模式
>
> ### 删除单词
>
> - 删除光标前面的字符串：`option + delete`
> - 删除光标前面的单词：`option + control + delete`
>
> ### 跳转到错误处
>
> - F8:跳转到错误处，`shift + F8`跳转到上一个错误
>
> ### 选择所有当前单词
>
> - vim：有个 `gb` 选中当前光标位置的单词，多次按选中多个
> - vscode：
>   - `先按command 然后 F2`选中当前光标单词的所有位置单词，然后按下 `c` 即可，编辑所有位置，注意一定要先按 `command` 不能先 `Fn`，会出错
>   - 出错原因是：先按 `fn`再按 `command` 会把键盘切换到特殊符号输入模式，输入的都是特殊符号了，无法正常打字，比如command + s，保存会变成特殊符号，需要按三次`fn + command`切换回来
>
> > F1-F12，按法是按下FN + 1-12，mac需要取消F1-F12对应的设备功能，在键盘-键盘快捷键-功能键处设置
> >
> > ![image-20230308135811684](assets/vscode/image-20230308135811684.png)

## 发现使用快捷键的场景

> >  当什么功能每次都需要使用鼠标去点，并且用了多次，那就可以考虑配置快捷键，很多可以通过鼠标悬停查看具体的快捷键。
>
> ### 显示/隐藏左侧整体资源面板(包括文件、插件、git等面板)
>
> - `command + b`
>
> ### 使用live-server启服务
>
> - 启动服务：`command l command o`
> - 停止服务：`command l command c`
>
> ### 预览md
>
> - 预览md：`command k v`
> - 新建预览md并跳转到md文件：`shift command v`
>
> ### 打开扩展面板
>
> - `command + shift+x`
>
> ### 打开文件的finder面板位置，包括图片信息
>
> - 打开finder：`command+k然后r`
> - 查看文件具体信息：`command + i`
>
> ### 直接复制当前文件路径
>
> - `command+k然后p`

## 搞定git

> - 显示Git状态面板：`<leader> g g`,原生按键 `control + shift + g`
> - 当前文件提交到暂存区：`<leader> g a`
>   - 撤回提交暂存区文件：`<leader> g u`
> - 当前文件打开diff：`<leader> g d f`
> - 提交所有暂存区文件：`<leader> g c`，提交之后需要输入提交信息，然后保存提交。
> - 推送远程库：推荐使用 `cli`命令进行push，这样精确一些，因为需要推送到远程，快捷键难免出现误触。
> - 删除工作区修改到上次提交版本：`<leader> g c l`
>
> > 仍然推荐使用SourceTree进行操作，避免直接快捷键造成Git版本混乱，推荐本地仓库时使用vscode，推送之类的操作还是用SourceTree GUI软件进行操作，更加准确。
> >
> > 命令行Git软件lazygit也是一个很好的选择，完美支持vim，推荐linux使用。

## snippets代码片段

> > 发现一个片段多次输入，那么就考虑配置代码片段。
> >
> > Tab键可以切换代码片段中不同的参数位置。
> >
> > 如果不小心关掉，`command + i`可以重复弹出提出窗口。
>
> ### JavaScript (ES6) code snippets插件
>
> 包含常用的 js、ts、vue等常用代码片段，使用的时候再打开查看即可，主要包含：
>
> - 导入导出方法
> - Class方法
> - 变量方法
> - 数组方法
> - Console方法
>
> ### 自定义代码片段
>
> - 可以根据全局和不同语言进行脚本编写，语言单独使用的代码片段禁止配置到全局代码片段中。
> - 通过https://snippet-generator.app/这个网址生成代码。
>
> - 代码片段常用变量：
>   - `$1、$2、$3`：表示代码片段中可以输入的位置，按下 `Tab`键切换，也叫 `TabStop`位，`$0`表示最后一个输入位置。
>   - `${1:easylee}`：可以给输入位置设置默认值。
>   - `${1:|log,time,error|}`：设置输入位置多选值，tab到这个位置之后进行选择。
>   - `${1:$TM_FILENAME}`：输入位置配置系统变量。
>   - `$1 => $1`：一个片段设置两个同名输入位置，那么输入时会同时修改两个位置。
>   - `($1)=>${2:$1}`:第二个位置引用了第一个位置的值，这样设置按下Tab键，还可以切换到第二个位置。

## 重构功能

> ### vscode原生
>
> - 重命名：`<leader> r n`
> - 提炼函数：将多个代码行，通过快捷键生成一个函数，包含在函数内
>   - 选中代码行
>   - `command + .`
>   - 选择提炼函数
> - 提炼变量：选择字符串，然后 `command + .`，选择提炼成变量。
>
> > 使用 `control + shift + r`提炼，显示的命令更加的纯粹，都是提炼相关的，但是 `command + .`会包含各种插件的重构功能。
>
> ### 插件
>
> 发现vscode原生不支持的功能时，可以尝试使用插件，常见重构插件如下：
>
> - Abracadabra：重构命令查询https://github.com/nicoespeon/abracadabra/blob/main/REFACTORINGS.md
> - JavaScript Booster：和上面插件互补，比如if else转换为三元符，`command + .`调用
> - Hocus Pocus：提取字符串为变量和函数，较为常用，注意在代码有错误时无法创建，应该先解决代码错误，先用再创建
>   - 新建变量：字符串上按 `<leader> v v`
>   - 新建函数：函数名上按 `<leader> f f`

## VSpaceCode(whichkey)插件

> VSpaceCode和Whichkey是一样的，只是前者主要针对vim用户，后者针对普通的vscode用户。
>
> VSpaceCode主要是用于管理一系列的vim快捷键，然后组合在一起，弹出窗口，直接选择就可以执行，优点是比较全面，但我个人还是习惯直接自己配置vim，而不是通过弹窗选择各种操作。
>
> 配置文件：https://vim.nauxscript.com/vscode/day-27.html#%E5%AE%89%E8%A3%85%E5%8F%8A%E5%88%9D%E5%A7%8B%E9%85%8D%E7%BD%AE
>
> > 主要场景用于配置一些使用频率不高的快捷键，配置到这里面就非常合适，可以避免必须使用鼠标进行操作。
> >
> > 频率高的还是直接配置快捷键更加合适，操作更快更方便。
>
> **详细配置**

## 终端相关快捷键

> - 打开终端：
>
>   - 直接打开终端：`ctrl + .`,原本快捷键为 `ctrl + esc`需要移动整个左手按键，不太方便，通过系统快捷键修改。
>   - 打开终端面板：`cmd + j`，打开终端处的面板，里面有多个选项，不会具体打开终端面板，所以不常用。
>
> - 清屏：`cmd + K`
>
> - 分屏：`cmd + \`，分屏的面板同样是属于一个终端窗口的内容，只是同样可以操作，新建终端窗口才属于多个终端。
>
>   - 切换下一个面板：`cmd + ]`
>   - 切换上一个面板：`cmd + [`
>   - 关闭当前活动屏：`option + shift + q`，不算常用的功能，所以用的 `option`
> - 新建一个终端窗口：`option + shift + n` ，不算常用的功能，所以用的 `option`
>
> - 切换终端窗口：`cmd + shift + [ 和 ]`
>
> - 打开外部终端：`cmd + shift + c`，注意需要在vscode终端没有打开的状态下按才有用。默认是：!terminalFocus，修改将这个when条件删除，默认是使用默认的终端打开的，如果需要使用 `iTerm.app`，需要进行如下配置：
>
>   ```json
>   // settings.json
>   "terminal.external.osxExec": "iTerm.app",
>   ```

## Debug

> 常用的`debug`的快捷键：
>
> **重新配置快捷键**
>
> - start：`F5`
> - stop：`shift + F5`
> - restart：`cmd + shift + 0`
> - 打断点：`cmd + shift + 9`，原生 `F9`，使用`FN+9`非常不好按。
> - step over：`cmd + shift+ 8`
> - step into：`cmd + shift + 7`
> - step out：`cmd + shift + 6`
