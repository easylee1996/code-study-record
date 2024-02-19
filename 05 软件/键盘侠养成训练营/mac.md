## mac效率相关软件

### 软件切换

Manico、thor，推荐使用thor，免费

### 窗口位置大小切换

Moom

## Alfred

### 基本操作

- 激活：`double cmd`，自定义
- 打开软件文件夹相关命令：右方向键，执行软件的各种命令，比如复制

### 文件夹

- 进入文件夹：`cmd + 下`
- 返回上层文件夹：`cmd + 上`
- 打开文件夹：`enter`

### 文件搜索

- 搜索文件：`空格 + 关键字`，有多个命令，就使用这一个就行。
- 打开搜索文件的上层文件目录：`cmd + enter`

### 搜索引擎搜索

前面加上搜索引擎关键字即可

> 上面功能都大同小异，直接打开使用即可，上面的内容默认都能搜索到。

## workflows插件

插件直接下载完成就可以使用。

### 有道翻译

- 下载地址：https://github.com/whyliam/whyliam.workflows.youdao
- 关键字：`yd`
- 复制翻译内容：`回车`
- 打开有道网页：`ctrl + 回车`
- 发音：`shift + 回车`

### github

用于直接访问github里面的各种操作：

- 下载地址：[gharlan/alfred-github-workflow: GitHub Workflow for Alfred 4](https://github.com/gharlan/alfred-github-workflow)
- 安装环境：**必须要有php才可以运行，所以一定要装好php**
  - 前置安装：`brew install ca-certificates`，如果失败可以直接安装下面php，安装完成后再安装这个，然后继续安装php
  - php：`brew install php`
  - 总之两个都要正确安装即可，哪个不行就装另外一个。
- 关键字：`gh`
- 登陆：`gh login`
- 查询库：`gh 库名`
- 搜索用户：`gh @用户名`
- 显示自己的所有信息：`gh my`，即可查看到自己的star之类的信息
- github workflow的设置：`gh >`

### newPath

需要先打开目录，然后就可以创建文件和目录到当前目录了：

- 下载地址：[vitorgalvao/alfred-workflows: Collection of Alfred workflows(opens new window)](https://github.com/vitorgalvao/alfred-workflows#newpath-)

- 创建新文件：`nf`
- 创建新文件并打开：`nfo`
- 创建新目录：`nd`
- 创建新目录并打开：`ndo`

### vscode

使用vscode打开当前目录或者选中的文件

- 下载地址：[alexchantastic/alfred-open-with-vscode-workflow: Alfred 5 workflow for opening files or folders in Visual Studio Code.(opens new window)](https://github.com/alexchantastic/alfred-open-with-vscode-workflow)
- 打开当前目录或者选中的文件：`code`
- 搜索并打开：`codef`

> 注意：直接输入 `code`是打开vscode软件，因为打开软件的优先级更高，后面加一个空格就是这个`workflow`了。

### iTerm <-> Finder

使用这个workflow可以直接在iterm和finder中进行相互打开。

- 下载地址：https://github.com/LeEnno/alfred-terminalfinder
- 在iterm打开当前打开的finder目录：`ofi`，改建避免很多其它因为 `fi`失效
- 在finder打开当前iterm的目录：`oif`

### 生成变量名

- 下载地址：https://github.com/xudaolong/CodeVar
- 小驼峰命名：`xt`
- 大驼峰命名：`dt`
- 下划线命名：`xh`
- 常量命名：`cl`
- 中划线命名：`zh`

## finder常用快捷键

- 双击打开：`cmd + 下`
- 返回上一级：`cmd + 上`
- 文件夹历史：`cmd + []`
- 直接复制一份：`cmd + d`，不用先复制再粘贴
- 查看文件信息：`cmd + i`
- 新建文件夹：`cmd + shift + n`
- 打开新finder：`cmd + n`
- 拖拽后复制而不是移动：`按住option`