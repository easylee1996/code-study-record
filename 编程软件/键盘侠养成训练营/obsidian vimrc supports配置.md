---
创建时间: 2023-11-24T10:22
更新时间: 2023-11-24T11:42
---
### 根据模式设置
map: normal visual operator pending modes模式下生效
imap或map!: 插入模式
nmap: 正常模式
vmap：visual模式
omap：是其它操作的过程，比如删除操作d，如果要删除到行首，dH，如果这个H不绑定到这里，那么这个H就不是其它操作的过程，就无法配合删除d操作，当然在map中设置，默认是包含这个模式的
nore+xxx: 上面的模式的非递归设置

### 开始设置
首先要知道如何获取obsidian的相关命令
1. 在obsidian中，使用 `command + option + i`打开浏览器调试窗口，obsidian是使用的浏览器调试来进行调试的
2. 然后在obsidian中输入 `:obcommand` 此时就会在调试窗口中打印所有的命令了
3. 我们可以在obsidian中输入 `:obcommand xxx` 来执行调试窗口的命令，看具体是什么效果，从而了解命令的作用

配置的时候使用下面的格式即可
```shell
# 设置一条映射 back是名称 只支持驼峰 后面是obsidian的命令
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward
```
`<C-i>` 中的 `<C` 是command，`<A` 是option

`<space>` 设置
首先设置一下空格键为引导键
```shell
unmap <Space>

exmap back obcommand app:go-back
nmap <space>xx :back
```
基本和上面的配置相同，只需要配置一下空格，即可在命令中使用空格+命令来设置执行对应的命令了

### 参考配置
```shell
unmap <Space>
map H ^
map L $
map J 5j
map K 5k

exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

nmap <Space>n :forward
```