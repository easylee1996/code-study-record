---
创建时间: 2023-11-24T09:09
更新时间: 2023-11-28T13:36
---
## 安装和配置
1. 开启obsidian vim模式
2. 开启obsidian vim
3. 安装 vimrc supports 插件，这个插件需要一个配置文件,创建一个即可，`.obsidian.vimrc`，配置一下[[obsidian vimrc supports配置]]

## 快捷键

### 软件常用快捷键
1. 创建新文件： cmd + n，在相同文件夹下
2. 恢复关闭的文件：cmd + shift + t
3. 打开最近文件：cmd + p
4. 删除文件：`cmd + shift + backspace`
5. 搜索命令：`cmd+shift+p`
6. 分屏拆分：`cmd + \`左右分屏 `cmd + shift + \` 上下分屏
7. 拆分编辑区切换：`cmd + shift + HJKL`
8. 标签页切换：`cmd + []`
9. 重命名文件：`cmd + shift + r`
10. 插入日记：`cmd + shift + n`
11. 插入模板：`cmd + shift + i`
12. 前进： `ctrl + o` 这个命令不需要配置快捷键，是由vim统一设置的，自带的
13. 后退： `ctrl + i`
### 编辑相关快捷键
1. 编辑模式和预览模式切换：`cmd + e`
2. 源码模式切换：`cmd + /`
3. 加粗： Cmd + B
4. 选中后添加连接：`cmd + k`
5. 切换待办事项的状态：`cmd + space` 
6. 代码块：`ctrl + c`，输入直接使用\`即可 ，这个快捷键通常用于给选中的内容添加成代码块
7. 代码区域：使用 \`\`\`
8. 进入连接：`cmd + enter`
9. 上下行切换：`ctrl + shift + JK`
10. 折叠打开：`cmd + -+`
11. 折叠打开全部：`cmd + shift + -+`
### 双链相关快捷键
1.插入内部连接： `[[` `[[#` `[[|` 分别为插入连接，连接其中的标题，连接后起别名
2.按住cmd+鼠标hover可以预览内部连接
3. 插入附件 `![[`
4. 在新面板打开: `cmd + click` 或者 `cmd + 回车`  ,打开并编辑 `cmd + shift + click` 
### 全局&搜索相关快捷键
1. 折叠打开左侧栏：`ctrl + b`，和vscode不同，因为 `cmd + b`有加粗的作用
2. 折叠打开右侧栏： `ctrl + shift + b`
3. 将焦点聚焦到编辑区： `option + ,`聚焦到文件列表页 `option + .` 同vscode
4. 将文件在finder中打开： `ctrl + shift + f` 同vscode
5. 全局搜索： `cmd + shift + f`
6. 搜索： `cmd + f ` 或者 `/` 通常在文件中搜索一般使用后者这个vim命令
7. 替换： `cmd + option + f`
8. 基于tag等搜索：`:tag` 搜索框本身就有提JJ示