---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
服务注册与发现，总的来讲，就是将微服务进行统一管理和调用，而不通过 ip 的形式调用。

# Eureka

Eureka 是 Spring Cloud 全家桶的服务注册与发现组件，后面没有更新了

## 单机 Eureka

### 创建eurekaServer端

用于管理微服务，同样和创建其它项目一样，创建 5 步骤，只是 yml 配置不同，添加了 eureka 的相关配置

- 建立Module

cloud-eureka-server7001

- 修改 POM

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>mscloud</artifactId>
        <groupId>org.example</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>cloud-eureka-server7001</artifactId>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
        <!--eureka依赖-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
        <!--spring boot 的依赖仍然需要，因为本质也是一个boot-->
        <!--web和actuator是boot必备的两个依赖-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
```

- 写 YML

```yaml
server:
  port: 7001
eureka:
  # 针对于eureka而言的实例相关配置，一般客户端是不需要写这个的，只有 server 端
  instance:
    hostname: localhost # eureka 服务端的实例名称
  # 当前这个boot实例相关的配置
  client:
    # 是否向注册中心注册自己，默认true
    register-with-eureka: false
    # 是否需要从注册中心拉取其它服务，默认true，应该是其它服务向我注册向我拉取微服务，注册中心本身不需要
    fetch-registry: false
    service-url:
      # 交互的地址，其它微服务通过这个地址注册和拉取
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

- 主启动添加服务端配置

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaMain7001 {
    public static void main(String[] args) {
        SpringApplication.run(EurekaMain7001.class,args);
    }
}
```

启动之后访问：http://localhost:7001 即可访问

### 注册客户端 cloud-provider-payment8001

- 修改 POM，添加 Eureka 支持

```xml
<!--eureka 客户端依赖-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

- 修改 YML

```yaml
# 注意这个名字会显示在服务中心
spring:
  application:
    name: cloud-payment-service

eureka:
  client:
    #表示是否将自己注册进EurekaServer默认为true
    register-with-eureka: true
    #是否从EurekaServer抓取已有的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合ribbon使用负载均衡
    # 必须抓取服务才知道 server 端有多少服务，具体怎么选择之类
    fetchRegistry: true
    service-url:
      defaultZone: http://localhost:7001/eureka
```

- 主启动添加客户端配置

```java
@EnableEurekaClient
```

启动之后，注册中心就会显示这个微服务

![image-20220617165636749](image-20220617165636749.png)

### 注册客户端 cloud-consumer-order80

配置和上面一致

要注意 YML 配置的时候，添加一个服务的名称，因为之前我们配置 80 服务时没有配置

```yaml
spring:
  application:
    name: cloud-order-service
```

## 集群 Eureka 构建

### Eureka Server 构建

原理是，在注册地址的时候，相互注册，组建成集群

组建之前，先修改一下 hosts 配置，正常来讲，不同的 server 应该在不同的服务器上，不同的 ip，所以都在本地的话需要配置两个本地的域名来代表两个不同的服务器，否则都是用 localhost 无法区分两个服务器

`sudo vim /etc/hosts` 添加一下内容

**请注意，不要开VPN代理，开了之后hosts屏蔽的直接走代理的配置文件了，所以使用时请关闭**

```
# Eureka Server
127.0.0.1  eureka7001.com
127.0.0.1  eureka7002.com
```

- 创建 cloud-eureka-server7002
- 复制之前 cloud-eureka-server7001 的所有文件内容(src)
- 修改pom，添加 eureka server 依赖
- 修改server YML

将两个配置文件通过 url 互相串联起来，你访问我，我访问你，**注意 hostname 也修改成了配置的 hosts 域名**，当然同样都是映射的 localhost，所以后面的 url 还是需要端口来区分不同的服务

7001 yml

```yaml
server:
  port: 7001
eureka:
  # 针对于eureka而言的实例相关配置
  instance:
    hostname: eureka7001.com # eureka 服务端的实例名称
  # 当前这个boot实例相关的配置
  client:
    # 是否向注册中心注册自己，默认true
    register-with-eureka: false
    # 是否需要从注册中心拉取其它服务，默认true，应该是其它服务向我注册向我拉取微服务，注册中心本身不需要
    fetch-registry: false
    service-url:
      # 交互的地址，其它微服务通过这个地址注册和拉取
      defaultZone: http://eureka7002.com:7002/eureka/
```

7002 yml

```yaml
server:
  port: 7002
eureka:
  # 针对于eureka而言的实例相关配置
  instance:
    hostname: eureka7002.com # eureka 服务端的实例名称
  # 当前这个boot实例相关的配置
  client:
    # 是否向注册中心注册自己，默认true
    register-with-eureka: false
    # 是否需要从注册中心拉取其它服务，默认true，应该是其它服务向我注册向我拉取微服务，注册中心本身不需要
    fetch-registry: false
    service-url:
      # 交互的地址，其它微服务通过这个地址注册和拉取
      defaultZone: http://eureka7001.com:7001/eureka/
```

- 修改两个服务 client yml

将每个客户端微服务，分别同时注册到两个 server 端，分别修改如下，添加了两个 url

```yaml
eureka:
  client:
    #表示是否将自己注册进EurekaServer默认为true
    register-with-eureka: true
    #是否从EurekaServer抓取已有的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合ribbon使用负载均衡
    # 必须抓取服务才知道 server 端有多少服务，具体怎么选择之类
    fetchRegistry: true
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
```

### 客户端 Eureka Client构建

这里构建两个 cloud-provider-payment8001，避免一个服务提供者崩溃了，业务不可用

- 新建 cloud-provider-payment8002
- 复制 pom 依赖，修改 yml  配置文件(仅端口不一样)，主启动文件名修改，mapper 文件复制(**注意文件里面相关的包名路径，复制中有可能错乱**)

- 添加一个显示当前是哪个服务端的端口代码(用于区分是哪个服务端在提供后端服务)

在控制器中添加如下代码，用于获取当前微服务的端口，然后在后面具体控制器方法中调用这个端口即可

```java
@Value("${server.port}")
private String serverPort;
```

- 修改负载均衡

现在 80 前端控制器访问的地址还是写死的，修改为 Eureka 具体后端服务的地址，也就是上面的cloud-provider-payment

```java
@RestController
public class OrderController {
    public static final String PAYMENT_SRV_URL = "http://CLOUD-PAYMENT-SERVICE";

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping("/consumer/payment/create")
    public CommonResult create(Payment payment) {
        // 参数：请求连接，传递的参数，返回的实体
        return restTemplate.postForObject(PAYMENT_SRV_URL + "/payment/create", payment, CommonResult.class);
    }

    @GetMapping("/consumes/payment/get/{id}")
    public CommonResult getPayment(@PathVariable("id") Long id) {
        return restTemplate.getForObject(PAYMENT_SRV_URL + "/payment/get/" + id, CommonResult.class, id);
    }
}
```

http://CLOUD-PAYMENT-SERVICE 这个名字是微服务注册的名字，也可以在 server 网页中查看

- 配置负载均衡

在上面使用了 CLOUD-PAYMENT-SERVICE 服务名作为连接，如果不配置负载均衡，那么将找不到连接，所以必须开启

com.easylee.springcloud.config.ApplicationContextConfig.java，也就是给`RestTemplate`添加负载均衡，因为是使用这个来发起url请求的

```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```

**负载均衡配置完成之后，如果访问还是找不到 CLOUD-PAYMENT-SERVICE 服务名的话，将下面的actuator配置设置一下(一般情况下可以)**

## actuator微服务信息完善

默认的微服务实例没有名称，是按照默认的格式显示名称的，不太方便，同时将鼠标放到微服务名称上，不显示ip地址

设置实例 id 和 显示 ip

```java
eureka:
  client:
    #表示是否将自己注册进EurekaServer默认为true
    register-with-eureka: true
    #是否从EurekaServer抓取已有的注册信息，默认为true。单节点无所谓，集群必须设置为true才能配合ribbon使用负载均衡
    # 必须抓取服务才知道 server 端有多少服务，具体怎么选择之类
    fetchRegistry: true
    service-url:
      defaultZone: http://payment7001.com:7001/eureka,http://payment7002.com:7002/eureka
 # 设置实例 id 和 显示 ip
  instance:
    instance-id: payment8001
    prefer-ip-address: true
```

## 服务发现Discovery

注册进 eureka 的微服务，获取该服务的信息

修改 8001 Controller 代码，添加服务发现的代码

```java
package com.easylee.springcloud.controller;

import com.easylee.springcloud.entities.CommonResult;
import com.easylee.springcloud.entities.Payment;
import com.easylee.springcloud.service.PaymentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author easylee
 * @createTime 2022/6/17 01:20
 * @updateTime 2022/6/17 01:20
 * @Version 1.0.0
 */
@RestController
@Slf4j
public class PaymentController
{
    @Value("${server.port}")
    private String serverPort;

    @Resource
    private PaymentService paymentService;

    // 注册服务发现
    @Resource
    private DiscoveryClient discoveryClient;

    @PostMapping(value = "/payment/create")
    public CommonResult create(@RequestBody Payment payment)
    {
        int result = paymentService.create(payment);
        log.info("*****插入操作返回结果:" + result);

        if(result > 0)
        {
            return new CommonResult(200,"插入成功,返回结果"+result+"\t 服务端口："+serverPort,payment);
        }else{
            return new CommonResult(444,"插入数据库失败",null);
        }
    }

    @GetMapping(value = "/payment/get/{id}")
    public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id)
    {
        Payment payment = paymentService.getPaymentById(id);
        log.info("*****444查询结果:{}",payment);
        if (payment != null) {
            return new CommonResult(200,"查询成功"+"\t 服务端口："+serverPort,payment);
        }else{
            return new CommonResult(444,"没有对应记录,查询ID: "+id,null);
        }
    }

   // 服务发现
    @GetMapping(value = "/payment/discovery")
    public Object discovery()
    {
        List<String> services = discoveryClient.getServices();
        for (String element : services) {
            log.info("*****element: "+element);
        }

        List<ServiceInstance> instances = discoveryClient.getInstances("CLOUD-PAYMENT-SERVICE");
        for (ServiceInstance instance : instances) {
            log.info(instance.getServiceId()+"\t"+instance.getHost()+"\t"+instance.getPort()+"\t"+instance.getUri());
        }

        return this.discoveryClient;
    }


}
```

修改主启动类，添加服务发现

```java
@SpringBootApplication
@EnableEurekaClient
@EnableDiscoveryClient	// 服务发现
public class PaymentMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain8001.class,args);
    }
}
```

## Eureka自我保护

Eureka 默认微服务当网络不稳定等原因导致，无法正常接收到心跳包时，不会立即清理，会进行微服务自我保护

### 禁止自我保护

- server 端

使用`eureka.server.enable-self-preservation = false` 可以禁用自我保护模式

```yaml
eureka:
  server:
    # 关闭自我保护机制，保证不可用服务被及时踢除，并设置检测时间为2秒
    enable-self-preservation: false
    eviction-interval-timer-in-ms: 2000
```

- client 端

```yaml
eureka:
  instance:
    #Eureka客户端向服务端发送心跳的时间间隔，单位为秒(默认是30秒)
    lease-renewal-interval-in-seconds: 1
    #Eureka服务端在收到最后一次心跳后等待时间上限，单位为秒(默认是90秒)，超时将剔除服务
    lease-expiration-duration-in-seconds: 2
```

# zookeeper

使用 zookeeper 完成服务注册中心的工作

## 启动 zookeeper 服务

使用 docker 启动一个 zookeeper server 端

`docker run -d -p 2181:2181 zookeeper:3.4.9`

> **注意一定要关闭防火墙，或者将需要的端口通过**
>
> **注意 yml 配置一定要格式正确，错了吃大亏**

## 整合SpringCloud

### 服务提供者新建

- 新建 cloud-provider-payment8004
- pom 文件

```xml
<dependencies>
    <!--zookeeper 客户端依赖-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
      <!--spring-cloud-starter-zookeeper-discovery自己会依赖zookeeper3.5.3，我们需要依赖自己服务器上的zookeeper版本，所以排除然后自己倒入zookeeper依赖-->
        <exclusions>
            <exclusion>
                <groupId>org.apache.zookeeper</groupId>
                <artifactId>zookeeper</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    <dependency>
        <groupId>org.apache.zookeeper</groupId>
        <artifactId>zookeeper</artifactId>
        <version>3.4.9</version>
      <!--zookeeper中导入的slf4j原本就有日志系统，导入会冲突，所以排除-->
        <exclusions>
            <exclusion>
                <groupId>org.slf4j</groupId>
                <artifactId>slf4j-log4j12</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    <!--导入公共 entities-->
    <dependency>
        <groupId>org.example</groupId>
        <artifactId>cloud-api-commons</artifactId>
        <version>${project.version}</version>
    </dependency>
    <!--web和actuator是boot必备的两个依赖-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

- yml：格式一定要正确

```yaml
#8004表示注册到zookeeper服务器的支付服务提供者端口号
server:
  port: 8004
#服务别名----注册zookeeper到注册中心名称
spring:
  application:
    name: cloud-provider-payment
  cloud:
    zookeeper:
      connect-string: 10.211.55.15:2181	# 如果是集群，就添加多个 ip
```

- 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class PaymentZkMain8004 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentZkMain8004.class,args);
    }
}
```

- 业务类 controller

```java
@RestController
public class PaymentController {
    @Value("${server.port}")
    private String serverPort;

    @RequestMapping(value = "/payment/zk")
    public String paymentZK() {
        return "SpringCloud with zookeeper:" + serverPort + "\t" + UUID.randomUUID().toString();
    }
}
```

- 验证测试

http://localhost:8004/payment/zk

> 服务节点是一个临时节点

### 服务消费者

- 新建 cloud-consumerzk-order80
- pom

```xml
<!-- SpringBoot整合zookeeper客户端 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
    <!--先排除自带的zookeeper-->
    <exclusions>
        <exclusion>
            <groupId>org.apache.zookeeper</groupId>
            <artifactId>zookeeper</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<!--添加zookeeper3.4.9版本-->
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>3.4.9</version>
</dependency>
```

不排除 slf4j-log4j12 好像不会报错，如果报错则排除一下

- YML

```yaml
server:
  port: 80

spring:
  application:
    name: cloud-consumer-order
  cloud:
    zookeeper:
      connect-string: 10.211.55.15:2181
```

- 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class OrderZKMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderZKMain80.class,args);
    }
}
```

- 业务类

配置 RestTemplate Bean

com.easylee.springcloud.config

```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    @LoadBalanced
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }
}
```

配置 controller

```java
@RestController
public class OrderZKController {
    public static final String INVOKE_URL = "http://cloud-provider-payment";

    @Resource
    private RestTemplate restTemplate;

    @GetMapping(value = "/consumer/payment/zk")
    public String paymentInfo() {
        String result = restTemplate.getForObject(INVOKE_URL+"/payment/zk",String.class);
        return result;
    }
}
```

# consul

> 从网上看，官方禁止 consul 在中国使用，国内很少使用这个，所以暂时不研究，等到真正需要的时候再研究

### 启动 consul

- docker 拉取 consul 镜像

`docker pull consul:1.6.1`

- 创建同步文件夹

`mkdir -p /data/consul`

- 启动 server
  `docker run -d -p 8500:8500 -v /data/consul:/consul/data -e CONSUL_BIND_INTERFACE='eth0' --name=consul1 consul agent -server -bootstrap -ui -client='0.0.0.0'`
  - `agent`: 表示启动 agent 进程
  - `server`: 表示 consul 为 server 模式
  - `client`: 表示 consul 为 client 模式
  - `bootstrap`: 表示这个节点是 Server-Leader
  - `ui`: 启动 Web UI, 默认端口 8500
  - `node`: 指定节点名称, 集群中节点名称唯一
  - `client`: 绑定客户端接口地址, 0.0.0.0 表示所有地址都可以访问

使用：`10.211.55.15:8500` 就可以访问 web 页面查看注册的微服务了

> 集群操作暂时不学习，后期研究，这里只学习 java 的相关操作，启动即可

# 三者区别

首先再次了解一下 CAP 理论

- C：强一致性，必须保证不同节点之间的数据是一致的
- A：高可用性，必须保证节点提供服务可用
- P：分区容错性，也就是当网络出现故障或者卡顿的时候，不要直接将这个节点挂掉，有一定的容错空间，设置合理的超时时间来重连保证确定是挂掉了，而不是直接就把这个节点去除，**所有集群都保证了这一点**

> 三者不能同时保证，只能保证两个

基于以上三个原则，组成了 CA、CP、AP 三种集群方式的各种系统

- CA - 单点集群，满足一致性，可用性的系统，通常在可扩展性上不太强大，**没有集群是 CA 方式的，所以只能是单机**

- CP - 满足一致性，分区容忍必的系统，通常性能不是特别高，**比方是订单金额的更新之后，就必须保证一致性，请求主节点发现不一致，停止服务等待同步一致**

- AP - 满足可用性，分区容忍性的系统，通常可能对一致性要求低一些，**比方订单的点赞数、标题名，这些不是那么关键的数据，就不用保证一致性，可以返回旧值，保证继续可用，等待后面同步即可**

### 三者区别如下

| 组件名    | 语言 | CAP       | 服务健康检查 | 对外暴露接口 | Spring Cloud 集成 |
| --------- | ---- | --------- | ------------ | ------------ | ----------------- |
| Eureka    | Java | AP 高可用 | 可配支持     | HTTP         | 已集成            |
| Consul    | Go   | CP 一致性 | 支持         | HTTP/DNS     | 已集成            |
| Zookeeper | Java | CP 一致性 | 支持         | 客户端       | 已集成            |

