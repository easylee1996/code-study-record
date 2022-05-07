# 常用类库

## JUNIT单元测试

写函数对需要测试的内容进行测试，直接在main中进行测试无法达到这种效果，main只能随时测试，随时查看结果，而且无法进行代码判断是否通过



### 依赖

新版idea默认就支持

`````xml
<!--单元测试--> 
<dependency>
<groupId>junit</groupId>
<artifactId>junit</artifactId>
<version>4.13.2</version>
</dependency>
`````



### 简单使用

 @Test注解只有在方法上有效，只要加了这个注解的方法，就可以直接运行！

```java
@Test
public void test() {
  System.out.println("Hello");
}
```



## lombok

我们发现，在以往编写项目时，尤其是在类进行类内部成员字段封装时，需要编写大量的get/set方法，这不仅使得我们类定义中充满了get和set方法，同时如果字段名称发生改变，又要挨个进行修改，甚至当字段变得很多时，构造方法的编写会非常麻烦！

通过使用Lombok（小辣椒）就可以解决这样的问题！

![img](assets/java工具、常用类库/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F14004711543%2F1000&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

### idea安装

安装插件即可，idea默认已经安装

### 导入jar依赖

```xml
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
  <scope>compile</scope>
</dependency>
```

### 原理分析

* 首先我们需要导入Lombok的jar依赖，和jdbc依赖是一样的，放在项目目录下直接导入就行了。可以在这里进行下载：https://projectlombok.org/download
* 然后我们要安装一下Lombok插件，由于IDEA默认都安装了Lombok的插件，因此直接导入依赖后就可以使用了。
* 重启IDEA

Lombok是一种插件化注解API，是通过添加注解来实现的，然后在javac进行编译的时候，进行处理。

Java的编译过程可以分成三个阶段：

![img](assets/java工具、常用类库/format,png-20220505183119595.png)

1. 所有源文件会被解析成语法树。
2. 调用注解处理器。如果注解处理器产生了新的源文件，新文件也要进行编译。
3. 最后，语法树会被分析并转化成类文件。

实际上在上述的第二阶段，会执行*[lombok.core.AnnotationProcessor](https://github.com/rzwitserloot/lombok/blob/master/src/core/lombok/core/AnnotationProcessor.java)*，它所做的工作就是我们上面所说的，修改语法树。

### 使用Lombok

我们通过实战来演示一下Lombok的实用注解：

* 我们通过添加`@Getter`和`@Setter`来为当前类的所有字段生成get/set方法，他们可以添加到类或是字段上，注意静态字段不会生成，final字段无法生成set方法。
  * 我们还可以使用@Accessors来控制生成Getter和Setter的样式。 
* 我们通过添加`@ToString`来为当前类生成预设的toString方法。
* 我们可以通过添加`@EqualsAndHashCode`来快速生成比较和哈希值方法。
* 我们可以通过添加`@AllArgsConstructor`和`@NoArgsConstructor`来快速生成全参构造和无参构造。
* 我们可以添加`@RequiredArgsConstructor`来快速生成参数只包含`final`或被标记为`@NonNull`的成员字段。
* 使用`@Data`能代表`@Setter`、`@Getter`、`@RequiredArgsConstructor`、`@ToString`、`@EqualsAndHashCode`全部注解。
  * 一旦使用`@Data`就不建议此类有继承关系，因为`equal`方法可能不符合预期结果（尤其是仅比较子类属性）。
* 使用`@Value`与`@Data`类似，但是并不会生成setter并且成员属性都是final的。
* 使用`@SneakyThrows`来自动生成try-catch代码块。
* 使用`@Cleanup`作用与局部变量，在最后自动调用其`close()`方法（可以自由更换）
* 使用`@Builder`来快速生成建造者模式。
  * 通过使用`@Builder.Default`来指定默认值。
  * 通过使用`@Builder.ObtainVia`来指定默认值的获取方式。

# 常用工具

## tomcat web服务器

### 安装tomcat

tomcat官网：http://tomcat.apache.org/

![image-20220425214348889](assets/java工具、常用类库/image-20220425214348889.png)



### 启动tomcat服务器

下载之后直接解压即可

![image-20220425214425956](assets/java工具、常用类库/image-20220425214425956.png)



bin目录下启动tomcat

![image-20220425214451778](assets/java工具、常用类库/image-20220425214451778.png)

如果显示找不到startup.sh

那么执行以下命令启动

其实执行startup.bat或者startup.sh也是执行下面这个

```shell
sh catalina.sh run 
```



访问测试：http://localhost:8080/



### tomcat配置

conf目录下，server.xml是服务器核心配置文件

可以配置启动的端口号

- tomcat的默认端口号为：8080 

- mysql：3306 

- http：80

- https：443

```xml
<Connector port="8081" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />
```



可以配置主机的名称

默认的主机名为：localhost->127.0.0.1 

默认网站应用存放的位置为：webapps，指的是所有网站都必须放在这个里面才能找得到，而不是直接在webapps放具体项目文件，里面还可以新建项目目录

```xml
<Host name="www.qinjiang.com" appBase="webapps" unpackWARs="true" autoDeploy="true">
```



### 高难度面试题

请你谈谈网站是如何进行访问的！

1. 输入一个域名,回车
2. 检查本机的 C:\Windows\System32\drivers\etc\hosts配置文件下有没有这个域名映射
1. 有：直接返回对应的ip地址，这个地址中，有我们需要访问的web程序，可以直接访问
1. 没有：去DNS服务器找，找到的话就返回，找不到就返回找不到；

```xml
127.0.0.1 www.qinjiang.com
```



### tomcat网站项目基本结构

![image-20220425220200742](assets/java工具、常用类库/image-20220425220200742.png)



### tomcat idea配置

![image-20220426204012405](assets/java工具、常用类库/image-20220426204012405.png)

注意上面的两个热更新需要配置deployment之后才会出现	![image-20220426204119333](assets/java工具、常用类库/image-20220426204119333.png)



### 热更新配置

级别update classes and resources最低，restart最高

on update action：代码改变时

On frame deactivation：窗口失去焦点时

- update classes and resources：改了html,css,js
- redeploy：改了后台Java代码
- restart：改了服务器配置

## mac环境变量配置

只是配置命令行的环境变量，也就是在命令行中能识别环境变量

${PATH}后面的:是分隔两个path的,前面的变量表示加上前面的path



`zsh命令行`

```shell
// 打开配置文件
open ~/.zshrc

// 加入mysql命令
export PATH=${PATH}:/usr/local/mysql/bin

// 更新配置文件
source ~/.zshrc
```



`默认控制台配置`

```shell
// 打开配置文件
open ~/.bash_profile

// 加入mysql命令
export PATH=${PATH}:/usr/local/mysql/bin

// 更新配置文件
source ~/.bash_profile
```



## maven构建工具

### 为什么要学习这个技术

1. 在Javaweb开发中，需要使用大量的jar包，我们手动去导入
2. 如何能够让一个东西自动帮我导入和配置这个jar包。



### Maven的核心思想

约定大于配置

- 有约定，不要去违反
- Maven会规定好你该如何去编写我们的Java代码，必须要按照这个规范来



### 下载地址

官网：https://maven.apache.org

下载完成后配置环境变量



### 配置阿里云镜像

在conf/setting.xml中，mirrors标签替换阿里云

```xml
<mirror> 
  <id>nexus-aliyun</id>
  <mirrorOf>*,!jeecg,!jeecg-snapshots</mirrorOf>
  <name>Nexus aliyun</name>
  <url>http://maven.aliyun.com/nexus/content/groups/public</url>
</mirror>
```



### 本地仓库

lib下载在本地maven中的位置

还是配置conf/setting.xml

```xml
<localRepository>/Users/easylee/Documents/pj/javatools/apache-maven-3.8.5/lib</localRepository>
```



### idea配置maven

`默认配置`

注意是在项目启动页面才是全局所有项目设置，如果在一个项目中设置只针对这一个项目

![image-20220426204727304](assets/java工具、常用类库/image-20220426204727304.png)

`新项目配置`

新建项目之后，项目上右键添加支持

![image-20220426193844506](assets/java工具、常用类库/image-20220426193844506.png)



### pom文件

pom是maven的核心配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- 项目名称 -->
    <groupId>groupId</groupId>
    <artifactId>webapp</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!--
    项目打包方式
    jar：java应用
    war：web应用
    -->
    <packaging>war</packaging>

    <!-- 项目配置 -->
    <properties>
        <!-- 项目默认构建编码 -->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <!-- 项目默认编译编码版本 -->
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
    </properties>

    <!-- 项目依赖 -->
    <dependencies>
        <!-- 引入单元测试 -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
        </dependency>
    </dependencies>

    <!-- 编译配置 -->
    <build>
        <resources>
            <!--配置将resources中的资源文件可以导出-->
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
              <!--注意这里的filtering并不是开启关闭上面的规则，而是上面规则中的directory中是否可以读取变量，也就是说，无论true还是false，上面的资源加载都会生效-->
                <filtering>true</filtering>
            </resource>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
        </resources>
    </build>
</project>
```



### maven仓库

[Maven Repository: Search/Browse/Explore (mvnrepository.com)](https://mvnrepository.com/)



### 注意事项

- maven的pom配置文件每次修改之后，一定要更新一下，要不然不生效



## git工具

### github配置

连接github有https和ssh两种连接方式

#### https连接

从GitHub更新验证机制后，需要生成token来登陆，所以首先需要在setting中生成Personal access tokens，一次性，然后在登陆的时候密码输入这个tokens即可

```
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
```

#### 设置git https代理

```shell
// 配置之后再git config文件里面可以看到这个配置
git config --global http.proxy http://127.0.0.1:4780
git config --global https.proxy http://127.0.0.1:4780

// 扩展信息-取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

其中4780是代理服务器的代理端口，不同代理不一样

#### ssh

首先需要生成ssh key

```shell
ssh-keygen -t rsa -C "xxx@xxx.com"
//"xxx@xxx.com"可以是自己的邮箱账号，这个其实就是给公钥取个名字的意思
```

生成之后在~/.ssh/id_rsa.pub中有key公钥信息，保存到github的setting的ssh配置中

```shell
vim ~/.ssh/id_rsa.pub
```

注意：ssh要设置代理比较麻烦，后面再研究

注意如果使用ssh，sourcetree软件的话，第一次要先git clone一下项目，认证通过再使用sourcetree，因为sourcetree不会弹出这个认证
