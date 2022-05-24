<img src="assets/RabbitMQ/logo-rabbitmq.svg" width="50%" alt="RabbitMQ"  />

RabbitMQ是一个消息队列框架，主要由producer发件人、queue队列、consumer收件人三者组成，并且这三者可以放在不同的服务器中，处理不同的业务。

消息队列MQ(message queue)，是一种先进先出的结构，主要特性如下：

- 业务无关：不需要考虑具体的上层业务，只需要处理具体的消息分发即可
- FIFO
- 容灾：可以进行持久化，服务器崩溃重启后依然可以重新获取这个队列
- 高性能

消息队列，可以让复杂的业务**系统解耦**，让发消息的业务使用MQ中间件来独立处理不同业务的消息处理。

同时消息队列是**异步调用**的。

流量削峰是消息队列的另外一个特点，当流量在某个时间段有明显的大的提升，我们不需要购买额外的服务器，避免在平时阶段资源浪费，而是将大量超出的流量交给MQ处理，MQ会以我们服务器可以接受的流量额度交给我们处理，其余的全部放在队列中等待，逐步的化解压力。

# RabbitMQ核心概念

### Server服务

使用RabbitMQ首先需要创建一个server服务端，来具体的处理消息

### connection

与Server建立连接

### channel

信道，几乎所有的操作都是在信道上进行，客户端可以建立多个信道

### message

消息，有`properties`(对消息的配置修饰)和`body`(具体内容)组成

### virtual host

虚拟主机，顶层隔离，一个服务端可以创建多个虚拟主机，但是同一个虚拟主机下，不能有重复的交换机和queue队列

### exchange

交换机，接受生产者消息，然后根据指定的路由器把消息转发到所绑定的队列上，**一个exchange可以绑定多个队列**，同时有多个交换机

### binding

绑定交换机和队列，交换机只有一个，队列是可以有多个，然后通过绑定交换机和具体的队列来分配不同的消息

### routing key

路由键，路由规则，虚拟机可以用它来确定这个消息如何进行一个路由流转

### queue

队列，**消费者只需要监听队列来消费消息**，不需要关注消息来自于哪个exchange交换机，只需要关注队列即可

# RabbitMQ linux安装

学习项目推荐使用下面两个安装包，避免报错

assets/RabbitMQ/erlang-22.3-1.el7.x86_64.rpm

assets/RabbitMQ/rabbitmq-server-3.8.2-1.el7.noarch.rpm

首先将上面两个包传到服务器上，然后安装erlang-22.3-1.el7.x86_64.rpm，这是erlang语言，RabbitMQ依赖erlang语言

```shell
yum install erlang-22.3-1.el7.x86_64.rpm
```

然后安装RabbitMQ，首先导入rabbitmq的密钥

```shell
rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
```

然后安装RabbitMQ：

```shell
yum install rabbitmq-server-3.8.2-1.el7.noarch.rpm
```

卸载yum包：

```shell
# 首先查看包的详细名称，最后一栏才是完整的报名
yum list | grep xxx
# 卸载包
yum remove xxx
```

# 常用命令

### 停止RabbitMQ

```shell
rabbitmqctl stop 
```

### 设置开机启动

```shell
systemctl enable rabbitmq-server 
```

### 启动RabbitMQ

```shell
systemctl start rabbitmq-server
```

### 查看端口状态

```shell
rabbitmqctl status 
```

### 检查RabbitMQ服务器的状态

```shell
systemctl status rabbitmq-server
```

### 开启web管理界面

```shell
rabbitmq-plugins enable rabbitmq_management
```

# web管理面板

rabbitmq-plugins enable rabbitmq_management

 

添加admin账号，赋予administrator权限

 

rabbitmqctl add_user admin password

rabbitmqctl set_user_tags admin administrator