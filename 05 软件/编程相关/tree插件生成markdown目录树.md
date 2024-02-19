##  Markdown使用-生成目录树

> 在使用Markdown写文档的过程中，有时会需要展示项目的目录和文件结构。
> 类似下面的目录树:

```html
├── detectron2
│   ├── __pycache__
│   ├── checkpoint
│   ├── config
│   ├── data
│   │   ├── datasets
│   │   ├── samplers
│   │   └── transforms
│   ├── engine
│   ├── evaluation
```

这种目录树是如何生成的呢？
实际上，Markdown中没有相应的语法来生成这样的目录描述，一般是采用第三方工具生成目录结构文本，然后拷贝到Markdown中。
在Mac上，可使用`brew install tree`安装tree命令来实现。
其他常用tree命令有：

```html
tree --help
tree -a		# 显示所有
tree -d		# 只显示文件夹
tree -L n	# 按层级显示项目数，n表示层级
tree -I file	# 用于过滤不想要显示的文档或文件夹
tree > xxx.md 	# 将目录树输出到 xxx.md 这个文档
```