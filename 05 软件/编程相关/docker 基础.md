---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# Docker概述

Docker 是一种容器技术，主要拥有解决环境部署问题，只需要安装一次软件、配置一次配置文件，然后直接一键移植或者复制到新的机器上，方便做持续集成的容器虚拟化技术。

传统虚拟机是虚拟出一套硬件，在其之上运行一个完整的系统，而容器是直接运行于宿主内核且没有进行硬件虚拟，所以容器更加轻便。

每个容器之间是完全独立隔离的。

## Docker基本组成

- 镜像：相当于 Java 中的类
- 容器实例：相当于 Java 中的实例
- 仓库：用于存放镜像的仓库，类似 Java 中的包

## Docker架构

### 简单架构

<img src="assets/docker/DDE6804B-C201-4BA7-8A67-9ED59BA8DD2D-4870090-4870091.png" alt="graphic" style="zoom:50%;" />

Docker 是 C/S 架构，客户端发送命令，服务端由后台守护进程，监听各种命令，然后发送给 Docker容器执行。

### 整体架构

<img src="assets/docker/image-20220610221058072.png" alt="image-20220610221058072" style="zoom:50%;" />

启动一个 Docker 可以安装多个容器，每个容器需要去拉取镜像，同时可以有多个 Docker

后面更新...

## 安装docker

安装文档：[Install Docker Engine on CentOS | Docker Documentation](https://docs.docker.com/engine/install/centos/)

1. 卸载旧版本

```shell
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

2. 安装 gcc 环境

```shell
yum -y install gcc
yum -y install gcc-c++
```

3. 安装 docker 需要的软件包

```shell
yum install -y yum-utils
```

4. 设置 stable 镜像仓库

> 这里只是设置用于安装更新 docker 的镜像仓库，不是拉取镜像的仓库

```shell
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

5. 更新 yum 软件包索引

```shell
yum makecache fast
```

6. 安装 docker

```shell
yum -y install docker-ce docker-ce-cli containerd.io
```

7. 测试启动 docker

```shell
systemctl start docker
docker version
docker run hello-world
```

8. 常用命令

```shell
# 停止 docker
systemctl stop docker

# 卸载docker
yum remove docker-ce docker-ce-cli containerd.io
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
```

## 安装阿里云容器镜像服务

登陆->控制台->所有产品按钮->容器镜像服务->镜像工具->镜像加速器->按照操作文档配置即可：[容器镜像服务 (aliyun.com)](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

# 常用指令

## docker 命令

### 启动类

- 启动 docker：systemctl start docker
- 停止 docker：systemctl stop docker
- 重启 docker：systemctl restart docker
- 查看 docker 状态：systemctl status docker
- 开机启动：systemctl enable docker

### 帮助类

- 查看 docker 概要信息：docker info
- 查看 docker 帮助文档：docker --help
- 查看具体命令帮助文档：docker xxx --help

## 镜像命令

### 列出本地镜像

`docker image`

![image-20220611120732503](image-20220611120732503.png)

信息说明：

- REPOSITORY：表示镜像的仓库源

- TAG：镜像的标签版本号，同一个仓库源可以有多个版本，可以使用 REPOSITOTY:TAG 来定义不同版本的镜像

- IMAGE ID：镜像ID

- CREATED：镜像创建时间

- SIZE：镜像大小

选项说明：

- -a 列出所有镜像，并包含历史镜像

- -q 只显示镜像 ID

### 搜索镜像

中央仓库地址：[Docker Hub](https://hub.docker.com/)

镜像搜索命令：docker search redis

信息说明：

![image-20220611121513945](image-20220611121513945.png)

- OFFICIAL：是否官方
- AUTOMATED：是否是自动构建的

选项说明：

- --limit：列出镜像数量，默认 25 个 `docker search --limit 5 redis`

### 下载镜像

docker pull 镜像名称[:TAG]

默认下载最新版，也就是 TAG=latest

### 查看镜像、容器数量、数据卷占用空间

`docker system df`

### 删除镜像

`docker rmi 镜像 ID[:TAG]`

可以直接删除多个

`docker rmi -f $(docker images -qa)`

删除全部镜像

### 虚悬镜像

也就是仓库和标签都是 none 的镜像

后面更新

## 容器命令

必须要有镜像才可以创建容器

### 新建(启动)容器

`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`

OPTIONS 选项说明：

- --name：指定容器名称 `docker run --name 容器名称`

- -d：后台运行容器并返回容器 ID，**大部分情况下都是后台启动的，但是通常要和 i 一起用，也就是要打开一个命令行，因为docker 启动一个容器如果只有后台程序，那么会默认被 docker 容器杀掉这个进程，因为认为你没有前台进程，啥也没干浪费资源** `docker run -id xxx` 另外 -d 如果制定了 -p 端口映射也不会挂掉

- -i：以交互模式运行容器，打开容器并运行一个交互窗口，如果不加 -t 那么是一个黑窗口命令行交互窗口，看着特别诡异，一定要和 -t 一起，要么 -id 要么 -it

- -t：为容器重新分配一个伪输入终端，i 和 t 通常是一起使用的，启动一个输入终端(**输入终端除了系统的输入终端，比如包含一个 redis、mysql 的容器，可以直接输入 redis-cli 进入 redis 的输入终端**) `docker run -it xxx`
  
  - `docker run -it ubuntu /bin/bash` 命令行使用 exit 退出，**退出之后容器也就停止了** ctrl +  p + q 不退出容器，相当于这个命令行一直运行嘛，不输入 -t 的话，那么就不能指定终端
  
- 端口映射：本机开一个端口来对应映射到 docker 上面的具体容器的端口
  
  - -P：随机映射端口
  - -p：指定映射端口，比如第一种方式在本机所有 ip 地址上访问 8080，即可访问到对应容器的 80 端口对应的服务
  - 举例启动 tomcat：`docker run -d -p 8888:8080 -v /root/tomcat/:/usr/local/tomcat/webapps/ tomcat` 后面的是对这个容器启动之后的一些参数配置 [ARG...]
  
  ![image-20220615020705170](image-20220615020705170.png)

启动已停止的容器：

`docker start 容器 ID 或容器名`

重启容器：

`docker restart 容器 ID 或容器名`

### 列出容器

`docker ps [option]`

OPTIONS 选项说明：

- -a :列出当前所有正在运行的容器+历史上运行过的

- -l :显示最近创建的容器。

- -n：显示最近n个创建的容器。

- -q :静默模式，只显示容器编号。

### 退出容器

- exit：run 进入容器，exit 退出，容器停止
- ctrl+p+q：容器不停止

### 停止容器

`docker stop 容器 ID 或容器名`

强制停止：`docker kill 容器 ID 或容器名`

### 删除已停止的容器

`docker rm 容器 ID 或容器名`

删除全部：`docker rm -f $(docker ps -a -q)` **不需要停止也可以删除**

### 进入正在运行的后台容器

一般后台启动的容器，使用下面的命令进入操作

- exit 退出命令行不退出容器(**推荐使用**)：`docker exec -it 容器 ID /bin/bash` 如果容器已经退出关闭，那么先启动  docker  start 容器 ID
- exit 退出命令行退出容器：`docker attach 容器 ID`

### 其它指令

- 查看容器日志：`docker logs 容器 ID`
- 查看容器内运行的进程：`docker top 容器 ID`
- 查看容器内部细节：`docker inspect 容器 ID`
- 复制容器内文件：`docker cp 容器ID:容器内路径 目的主机路径`

### 其它命令汇总

![image-20220615132648482](image-20220615132648482.png)

- attach   Attach to a running container         # 当前 shell 下 attach 连接指定运行镜像
- build   Build an image from a Dockerfile        # 通过 Dockerfile 定制镜像
- commit   Create a new image from a container changes  # 提交当前容器为新的镜像
- cp     Copy files/folders from the containers filesystem to the host path  #从容器中拷贝指定文件或者目录到宿主机中
- create   Create a new container             # 创建一个新的容器，同 run，但不启动容器
- diff    Inspect changes on a container's filesystem  # 查看 docker 容器变化
- events   Get real time events from the server      # 从 docker 服务获取容器实时事件
- exec    Run a command in an existing container     # 在已存在的容器上运行命令
- export   Stream the contents of a container as a tar archive  # 导出容器的内容流作为一个 tar 归档文件[对应 import ]
- history  Show the history of an image          # 展示一个镜像形成历史
- images   List images                  # 列出系统当前镜像
- import   Create a new filesystem image from the contents of a tarball # 从tar包中的内容创建一个新的文件系统映像[对应export]
- info    Display system-wide information        # 显示系统相关信息
- inspect  Return low-level information on a container  # 查看容器详细信息
- kill    Kill a running container            # kill 指定 docker 容器
- load    Load an image from a tar archive        # 从一个 tar 包中加载一个镜像[对应 save]
- login   Register or Login to the docker registry server   # 注册或者登陆一个 docker 源服务器
- logout   Log out from a Docker registry server      # 从当前 Docker registry 退出
- logs    Fetch the logs of a container         # 输出当前容器日志信息
- port    Lookup the public-facing port which is NAT-ed to PRIVATE_PORT   # 查看映射端口对应的容器内部源端口
- pause   Pause all processes within a container     # 暂停容器
- ps     List containers                # 列出容器列表
- pull    Pull an image or a repository from the docker registry server  # 从docker镜像源服务器拉取指定镜像或者库镜像
- push    Push an image or a repository to the docker registry server   # 推送指定镜像或者库镜像至docker源服务器
- restart  Restart a running container          # 重启运行的容器
- rm     Remove one or more containers         # 移除一个或者多个容器
- rmi    Remove one or more images    # 移除一个或多个镜像[无容器使用该镜像才可删除，否则需删除相关容器才可继续或 -f 强制删除]
- run    Run a command in a new container        # 创建一个新的容器并运行一个命令
- save    Save an image to a tar archive         # 保存一个镜像为一个 tar 包[对应 load]
- search   Search for an image on the Docker Hub     # 在 docker hub 中搜索镜像
- start   Start a stopped containers           # 启动容器
- stop    Stop a running containers           # 停止容器
- tag    Tag an image into a repository         # 给源中镜像打标签
- top    Lookup the running processes of a container  # 查看容器中运行的进程信息
- unpause  Unpause a paused container           # 取消暂停容器
- version  Show the docker version information      # 查看 docker 版本号
- wait    Block until a container stops, then print its exit code  # 截取容器停止时的退出状态值

# 保存和提交

保存和提交有三种方式，分享镜像给其他人推荐使用第一种，要将容器迁移到其它文件或者服务器中，推荐用第二种，如果是准备提交到服务器，创建镜像服务器，那么只能用第三种

![在这里插入图片描述](b33934b0f9364452894bcbd81abd70dc.png)

## docker save & load

### 保存

将镜像保存到一个文件中，包含历史，**基于镜像创建**

`docker save [OPTIONS] IMAGE [IMAGE...]`

- -o：输出到文件

将 nginx:latest 镜像保存为 my_nginx.tar

`docker save -o my_nginx.tar nginx:latest`

### 加载

将一个压缩包镜像加载进 docker

`docker load [OPTIONS]`

- input , -i : 指定导入的文件

- quiet , -q : 精简输出信息

将 my_nginx.tar 导入

`docker load input my_nginx.tar`

## 容器导入导出

- 导出容器成为一个镜像：`docker export 容器 ID > 文件名.tar.gz` 默认导入到当前目录
- 导入这个镜像：`cat 文件名.tar.gz | docker import - 镜像用户/镜像名:版本号` cat就是先读取然后再导入，注意导出导入的镜像，必须要加入终端这个参数，docker ps 导出的时候就要知道 COMMAND 终端这个参数，导入之后启动需要输入这个终端参数

## 容器提交和传输

### 容器提交

容器提交后，本地 docker images 会立即显示

`docker commit -m="描述信息" -a="作者" 容器 ID 自己想取的镜像名:标签名`

`docker commit -m="new ubuntu" -a="easylle" 2f43571c9985 easylee/myubuntu:1.0` 

容器提交之后，下一步可以传输到阿里云镜像库或者私服镜像中

# 镜像发布

## 发布到阿里云

目前国内一般都是发布到阿里云，毕竟 hub.docker.com 速度太慢

1. 创建镜像：两种方式可以生成镜像，一种是 docker commit，另外一种是使用 DockerFile 的方式
2. 打开阿里云容器镜像服务：[容器镜像服务 (aliyun.com)](https://cr.console.aliyun.com/cn-hangzhou/instances)
3. 创建命名空间
4. 创建镜像仓库->选择本地仓库
5. 然后按照操作指南操作即可，登陆密码默认是用户账号的密码

## 发布到私服

把镜像发布到自己的服务器，但是首先服务器要有镜像服务

1. 创建一个用于发布的镜像 

     docker commit

2. 将这个镜像标签修改为符合私服的标签

  - docker  tag  宿主机镜像名:Tag  私服 IP:私服端口(registry的端口)/发布到私服的镜像名:Tag
  - `docker tag  myubuntu:1.0  10.211.55.10:5000/myubuntu:1.0`

3. 下载镜像服务镜像

     `docker pull registry ` 提供镜像服务的也是一个 docker  镜像
4. 运行这个容器提供服务

     `docker run -d -p 5000:5000 -v /zzyyuse/myregistry/:/tmp/registry --privileged=true registry` -v  是映射宿主机和容器内的对应文件夹互相共享 --privileged=true  提供 root 权限

5. 修改 docker 配置文件，使支持这个私服 ip 和 http(默认 https)

  vim /etc/docker/daemon.json

 ```json
    {
     "registry-mirrors": ["https://aa25jngu.mirror.aliyuncs.com"],
    	// 这是添加的支持信息，私服ip和端口
     "insecure-registries": ["192.168.111.162:5000"]
    }
 ```

6. 将添加好私服标签的镜像推送到私服仓库

   `docker push 10.211.55.10:5000/myubuntu:1.0`

7. 查看私服仓库中的镜像

   `curl -XGET http://10.211.55.10:5000/v2/_catalog`

8. 拉取私服的镜像

   `docker pull 10.211.55.10:5000/myubuntu:1.0`

# docker 数据卷共享

docker 数据卷就是用于备份 docker 容器中的数据，和宿主机进行数据共享，通常用于备份日志等信息，举例说明 mysql 的数据，做了映射之后即使 mysql 崩溃了，但是服务器上还有数据备份

- 添加映射：添加之后宿主机和容器之间就可以共享文件

`docker run -it --privileged=true -v /宿主机绝对路径:/容器内路径 镜像名`

`docker run -it --privileged=true -v /root/testr:/root/testr --name u1 ubuntu`

- 查看是否挂载成功

`docker inspect 容器ID`

- 读写规则配置，默认可读写

`docker run -it --privileged=true -v /root/testr:/root/testr:rw --name u1 ubuntu`

`docker run -it --privileged=true -v /root/testr:/root/testr:ro --name u1 ubuntu`	read only 可读不可写，针对容器，宿主机仍然可写，容器内可以同步到，只是容器内不可写

- 卷容器继承

`docker run -it --privileged=true --volumes-from 父类容器名或 ID --name 子类命名 镜像名` 这样这个新容器可以和父类容器同样三个文件夹同时共享，功能完全一样

# docker 常用镜像安装

## 安装 tomcat

安装最新版 tomcat 需要修改 webapps 目录，而 tomcat8 版本不需要

### 安装最新版

`docker run -d -p 8080:8080 tomcat`

安装最新版之后，访问网址 8080 显示404，这是因为默认 tomcat10 webapps 目录为空，为了安装，默认网页放在 webapps.dist 中，需要删除 webapps，重命名 webapps.dist 为 webapps

### 安装tomcat8

`docker pull billygoo/tomcat8-jdk8`

`docker run -d -p 8080:8080 --name mytomcat8 billygoo/tomcat8-jdk8`

## 安装 mysql

```shell
docker run -d -p 3306:3306 
--privileged=true 
-v /zzyyuse/mysql/log:/var/log/mysql 
-v /zzyyuse/mysql/data:/var/lib/mysql 
-v /zzyyuse/mysql/conf:/etc/mysql/conf.d 
-e MYSQL_ROOT_PASSWORD=123456
--name mysql mysql:5.7
```

-e 配置 root 密码

-v 配置需要备份的文件夹

需要修改或者新建 my.cnf 修改 utf8 中文配置，添加下面内容

```xml
[client]
default_character_set=utf8
[mysqld]
collation_server = utf8_general_ci
character_set_server = utf8
```

具体配置还是要在学习 mysql 时学习

**配置了备份之后，如果 mysql 容器被删除之后，直接再次 run 一个相同的容器，共享文件和之前的一样，那么就依然会有之前的数据**

其它软件都大同小异，要注意各自的配置之类的就行

