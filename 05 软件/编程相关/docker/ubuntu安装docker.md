## 安装docker
1.卸载老版本
`apt-get remove docker docker-engine docker.io containerd runc`
2.更新软件包
```shell
sudo apt update 
sudo apt upgrade
```
3.安装docker依赖
```shell
apt-get install ca-certificates curl gnupg lsb-release
```
4.添加官方GPG密钥，保证软件正确(阿里云)
```shell
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
```
5.添加docker
```shell
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
## 安装docker-compose
上面第5步，已经安装了docker compose，这是新版，可以直接使用 `docker compose` 命令来进行使用，但通常还是使用老版本命令，则可以继续安装老版本 `docker-compose` 工具。
```shell
curl -L https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

上面中从github下载太慢的话，可以手动从 [Releases · docker/compose](https://github.com/docker/compose/releases) 下载对应的版本
```shell
echo `uname -s`-`uname -m`
```
可以查看系统的版本
下载之后，移动到 `/usr/local/bin` 目录并设置可执行权限即可
## 验证安装
```shell
docker -v
docker-compose -v
```

## 启动
```shell
# 开机自启
systemctl enable --now docker
#启动
systemctl start docker
```