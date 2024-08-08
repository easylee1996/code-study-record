---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
1.找到项目源代码
```
docker exec -it 容器ID /bin/bash
# 不支持bash，那就用sh
docker exec -it 容器ID /bin/sh
```
通常都是根目录下的/app文件夹

2.将这个文件夹复制到本地
```shell
docker cp 容器ID:/app ./app(本地或者linux服务器的目录)
```
不要直接修改容器内的代码，无法修改，因为容器内代码在运行中，通常也不能停止容器内启动的代码服务，因为docker的机制绝对，这个服务启动在1这个主进程，如果kill整个容器也就停止了
所以需要复制到本地，然后将本地映射到容器

3.本地映射到容器
```
docker run -it -v /path/to/myapp:/usr/src/app --name my-running-app my-app
```
如果是docker-compose则直接在文件里面增加一个volume配置即可

4.最后就可以通过修改本地的代码，实现修改容器内代码
