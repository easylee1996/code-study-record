---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
![spring cloud](03%20code-study-record/Java/spring/assets/springcloud/format,f_jpg.jpeg)

# Spring Cloud概述

Spring Cloud 是一系列组件的集合，用于完成分布式、集群、高可用等架构操作。

需要学习的东西就是不同的组件，Spring 官方提供了官方组件，但是很多组件还是第三方的更好用。

## 一些前置知识

**版本选择**

查看 Cloud 和 Boot 之间的依赖关系

- 初略版本号：https://spring.io/projects/spring-cloud#overview
- 详细支持情况：https://start.spring.io/actuator/info

**尚硅谷周阳老师教学环境**

- Cloud：Hoxton.SR1
- Boot： 2.2.2.RELEASE
- Cloud Alibaba：2.1.0.RELEASE
- Java：Java8
- Maven：3.5以上
- Mysql：5.7以上

**学习哪些组件**

2020年以前使用的组件，更多都停更或者废弃了：

- 服务发现和注册：Eureka
- 服务负载与调用：Ribbon
- 服务负载与调用：Feign
- 服务熔断降级：Hystrix
- 服务网关：Zuul
- 服务分布式配置：Config
- 服务开发：Spring Boot
- 服务总线：Bus

2020年更新之后

- 注册中心：Zookeeper、Consul、Nacos
- 服务调用：Ribbon、LoadBalancer
- 服务调用2：OpenFeign
- 服务降级：Resilience4j、Sentinel
- 服务网关：Gateway
- 服务配置：Nacos
- 服务总线：Nacos

下面是 Cloud 和 Boot 的**官方文档**

- Spring Cloud：https://cloud.spring.io/spring-cloud-static/Hoxton.SR1/reference/htmlsingle/
- Spring Boot：https://docs.spring.io/spring-boot/docs/2.2.2.RELEASE/reference/htmlsingle/

# 创建项目

## 首先创建父项目

1. 创建新项目

![image-20220607193948887](image-20220607193948887.png)

![image-20220607193918558](image-20220607193918558.png)

2. 设置字符编码

![image-20220607194045318](image-20220607194045318.png)

3. 激活注解

![image-20220607194132547](image-20220607194132547.png)

4. Java编译版本选择8

![image-20220607194238693](image-20220607194238693.png)

5. File Type过滤

将项目结构中一些不想显示的文件过滤一下

![image-20220607194331849](image-20220607194331849.png)

### 设置父项目通用 pom

首先对Maven的一些配置复习一下

- packaging 属性设置：只要是多项目的项目，在父项目中，必须设置为 pom，默认为 jar，设置为 pom 之后子项目才可以依赖父项目的依赖，同时打包的时候才正确

```xml
<groupId>org.atguigu.springcloud</groupId>
<artifactId>mscloud</artifactId>
<version>1.0-SNAPSHOT</version>
<packaging>pom</packaging>
```

- dependencyManagement：用于管理整个项目的版本号，父项目设置了之后，子项目不需要再输入版本号，除非子类单独设置了，是从子类往父类查找的，注意只是指定，此时并不引入。**使用dependencyManagement之前先去掉dependencyManagement，把依赖导入再加上，要不然一直报错**
- properties：配置 pom 文件的参数，后面可以使用 `${mysql.version}` 这样的格式调用变量

完整 pom 文件配置如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>mscloud</artifactId>
    <version>1.0-SNAPSHOT</version>
    <modules>
        <module>cloud-provider-payment8001</module>
    </modules>
    <packaging>pom</packaging>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.version>4.12</junit.version>
        <log4j.version>1.2.17</log4j.version>
        <lombok.version>1.16.18</lombok.version>
        <mysql.version>5.1.47</mysql.version>
        <druid.version>1.1.16</druid.version>
        <mybatis.spring.boot.version>1.3.0</mybatis.spring.boot.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!--spring boot 2.2.2-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>2.2.2.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--spring cloud Hoxton.SR1-->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Hoxton.SR1</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--spring cloud alibaba 2.1.0.RELEASE-->
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>2.1.0.RELEASE</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql.version}</version>
            </dependency>
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid</artifactId>
                <version>${druid.version}</version>
            </dependency>
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis.spring.boot.version}</version>
            </dependency>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>${junit.version}</version>
            </dependency>
            <dependency>
                <groupId>log4j</groupId>
                <artifactId>log4j</artifactId>
                <version>${log4j.version}</version>
            </dependency>
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
                <optional>true</optional>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <!--Springboot 打包插件，注意版本一定要和上面的 SpringBoot 一致-->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>2.2.2.RELEASE</version>
                <configuration>
                    <fork>true</fork>
                    <addResources>true</addResources>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

## 创建子项目

### 项目 5 步骤

- 建项目
- 改 POM
- 写 YML
- 主启动
- 业务类

### 建立项目

在主项目下建立 cloud-provider-payment8001 Module

### 改 pom 配置

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

    <artifactId>cloud-provider-payment8001</artifactId>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
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
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.1.10</version>
        </dependency>
        <!--mysql-connector-java-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--jdbc-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
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

### 写 YML 配置文件

```yaml
server:
  port: 8001

spring:
  application:
    name: cloud-payment-service
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: org.gjt.mm.mysql.Driver
    url: jdbc:mysql://localhost:3306/db2019?useUnicode=true&characterEncoding=utf-8&useSSL=false
    username: root
    password: root

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.easylee.springcloud.entities
```

### 添加主启动类

com.easylee.springcloud.PaymentMain8001

```java
public class PaymentMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain8001.class,args);
    }
}
```

### 添加业务类

- 建表

```mysql
CREATE TABLE `payment` ( 
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID', 
  `serial` varchar(200) DEFAULT '', 
  PRIMARY KEY (`id`) 
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8
```

- entities 实体类

com.easylee.springcloud.entities

对应上面数据表的实体类

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
// Serializable 用于分布式的序列化传输
public class Payment implements Serializable {
    private Long id;
    private String serial;
}
```

com.easylee.springcloud.entities

Json 封装类，用于给客户端返回信息

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommonResult<T> {
    private Integer code;
    private String message;
    private T data;
    public CommonResult(Integer code,String message) {
        // 如果没有返回数据，只返回code和message
        this(code,message,null);
    }
}
```

- dao

创建接口PaymentDao

com.easylee.springcloud.dao

```java
@Mapper
public interface PaymentDao {
    public int create(Payment payment);

    public Payment getPaymentById(@Param("id") Long id);
}
```

创建对应 mapper 文件

resources/mapper/PaymentMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.easylee.springcloud.dao.PaymentDao">

    <insert id="create" parameterType="Payment" useGeneratedKeys="true" keyProperty="id">
        INSERT INTO payment(serial) values(#{serial});
    </insert>

    <resultMap id="BaseResultMap" type="com.easylee.springcloud.entities.Payment">
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="serial" jdbcType="VARCHAR"/>
    </resultMap>
    <select id="getPaymentById" parameterType="Long" resultMap="BaseResultMap">
        SELECT * FROM payment where id = #{id};
    </select>
</mapper>
```

- Service

com.easylee.springcloud.service

创建 Service 接口

```java
public interface PaymentService
{
    public int create(Payment payment);
    public Payment getPaymentById(@Param("id") Long id);
}
```

创建对应实现类

```java
@Service
public class PaymentServiceImpl implements PaymentService {
    @Resource
    private PaymentDao paymentDao;

    @Override
    public int create(Payment payment) {
        return paymentDao.create(payment);
    }

    @Override
    public Payment getPaymentById(Long id) {
        return paymentDao.getPaymentById(id);
    }
}
```

- Controller

com.easylee.springcloud.controller

创建控制器

```java
@RestController
@Slf4j
public class PaymentController
{
    @Resource
    private PaymentService paymentService;

    @PostMapping(value = "/payment/create")
    public CommonResult create(@RequestBody Payment payment)
    {
        int result = paymentService.create(payment);
        log.info("*****插入操作返回结果:" + result);

        if(result > 0)
        {
            return new CommonResult(200,"插入数据库成功",result);
        }else{
            return new CommonResult(444,"插入数据库失败",null);
        }
    }

    @GetMapping(value = "/payment/get/{id}")
    public CommonResult getPaymentById(@PathVariable("id") Long id)
    {
        Payment payment = paymentService.getPaymentById(id);
        log.info("*****查询结果:{}",payment);
        if (payment != null) {
            return new CommonResult(200,"查询成功",payment);
        }else{
            return new CommonResult(444,"没有对应记录,查询ID: "+id,null);
        }
    }
}
```

## 热部署

自动更新代码

1. 首先导入依赖，在需要的项目中导入

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
  
<!--      optional 表示依赖是否向下传递 true表示不向下传递  默认值是false向下传递      -->
    <optional>true</optional>
</dependency>
```

2. 添加插件支持，一般添加到父项目

```xml
<build>
    <plugins>
        <!--Springboot 打包插件，注意版本一定要和上面的 SpringBoot 一致-->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>2.2.2.RELEASE</version>
            <configuration>
                <fork>true</fork>
                <addResources>true</addResources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

3. idea 开启热更新支持

选中 ADBC 四个选项

![image-20220617102344844](image-20220617102344844.png)

另外还需要设置这两个

使用 `command + option + shift + /` 打开，设置下面两个选项

![image-20220617103026554](image-20220617103026554.png)

`compiler.automake.allow.when.app.running` 新版 idea 直接配置这里即可，上面的两个都不用配置

![image-20220617102804500](image-20220617102804500.png)

然后修改代码之后等待几秒就会自动重新编译，如果想立即重新 build，`command + F9`

## 添加新子项目

添加另外一个子项目用于形成微服务

### 项目 5 步骤

- 建项目
- 改 pom
- 写 YML
- 主启动
- 业务类

### 建立项目

cloud-consumer-order80

### 改 POM

同样包含 devtools 热部署依赖

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

    <artifactId>cloud-consumer-order80</artifactId>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
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
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
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

### 写 YML 配置文件

这个项目仅仅是前台处理的客户端项目，用于调用其它后端接口，所以不需要其它的配置，只需要控制器进行调用即可

```yaml
server:
  port: 80
```

### 主启动

```java
@SpringBootApplication
public class MainApp80 {
    public static void main(String[] args) {
        SpringApplication.run(MainApp80.class,args);
    }
}
```

### 业务类

- ApplicationContextConfig.java

com.easylee.springcloud.config

配置类，用于将请求其它服务的 RestTemplate 对象注册为 Bean，因为默认是没有注册的，不太方便

```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
```

- entities

同前面的子项目

- Controller

```java
@RestController
public class OrderController {
  // 定义请求其它微服务的地址
    public static final String PAYMENT_SRV_URL = "http://localhost:8001";

    @Autowired
    private RestTemplate restTemplate;

    @GetMapping("/consumer/payment/create")
    public CommonResult create(Payment payment) {
        // 参数：请求连接，传递的参数，返回的实体
        return restTemplate.postForObject(PAYMENT_SRV_URL + "/payment/create",payment,CommonResult.class);
    }

        @GetMapping("/consumes/get/{id}")
    public CommonResult getPayment(@PathVariable("id") Long id) {
        return restTemplate.getForObject(PAYMENT_SRV_URL + "/payment/get/" + id,CommonResult.class,id);
    }
}
```

这样第二个子项目就创建完成了

## 项目重构

在两个子项目中都使用到了同样的 entities 实体类，这样不方便，应该封装成一个单独的 jar 包，其它微服务导入之后直接引用即可

### 建立项目

cloud-api-commons

### 改 POM

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    <!--一个让java代码函数式编程，简化代码的依赖-->
    <dependency>
        <groupId>cn.hutool</groupId>
        <artifactId>hutool-all</artifactId>
        <version>5.1.0</version>
    </dependency>
</dependencies>
```

### entities

将之前需要封装的实体类全部移到这里面，要注意包名最好一致，免得和其它的包冲突了，用包名区分一下更好

com.easylee.springcloud.entities

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
// Serializable 用于分布式的序列化传输
public class Payment implements Serializable {
    private Long id;
    private String serial;
}
```

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommonResult<T> {
    private Integer code;
    private String message;
    private T data;
    public CommonResult(Integer code,String message) {
        // 如果没有返回数据，只返回code和message
        this(code,message,null);
    }
}
```

### 封装成 jar 包

执行 `mvn install`

### 导入 jar 包

另外两个微服务项目，分别将这个 jar 包导入

```xml
<!--导入公共 entities-->
<dependency>
    <groupId>org.example</groupId>
    <artifactId>cloud-api-commons</artifactId>
    <version>${project.version}</version>
</dependency>
```

### 将原本两个微服务中的 entities 删除
