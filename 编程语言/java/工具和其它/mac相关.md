# mac环境变量配置

要注意，一般情况下，设置环境变量都是设置 bin 目录，因为命令都在这个目录

### zsh 命令行

使用 iTerm 控制台使用的是 `.zshrc`

添加环境变量只需要新建一个 `export=PATH=`，在之前的 `${PATH}:` 后添加自己的 bin 目录即可

```shell
// 打开配置文件
code ~/.zshrc

// 加入mysql命令
export PATH=${PATH}:/usr/local/mysql/bin

// 更新配置文件
source ~/.zshrc
```

### 默认控制台配置

默认控制台使用的是 `bash`

添加环境变量只需要新建一个 `export=PATH=`，在之前的 `$PATH:` 后添加自己的 bin 目录即可

注意这里的变量没有`{}`

```shell
// 打开配置文件
code ~/.bash_profile

// 加入mysql命令
export PATH=$PATH:/usr/local/mysql/bin

// 更新配置文件
source ~/.bash_profile
```



