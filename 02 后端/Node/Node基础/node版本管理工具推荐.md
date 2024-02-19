hello，今天给大家分享几款 node 版本管理的工具。
## 背景
在开发前端项目的时候，特别是新到公司接手一个多年维护的老项目时，如果 node 版本不正确，有的插件可能无法正确安装，比如我之前提到的 node-sass 无法安装问题，具体请看：[[node node-sass sass-loader版本兼容问题]]。
同时我们在开发自己的插件时，最好也推荐多使用几个 node 版本进行测试。
切换 node 版本肯定不能卸载重新安装新版本，这样效率太低，最好是使用工具来同时安装多个版本，并快速的切换，下面是推荐的几个工具。

> 注意：在安装 node 版本管理工具之前，最好先卸载直接安装的 node，统一交给管理工具来管理。
## N管理器
N 管理器时一个 npm 的包，所以直接使用 npm 进行安装即可，但是不支持 windows 使用，需要注意。
常用命令：
- `npm install -g n`：安装 n 管理器
- `n <version>` ：安装指定 node 版本
- `n lts`：安装最新的 node lts 版本同 n stable
- `n latest`：安装 node 最新版
- `n ls`：查看已安装的 node 列表
- `n`：选择 node 版本
- `n rm <version>`：删除指定 node 版本

## NVM管理器
上面的 n 管理器不支持 windows 版本，所以更推荐使用这个工具，两者通用。
下载地址：
- windows 版本：[GitHub - coreybutler/nvm-windows: A node.js version management utility for Windows. Ironically written in Go.](https://github.com/coreybutler/nvm-windows)
- mac 版本：[GitHub - nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions](https://github.com/nvm-sh/nvm)

安装使用：
- Windows：通过上面的地址，下载最新的 release 发布包安装即可
- mac：上面地址包含安装命令，除此之外也可以通过 brew 工具安装 `brew install nvm`

安装完成之后，来看看 nvm 的常用命令：
- `nvm install stable` ：安装最新稳定版 node
- `nvm install <version>`： 安装指定版本 node 
- `nvm uninstall <version>`： 删除已安装的指定版本
- `nvm use <version>` ：切换使用指定的版本 node
- `nvm ls ` ：列出所有安装的版本
- `nvm alias default <version>` ：如： `nvm alias default 18`

## npx 切换 node 版本
除了上面的两个工具，还可以利用 npx 可以下载模块这个特点，可以指定某个版本的 Node 运行脚本。它的窍门就是使用 npm 的 node 模块。
```bash
npx node@18.16.1 -v
```
上面命令会使用 18.16.1 版本的 Node 执行脚本。原理是从 npm 下载这个版本的 node，使用后再删掉。
使用这个包，可以直接在一个 node 版本环境下，使用不同版本的 node 测试开发的包是否正常运行。
临时测试某些包使用这个命令效率更高。
关于 npx 的详细用法，可以看看我的这篇文章：[[你真的会用 npx 吗❓❓❓]]。
## 总结
以上就是管理 node 版本的三个工具的用法了，通常我比较喜欢 nvm ，公司和自己的电脑两个系统可以通用，更方便，临时切换 node 版本测试一些命令或者工具可以使用 npx 来完成。
大家喜欢使用什么工具呢，可能马上又有很多新的工具出现，前端圈实在太能造轮子了，有更好用的 node 管理工具可以在评论区分享一下！