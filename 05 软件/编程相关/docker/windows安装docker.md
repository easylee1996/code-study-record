## windows和linux安装docker
请直接使用linux进行安装，windows安装实质上是使用的wsl的linux子系统运行docker，所以直接使用linux安装最合适
使用windows的wsl安装ubuntu（打开linux子系统选项之后，微软商店就可以下载）
安装docker，询问通义千问：如何在ubuntu里面安装docker和docker-compose
wsl需要多一个步骤：wsl --update，将wsl更新到最新版，然后给/etc/wsl.conf文件添加：
```conf
[boot]
systemd=true
```
否则的话，子系统无法使用任何有关服务的命令，当然也就无法启动docker，虚拟机或者直接linux系统没有这个问题
## wsl说明
wsl里面linux使用的各种服务，实质上在windows上可以直接访问，比如各种端口上的服务，但是windows局域网内的其它电脑无法访问，需要下载这个文件运行来映射给局域网：[Release v1.1.0 · HobaiRiku/wsl2-auto-portproxy · GitHub](https://github.com/HobaiRiku/wsl2-auto-portproxy/releases/tag/v1.1.0)

