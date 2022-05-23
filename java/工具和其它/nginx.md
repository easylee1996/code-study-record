![nginx](assets/nginx/nginx.png)

nginx是一个http的反向代理服务器，同时是一个动态静态的资源分离服务器，让tomcat无需处理静态资源，静态资源直接通过nginx直接找到文件并返回，同时nginx是一个静态网站服务器，如果网站只有静态html等资源，可以直接作为一个静态网站服务器，独立提供服务。

nginx拥有以下优点：

- nginx是一个高并发、高性能的服务器

- 可扩展性好，配置良好的插件环境
- 高可靠性，不需要处理可以持续不断运行数年
- 热部署，在不停止服务的情况下升级和部署内容
- 开源，可商用

# linux安装

安装nginx的依赖环境

```shell
yum install yum-utils
```

配置nginx的源地址

```shell
vim /etc/yum.repos.d/nginx.repo
```

输入下面的源地址：

```shell
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```

查看一下源是否配置成功，成功列出nginx的所有版本

```shell
yum list | grep nginx
```

开始安装

```shell
yum install nginx 1:1.16.1-1.el7.ngx
```

查看是否安装成功

```shell
nginx -v
```

查看nginx的安装位置

```shell
whereis nginx
```

# 常见命令

### 启动nginx

```shell
/usr/sbin/nginx
```

### 停止nginx

```shell
nginx -s stop
```

### 帮助-h

### 读取指定配置文件-c后启动

首先查看nginx配置文件目录

```shell
cd /etc/nginx
```

然后指定需要的配置文件

```shell
nginx -c /etc/nginx/nginx.conf
```

测试和查看配置文件

因为配置文件是没有语法提示的，所以必须测试一下，同时可以查看当前是哪一个配置文件

```shell
nginx -t
```

### -s信号

```shell
# 立即停止
nginx -s stop
# 优雅停止
nginx -s quit
# 重启 内部是优雅停止
reload 
# 更换日志文件
reopen
```

# 配置文件

### 默认配置文件说明

```shell
cd etc/nginx
cat nginx.conf
```

```nginx
# 运行用户，默认是nginx，有时候需要设置为user root的权限，暂时不用管
user  nginx;
# nginx进程数,一般设置为和cpu核数一样
worker_processes  1;

# 全局错误日志路径
error_log  /var/log/nginx/error.log warn;
# 进程pid路径
pid        /var/run/nginx.pid;

events {
# 最大连接数
    worker_connections  1024;
}

# 设置http服务器
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
# 设置日志的格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
# 访问日志的路径
    access_log  /var/log/nginx/access.log  main;

# 开启高效传输模式
    sendfile        on;
    #tcp_nopush     on;
# 长连接超时时间，单位是秒
    keepalive_timeout  65;
#传输时是否压缩，压缩的话需要解压，但是传的大小就小了
    #gzip  on;
#加载其他的配置文件，一带多，一般服务器配置都是在/conf.d文件夹下面，可以配置多个
    include /etc/nginx/conf.d/*.conf;
}
```

### 创建一个静态网页的配置文件

首先将静态资源上传到指定位置`/usr/share/nginx/`

然后配置`vim /etc/nginx/conf.d/default.conf`配置文件，这个文件是由`nginx.conf`包含进来的，这个配置文件可以配置多个，因为nginx.conf将这个文件夹下的所有配置文件都包含了

将启动的文件夹改为我们上传的文件夹，修改下面两出root的文件夹即可，root表示的是网页的根目录：

```nginx
server {
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

