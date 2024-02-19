Windows 中安装 node 相关环境，最好还是使用 nvm-windows 进行安装，避免麻烦，安装完成后，需要安装要给 node 的版本，并且 use 这个版本，同时将这个版本的 node 路径添加到环境变量中，否则 npm 等工具无法找到。

但是还是会存在问题，通过 npm -g 全局安装的命令还是会存在找不到的问题，上面的环境变量安装之后，可以通过下列命令找到 npm 全局包的安装位置
```shell
npm config get prefix
```

得到安装位置同样放到环境变量中。

除了环境变量的问题，有可能设置了还是无法成功，还需要在 powershell 中执行下列命令（管理员运行），这是因为 windows 的[安全](https://cloud.tencent.com/developer/tools/blog-entry?target=https%3A%2F%2Fblog.fastmock.site%2Findex.php%2Ftag%2F%25E5%25AE%2589%25E5%2585%25A8%2F&source=article&objectId=2350043)策略禁用了当前目录下的命令。
```shell
set-ExecutionPolicy RemoteSigned
```

同时执行这些命令，最好是在管理员运行的命令行中执行，坑太多了。

除此之外，也可以不用 npm -g，npx 执行这些 node 安装的命令也是不错的选择。