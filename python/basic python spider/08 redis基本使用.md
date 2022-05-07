## redis数据库

下载地址：http://redis.io/download



### 安装

mac下载安装包tar.gz即可

```shell
# 解压安装包
tar -zvxf redis-3.0.7.tar.gz

# 解压后首先移到合适的目录，比如/usr/local，并更改文件名
cd /usr/local/redis
sudo make test

# 编译安装, 新版本安装后会直接安装到/usr/local/bin环境目录
sudo make install

# 启动redis服务端
redis-server

# 启动redis客户端 输入redis命令
redis-cli

# redis关闭
# 在启动端直接ctrl+c可以关闭，如果没有关闭，那么可以用一下方式关闭
ps axu|grep redis	# 查找redis的PID
kill -9 PID

# 卸载redis，删除/usr/local/redis目录，同时删除/usr/local/bin目录下redis相关的命令
```



### 修改配置

修改redis目录下redis.conf文件，使用redis默认即可，用户名密码为空，有需要后面再设置，或者后期学习redis时再设置

