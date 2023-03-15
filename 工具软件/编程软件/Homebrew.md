## 介绍

Mac系统优秀包管理器，可以使用Homebrew安装的软件尽量使用它来安装。

## 镜像仓库设置

1. 要设置镜像仓库，首先要进入Homebrew的仓库目录：必须安装好Homebrew之后，这个命令才能招到仓库目录

```shell
cd "$(brew --repo)"
```

2. 配置国内仓库地址：

```shell
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
```

3. 更新Homebrew

```shell
brew update
```

4. 查看当前仓库地址

```shell
git remote show origin
```

如果要恢复默认的仓库地址，只需要在第二步修改为下面的地址即可：

```shell
git remote set-url origin https://github.com/Homebrew/brew.git
```

## 常用命令

### Homebrew操作

- 安装 Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- 更新Homebrew：`brew update`

- 显示Homebrew版本信息：`brew --version`

- 查看帮助文档：`brew help`

### 软件包相关操作

- 安装软件包：`brew install node`
  - 安装软件包指定版本：`brew install <package-name>@<version>`

- 升级软件包：

  - 所有软件包：`brew upgrade`

  - 指定软件包：`brew upgrade node`

- 卸载软件包：`brew uninstall <package_name>`

- 搜索软件包：`brew search <keyword>`

- 查看安装列表：`brew list`

- 显示软件包信息：`brew info <package-name>`

- 清理过时的软件包和缓存：`brew cleanup`

### 其它命令

- 查看已安装软件包依赖关系：`brew deps <package-name>`
- 显示已安装软件包的可选依赖关系:`brew info <package-name> --json | jq '.[0].installed[0].optional_dependencies'`
- 查看软件包的安装路径：`brew --prefix <package-name>`
- 查看可更新的软件包：`brew outdated`

### cask相关命令

cask是homebrew的扩展，用于支持通过命令行操作Mac桌面端的一些软件，homebrew通常只是用于支持一些命令行端的软件。

与cask相对应的是，使用命令行运行、通常是ruby等脚本软件，在搜索结果的Formulae分类中。

- 安装cask： `brew tap homebrew/cask`
- 在 Cask 库中搜索应用程序：`brew search <app_name> --cask `
- 使用 Cask 安装应用程序：`brew install <app_name> --cask`
- 使用 Cask 卸载应用程序：`brew uninstall <app_name> --cask`
- 升级所有已安装的应用程序到最新版本：`brew upgrade --cask`
- 列出所有已安装的应用程序：`brew list --cask`
- 查看应用程序的详细信息，包括版本号、大小和发布日期等：`brew  info <app_name> --cask`
- 在默认浏览器中打开应用程序的官方网站：`brew home <app_name> --cask`