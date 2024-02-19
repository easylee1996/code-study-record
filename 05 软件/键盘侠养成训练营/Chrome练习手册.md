---
创建时间: 2023-03-14T18:54
更新时间: 2023-12-05T08:47
---
## vimium c插件使用
安装下载地址：[GitHub - gdh1995/vimium-c: A keyboard shortcut browser extension for keyboard-based navigation and tab operations with an advanced omnibar](https://github.com/gdh1995/vimium-c)
暂时不进行按键配置，因为chrome浏览器本身的限制，很多vim的配置无法实现，或者可以实现但是vimium这个的配置规则比较麻烦，所以暂时就使用原生的这些命令即可。
### 基本操作
上下滚动： jkud，jk一行，ud多行
顶部底部：gg/G
查找：/，nN上下选择
暂停识别按键：i

### 选择
选择元素：f当前页打开，F新页面打开，ctrl + f 双击目标元素 `map <c-f> LinkHints.activate dblclick`
聚焦输入框：gi
yv：文本选择，先选择需要选择的位置，然后开始文本选择

### 标签页
左右标签页：JK，原生使用 `ctrl + tab` 和 `ctrl + shift + tab`
	- 两侧标签：gH、gL，需要映射下面的按键`mapkey <L:v> <$>mapkey <H:v> <0>`
	- 打开指定标签页：原生command + 1-0
新标签页：
	t，原生 `command + t`，可以使用[New Tab Redirect](https://chromewebstore.google.com/detail/new-tab-redirect/icpgjfneehieebagbmdbhnlpiopdcmna)来配置新标签页默认打开页面
	yt新标签页打开当前页面，
前进后退：HL
复制标签页地址：yy
粘贴地址并跳转：p当前页，P新标签页跳转
关闭标签页：x，原生 `command + w`，X重新打开关闭的标签页
在新页面打开当前页面：W
刷新页面：r，原生 `command + r`
移动当前标签页：`<<`左移 `>>` 右移
最近访问的上一个标签页： `g[` `map g[ visitPreviousTab`
打开多功能框：
	1. o本页打开，O新标签页打开，使用搜索网站的前缀比如gh可以直接通过github搜索，具体有哪些可以在设置里面进行配置，原生 `command + l`，新页面打开加上command即可，shift + enter可以在新窗口打开
	2. 搜索书签：b/B效果同上
	3. 修改当前网址：ge/gE
	4. 搜索当前打开标签页： T，原生 `command + shift + a`
访问网址的上一层：gu，访问当前网址的首页：gU

## debug
基本操作：
- `command` + `b` / `command` + `shift` + `b`：在光标所在行打断点，如果该行已有断点则取消该断点；区别是用第一个组合键取消断点时，会完全取消，在 BreakPoint 面板中不会有记录留下；而用第二个组合键来取消则该断点时，断点标记不会完全消失，会变成半透明样式，且记录还会在 Breakpoints 面板上，以供随时重新打上该断点；
- `command` + `'` / `f10`：step over；
- `command` + `;` / `f11`：step into；
- `shift` + `command` + `;`：step out；
- `command` + `\` / `f5`：停止当前的断点；
- `command` + `f8`：停止所有的断点；
小技巧：
- `command` + `shift` + `e`：把选中的代码值输出到 console 面板；
- `command` + `shift` + `o`：打开跳转到函数面板，与前面的 [VScode 单文件搜索符](https://vim.nauxscript.com/vscode/day-21.html#%E5%BF%AB%E6%8D%B7%E6%90%9C%E7%B4%A2%E7%AC%A6%E5%8F%B7)类似；不过选择列表中只有函数，不会显示变量等其他的值；
- `ctrl` + `g`：弹出输入框，输入数字可跳转到指定行；

在这几个命令的使用过程中或者前面提到的一些命令你可以发现，有些地方还是要用到鼠标操作，比如选中代码变量，比如在代码面板和代码文件面板的切换，这是肯定的；因为我们无法也没有必要要求所有操作都用键盘操作，只有在适合的场景用适合的方法，才能最大地提提高我们的效率。
## chrome快捷键
暂时未发现新版chrome配置快捷键的方法，目前直接使用默认快捷键即可
打开开发者工具窗口：
	`command + option + i`打开开发者工具
	`command + option + j` 打开console
	`command + option + c` 打开元素面板，并查看当前鼠标所在的元素位置
开发者面板内：
- `option + /` 打开 `console` 面板；会在开发者工具面板底部打开该面板；
- `command` + `k`：清空 `console` 面板输出；
- `command` + `p`： 搜索该网站静态资源文件；
- `command` + `shift` + `p`：搜索开发者工具中的可用命令；
- `command` + `[` / `]`：切换开发者工具中的标签栏；
- `esc`：在 `source panel` 中 显示 / 隐藏 底部面板；
- `command k command s`：打开快捷键设置面板
