使用nrm可以方便的更换npm安装镜像地址

### 基础使用方法
如果连安装 nrm 都无法安装，可以先一次性使用淘宝镜像先安装
```shell
npm install -g nrm --registry=http://registry.npmmirror.com
```

全局安装
```shell
npm i -g nrm
```

查看版本
```shell
nrm -V
```

查看所有源
```shell
nrm ls
```

切换源
```shell
nrm use xxx
```

添加源，比如公司内部仓库
```shell
nrm add <registry> <url>
```

删除源
```shell
nrm del <registry>
```

测试源时间
```shell
nrm test <registry>
```
