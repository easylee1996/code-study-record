## 开始

### Zsh简介

Zsh(Z shell)是一种功能强大的shell，比系统自带的bash shell更加强大。

oh-my-zsh是一个针对zsh shell的开源框架，很多功能和插件都是基于这个框架的，所以一般这个是必须安装的。

### 安装

- 首先安装zsh：`brew install zsh`
- 然后安装oh-my-zsh：`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- 设置zsh为默认终端：`chsh -s $(which zsh)`
- 查看安装是否成功：`zsh --version`

直接安装oh-my-zsh也会自动安装zsh。

## oh-my-zsh

### 主题安装

主题安装非常简单，通常步骤是下载，然后设置即可，以安装[powerlevel10k](https://github.com/romkatv/powerlevel10k)为例：

1. 下载主题：下载并移动到zsh主题目录下

   ```shell
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
   ```

2. 配置为当前主题：设置 `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`。

3. 重启终端即可。

> 上面这款主题，安装完成还需要配置，根据提示配置即可，默认需要下载字体，安装和下载字体之前，如果无法下载，请开启代理。

### 插件安装

插件安装都是通用的步骤，某些插件需要设置其它的东西，插件会说明：

1. 进入插件目录：`cd ~/.oh-my-zsh/custom/plugins/`
2. 下载复制插件：`git clone https://github.com/<插件名称>.git ~/.oh-my-zsh/custom/plugins/<插件名称>`
3. 修改配置文件.zshrc：`plugins=(git docker)`，添加需要的插件即可
4. 重启或者`source`配置文件。

> 自定义的主题和插件请注意都是放在 `custom`目录下的。