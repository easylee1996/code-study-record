---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# 概述

zookeeper 是 Apache 下的一个分布式、开源的分布式应用协调服务(也就是中间商)，是使用 java 开发的，可以用于做 SpringCloud 的注册中心角色。

## 数据模型

![image-20220618120410979](image-20220618120410979.png)

zookeeper的数据模型就是一个属性结构，每个节点创建到上面一个节点之下。

特点如下：

- 每个子目录如/node 都被成为一个 znode(节点)
- 每个 znode 节点都可以有子目录，每个节点可以存储数据
- znode 节点是有版本的，每个节点可以存储多个版本的数据
- znode 节点的路径和数据是可以被 watch 监控的

## 节点分类

首先要明确客户端的概念，**zookeeper 包含服务端和客户端，节点是客户端连接了服务端之后在服务端上创建**

- 持久节点：创建后一直存在，知道有命令删除，**不会因创建该节点的客户端失效和消失**

- 持久顺序节点：创建一个相同名称的节点，会在节点路径上加上时间顺序，也就是创建多个同一名称的节点，数字后缀最大为整型的最大值
- 临时节点：创建这个节点的客户端失效，那么这个节点就会消失，**通常用于注册中心的注册，微服务客户端失效，那么在注册中心中自然也就消失了**
- 临时顺序节点：同持久顺序节点，只是同样会随着创建节点的客户端失效而消失

> 注意临时节点不能创建子节点

## 安装

- linux 安装

  - **必须先安装有jdk**
  - 下载地址：谷歌搜索 apache 归档，可以直接下载历史版本，当前文档选择 3.4.12 版本
  - 上传解压重命名
  - 配置文件：conf目录下，复制一份为zoo.cfg，**zookeeper 每次启动需要有配置文件启动**
  - 启动 zookeeper：`./bin/zkServer.sh start /root/zookeeper/conf/zoo.cfg`
  - 停止 zookeeper：`./bin/zkServer.sh stop /root/zookeeper/conf/zoo.cfg`
  - jps 查看是否启动(jps 是 java的服务查看，如果是centos 默认的 openjdk，需要单独安装)

  ```shell
  # 显示可安装的 jdk-devel 
  yum list | grep jdk-devel
  # 安装对应版本的 jdk-devel
  yum install java-1.8.0-openjdk-devel.x86_64
  ```

  - 启动客户端：`./bin/zkCli.sh -server 10.211.55.10:2181` 默认是2181 端口，可以在配置文件中配置

- docker 安装(docker 最好用 docker-compose 来编排集群)
  - `docker pull zookeeper:3.4.12`
  - `docker run -d -p 2181:2181 zookeeper:3.4.12`

> docker 安装的 zookeeper 配置文件在根目录下的 /conf 下，所有东西的配置文件都在这里

## 配置文件详解

- tickTime：集群服务器节点之间心跳发送时间
- initLimit：初始化集群超时时间
- syncLimit：集群节点之间同步数据超时时间
- dataDir：持久化数据目录
- clientPort：端口配置
- maxClientCnxns：节点池，类似线程池
- autopurge.snapRetainCount：快照保留次数

# 常用指令

- 查看节点下的子节点：`ls path`
- 查看节点状态：`stat path`
- 同时查看节点子节点和节点状态：`ls2 path`
- 查看历史记录：`history`

- 创建节点：`create path data`
  - -s：创建持久顺序节点
  - -e：创建临时节点
  - -e -s：创建临时顺序节点
- 修改节点数据：`set path data`
- 获取节点数据：`get path`
- 删除节点：`delete path`
- 递归删除节点：`rmr path`
  - 退出会话：`quit` 当前会话失效

# 节点监控

可以监控节点变化和数据变化，要注意使用linux启动的节点监控是一次性的，只会触发一次，但是使用 java 程序是永久触发的，注册中心的实现也是通过监控系统来判断微服务的状态

具体可以使用 help 命令，后面带有 watch 选项的都可以开启监控，常用的是下面这两个

- 监控节点目录变化：`ls path true` 监控之后，其它的客户端删除这个节点，当前客户端会收到通知

- 监控节点数据变化：`get path true`

# java 操作 zookeeper

首先需要导入依赖：

```xml
<dependency>
    <groupId>com.101tec</groupId>
    <artifactId>zkclient</artifactId>
    <version>0.10</version>
</dependency>
```

基本方法：

```java
public class ZkClientTest {
    private ZkClient zkClient;

    // 创建节点
    @Test
    public void testCreate() {
        // 方式一：返回创建节点的名称
        String nodeName = zkClient.create("/node1","持久节点", CreateMode.PERSISTENT); // 持久节点
        zkClient.create("/node2","持久顺序节点", CreateMode.PERSISTENT_SEQUENTIAL); // 持久顺序节点
        zkClient.create("/node3","临时节点", CreateMode.EPHEMERAL); // 临时节点
        zkClient.create("/node4","临时顺序节点", CreateMode.EPHEMERAL_SEQUENTIAL);  // 临时顺序节点

        // 方式二：不返回创建节点的名称
        zkClient.createPersistent("/node5","持久节点");
        zkClient.createPersistentSequential("/node6","持久顺序节点");
        zkClient.createEphemeral("/node6","临时节点");
        zkClient.createEphemeralSequential("/node7","临时顺序节点");
    }

    // 删除节点
    @Test
    public void testDelete() {
        // 删除没有子节点的节点
        boolean delete = zkClient.delete("/node1");
        // 递归删除节点
        boolean deleteAll = zkClient.deleteRecursive("/node2");
    }

    // 查询节点的子节点信息
    @Test
    public void testFindNode() {
        List<String> children = zkClient.getChildren("/");
        for (String child : children) {
            System.out.println(child);
        }
    }

    // 查询节点数据
    @Test
    public void testFindNodeData() {
        Object readData = zkClient.readData("/node1");
        System.out.println(readData);
    }

    // 查询节点数据和状态信息
    @Test
    public void testFindNodeDataAndStat() {
        Stat stat = new Stat();
        Object readData = zkClient.readData("/node1", stat);
        System.out.println(readData);
        System.out.println(stat.getCversion());
        System.out.println(stat.getCtime());
        System.out.println(stat.getCzxid());
    }

    // 修改节点数据
    @Test
    public void testWriteData() {
        User user = new User();
        user.setName("easylee");
        user.setAge(26);
        zkClient.writeData("/node1", user);
        User o = zkClient.readData("/node1");
        System.out.println(o.getName());
    }
  
  
  /********* 连接和关闭方法 ***********/
    @Before
    public void before() {
        // ip地址
        // 会话超时时间，一个操作的超时时间
        // 连接超时时间，一个连接的超时时间
        zkClient = new ZkClient("10.211.55.10:2181",3000,
                6000,new SerializableSerializer());

    }

    @After
    public void after() {
        zkClient.close();
    }
}
```

监听节点数据变化：

```java
// 监听节点数据的变化
@Test
public void testOnNodeDataChange() throws IOException {
    zkClient.subscribeDataChanges("/node1", new IZkDataListener() {
        @Override
        public void handleDataChange(String dataPath, Object data) throws Exception {
            System.out.println(dataPath);
            System.out.println(data);
        }

        @Override
        public void handleDataDeleted(String dataPath) throws Exception {
            System.out.println(dataPath);
        }
    });
}

// 监听节点目录的变化
@Test
public void testOnNodesChange() throws IOException {
    zkClient.subscribeChildChanges("/node1", new IZkChildListener() {
        @Override
        public void handleChildChange(String parentPath, List<String> currentChilds) throws Exception {
            System.out.println("父节点名称" + parentPath);
            System.out.println("发生变更后子节点变化");
            for (String child : currentChilds) {
                System.out.println(child);
            }
        }
    });
}
```

# 集群架构

![image-20220618233543408](image-20220618233543408-5566545.png)

架构集群最好是单数个服务器，集群中选举一个为 Leader 主节点，读取写入都要向 Leader 服务器确认，其它的服务器都是 Following 仲裁节点可以有多个，当 Leader 挂掉的话，会重新从 Follower 中选举一个

### 集群搭建

1. 创建三个 dataDir

`mkdir zkdata1 zkdata2 zkdata3`

2. 分别在三个 dataDir 目录下创建 myid 文件，里面保存具体的数字 1 2 3，表示是第几个服务器

`touch ./zkdata1/myid ./zkdata2/myid ./zkdata3/myid`

`echo "1" >> ./zkdata1/myid`

`echo "2" >> ./zkdata2/myid`

`echo "3" >> ./zkdata3/myid`

3. 在 /conf 下创建三个配置文件，代表三台服务器，当然实际线上不需要，每个服务器使用自己的配置文件即可

在里面分别加入下面的配置即可，每个配置文件都要一致，都要添加相同的集群信息：

```shell
server.1=10.15.0.5:3002:3003
server.2=10.15.0.5:4002:4003
server.3=10.15.0.5:5002:5003

# 1.2.3 表示服务器的标识
# 3002、4002、5002 表示数据同步使用的端口
# 3003、4003、5003 表示选举使用的端口
# 上面的端口信息和服务使用的端口不一样，节点配置的那个服务器端口是客户端连接使用的，这里配置的端口是服务器集群节点之间使用的
# 这里只是一个服务器模拟，真实线上 ip 地址应该不同，数据同步端口和选举端口应该是一样的，我们这里因为是一台机器所以不一样
```

4. 配置完成之后直接启动三台服务器即可

### 客户端连接

客户端在连接集群的时候，连接任意一台集群中的机器都可以，都会使用集群服务，当然这肯定是不科学的，因为如果这个挂掉了，岂不是访问不了了，后期学完 springcloud 之后再继续深入。
