# mac环境变量配置

只是配置命令行的环境变量，也就是在命令行中能识别环境变量

${PATH}后面的:是分隔两个path的,前面的变量表示加上前面的path

`zsh命令行`

```shell
// 打开配置文件
open ~/.zshrc

// 加入mysql命令
export PATH=${PATH}:/usr/local/mysql/bin

// 更新配置文件
source ~/.zshrc
```



`默认控制台配置`

```shell
// 打开配置文件
open ~/.bash_profile

// 加入mysql命令
export PATH=${PATH}:/usr/local/mysql/bin

// 更新配置文件
source ~/.bash_profile
```



