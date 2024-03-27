## 安装
### Mac
使用 brew 进行安装：
```shell
brew update
brew install pyenv
```

配置环境变量 (以 zsh 为例)：
```shell
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

> 注意
> `echo 'eval "$(pyenv init -)"' >> ~/.zshrc` 必须设置，否则不生效。
> 同时. zshrc 中 python alias 别名不要进行设置，否则会使用这个配置，pyenv 的配置就无效了。
### windows
使用 pyenv windows 版本，[GitHub - pyenv-win/pyenv-win: pyenv for Windows. pyenv is a simple python version management tool. It lets you easily switch between multiple versions of Python. It's simple, unobtrusive, and follows the UNIX tradition of single-purpose tools that do one thing well.](https://github.com/pyenv-win/pyenv-win)

## 常见用法
- 安装指定版本：`pyenv install 3.10.4`
- 卸载指定版本：`pyenv uninstall 3.10.4`
- 查看所有可安装版本：`pyenv install -l`
- 指定全局版本：`pyenv global 3.10.4`
- 指定当前目录的 python 版本：`pyenv local 3.10.4`
- 查看当前使用的 Python 版本：`pyenv version`
- 查看安装的所有 python 版本：`pyenv versions`
