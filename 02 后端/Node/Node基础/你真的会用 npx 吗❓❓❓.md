Hello，大家好！
日常开发中大家应该经常使用 `npm install xxx` 来安装包依赖，那是否注意到npm升级到 `npm@5.2.0` 之后，在 npm 二进制命令旁边安装了一个 `npx` 二进制文件呢？
## 没有 npx 命令前
在没有 `npx` 命令之前，我们想要执行项目中安装的可执行脚本，以安装 React 创建项目的脚手架 `create-react-app` 为例，通常使用下面的做法：
做法一，使用全局安装然后再创建项目：
```bash
npm install create-react-app -g

create-react-app test-react
```

> 缺点
> 
> 1. `create-react-app` 安装项目本身是一个低频次操作，全局安装不具备必要性，同时如果其它低频次工具也全局安装，势必会造成全局 path 混乱和冗余。
> 2. npm 生态系统越来越倾向于将工具安装为项目本地 `devDependencies` ，让每个项目独立管理工具的版本，而不是都是用全局安装的固定版本。

做法二，不全局安装，需要先进入脚手架目录，再调用这个命令：
```bash
npm install create-react-app -D

cd node-modules/.bin/

create-react-app test-react
```
或者将 `create-react-app` 命令添加到 `package.json` 的 `scripts`中
> 缺点
> 
> 这样做每个项目可以安装不同的脚手架版本，但操作还是略微繁琐，同时每个项目都安装一遍脚手架工具也是不必要的。

npx 就是为了解决这些问题，下面我们来了解一下。
## npx 基本用法
了解基本用法之前，我们先看看 npx 的安装。
### 安装
在安装完 node 以及 npm 后，会默认安装 npm 相同版本号的 npx 工具，当然也可以独立安装：
```bash
npm install -g npx
```
### 执行命令

```bash
npx create-react-app
```

使用 npx 执行一个工具非常简单，不需要提前安装 `create-react-app` ，直接使用 npx 就可以执行这个工具，这源于 npx 的查找流程：

1. 先自动查找当前项目依赖包中的可执行文件，也就是 `node-modules/.bin/`；
2. 如果找不到，就会去全局 `$PATH` 中查找，所以全局安装的包不会重复安装；
3. 如果依然找不到，就会帮你临时安装，执行完命令后再删除包。

拥有 npx 后，当我们开发一个命令，就不用让用户先安装再使用了，给用户添加负担。👌

## 常用参数

同时，npx 还有一些常用的参数：

### `--no-install` 和`--ignore-existing` 参数

如果想让 npx 强制使用本地模块，不下载远程模块，可以使用`--no-install`参数。如果本地不存在该模块，就会报错。

```bash
npx --no-install create-react-app
```

反过来，如果忽略本地的同名模块，强制安装使用远程模块，可以使用`--ignore-existing`参数。比如，本地已经全局安装了`create-react-app`，但还是想使用远程模块，就用这个参数。
```bash
npx --ignore-existing create-react-app my-react-app
```
`-p`参数用于指定 npx 所要安装的模块版本。
```bash
npx -p node@18.16.1 node -v 
```
上面命令先指定安装`node@18.16.1`，然后再执行`node -v`命令。
`-p`参数对于需要安装多个模块的场景很有用。
```bash
npx -p lolcatjs -p cowsay 'cowsay hello'
```

> cowsay 工具会在命令行中生成羊图案和对象的文字，lolcatjs 工具会将这只羊上色
### -c 参数
如果 npx 安装多个模块，默认情况下，所执行的命令之中，只有第一个可执行项会使用 npx 安装的模块，后面的可执行项还是会交给 Shell 解释。
```bash
npx -p lolcatjs -p cowsay 'cowsay hello | lolcatjs'
# 报错
```
上面代码中，`cowsay hello | lolcatjs`执行时会报错，原因是第一项`cowsay`由 npx 解释，而第二项命令`localcatjs`由 Shell 解释，但是`lolcatjs`并没有全局安装，所以报错。
`-c`参数可以将所有命令都用 npx 解释。有了它，下面代码就可以正常执行了。
```bash
npx -p lolcatjs -p cowsay -c 'cowsay hello | lolcatjs'
```
`-c`参数的另一个作用，是将环境变量带入所要执行的命令。举例来说，npm 提供当前项目的一些环境变量，可以用下面的命令查看。
```bash
npm run env | grep npm_ # 查询npm的环境变量，并筛选出以 npm_ 开头的变量
```
`-c`参数可以把这些 npm 的环境变量带入 npx 命令。
```bash
npx -c 'echo "$npm_package_name"'
```
上面代码会输出当前项目的项目名。
## npx 其它用法
### 使用不同版本的 node
利用 npx 可以下载模块这个特点，可以指定某个版本的 Node 运行脚本。它的窍门就是使用 npm 的 [node 模块](https://www.npmjs.com/package/node)。
```bash
npx node@18.16.1 -v
```
上面命令会使用 18.16.1 版本的 Node 执行脚本。原理是从 npm 下载这个版本的 node，使用后再删掉。
使用这个包，可以直接在一个 node 环境下，使用不同版本的 node 测试开发的包是否正常运行，当然也可以使用 `nvm` 等 node 管理器，但是需要先切换再测试的方式效率明显不如上面的命令。
### 执行 GitHub 源码
npx 还可以执行 GitHub 上面的模块源码。
```bash
npx https://gist.github.com/zkat/4bc19503fe9e9309e2bfaa2c58074d32
# 执行仓库代码
npx github:piuccio/cowsay hello
```
注意，远程代码必须是一个模块，即必须包含`package.json`和入口脚本。
本文具体参考了以下文章：
- [Introducing npx: an npm package runner | by Kat Marchán | Medium](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjFmNDBmMGE4ZWYzZDg4MDk3OGRjODJmMjVjM2VjMzE3YzZhNWI3ODEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDM1Njk5MzQzMjY3OTkzMzA3NDQiLCJlbWFpbCI6IjI0NTIyNDEyMTdAcXEuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5iZiI6MTcwNTAyNjUyMywibmFtZSI6IjI0NTIyNDEyMTdAcXEuY29tIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BTFYtVWpXZXJhaENFM3N2bm90TW9Ua0lpUURBSWZOZndmUDh4alU2VkZlbUxFZHI9czk2LWMiLCJsb2NhbGUiOiJ6aC1DTiIsImlhdCI6MTcwNTAyNjgyMywiZXhwIjoxNzA1MDMwNDIzLCJqdGkiOiIzNTgwODE4Mzg4NzY1YjkyYmUxMDBlNDFjMWFkMzljNWRiZDFiMTNkIn0.Yu_5iJkZcZGDPCVLWDAek6DYtmBLFanj6bkJ0XaG7gNMEsjKNIhjpX0IsdN9k-WqEgM7EWciBYl6eS7hAgl31OWLX2nAYAmt_ROuyth6L6hl2kIiTnOmLMuamI0LAOaXdHjd-xOQ5V9TkXeDXU5bOMWKi6UAsUQnoveKZidcljpY7SzHnB0vRslW8HNgpasJDJmss-wDzXT_qYTMVvrd6TnjyFev2BKaXxBmuhPCMicWI9vGKGeUL8Ofhmgn_imxU0CPCBpHsuZ7acVIZ5QBQgmirHAKK6XAoRNwoIxGGvaV4B4OkPIIMY_SHmOS6N1A7DiHrbH7GetPeqK0P_Pysw)
- [GitHub - npm/npx: npm package executor](https://github.com/npm/npx?tab=readme-ov-file)
- [npx 使用教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2019/02/npx.html)
- [ ] 