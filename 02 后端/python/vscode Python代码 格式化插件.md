插件主要分为 formatter 插件 black 和 linter 插件 flake8，
前者主要是针对代码格式化，black 使用的人比较多，配置比较简单，安装完插件之后配置如下的内容即可：
```
// setting.json
"[python]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.codeActionsOnSave": {
      "source.organizeImports": "always"
    }
  },
  "isort.args": ["--profile", "black"]
```
上面同时还安装了 isort，这个插件可以自动修复导入模块的顺序，也可以一起安装上。
flake8 主要是用于代码检查修复，当然也可以格式化代码，目前先使用 black 和 isort 即可，同时其它还有 yapf 等也是很好用的工具。
需要注意 black 可配置的选项很少，更符合团队使用，避免大量配置导致不通用。