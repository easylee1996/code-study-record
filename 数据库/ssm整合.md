---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# SSM整合

当项目中需要多个框架的时候，以往各自为战，各自配置太过于麻烦，所以需要将`Spring`、`SpringMVC`、`MyBatis`三个最主流的框架整合搭配。

由Spring框架来对所有框架的对象来创建和管理，由它进行统筹安排，MyBatis完成和数据库交互的工作，SpringMVC来对web页面层进行渲染。

请注意：本项目都是使用xml配置文件的形式来配置，另外还可以使用注解的形式配置。

# 创建项目

使用maven创建最基本的maven项目即可，不需要导入任何依赖

![image-20220512235349720](03%20code-study-record/数据库/assets/ssm整合/image-20220512235349720.png)

完成之后我们需要将这个项目改造成一个web项目，点击file->project structure->mudule添加一个web配置

![image-20220512235003664](03%20code-study-record/数据库/assets/ssm整合/image-20220512235003664.png)

然后修改右边的`web.xml`配置文件目录(这里其实都可以，只是这个慕课网的项目老师习惯这么安排目录)和**web资源目录**

![image-20220512235206082](03%20code-study-record/数据库/assets/ssm整合/image-20220512235206082.png)

修改为：/Users/easylee/Documents/pj/javapj/imooc-reader/src/main/webapp/WEB-INF/web.xml

![image-20220512235228169](03%20code-study-record/数据库/assets/ssm整合/image-20220512235228169.png)

修改为：/Users/easylee/Documents/pj/javapj/imooc-reader/src/main/webapp，下面的/不需要修改，就是默认webapp这里开始

然后添加创建`Artifact`，Artifact是maven中的一个概念，表示某个module要如何打包，比如创建了一个web项目，那么就是配置Artifact就是配置这个web项目以什么方式打包，例如`war exploded`(war和jar包类似，是web jar包的缩写，exploded表示热更新)、`war`、jar、ear等等这种打包形式，一个module必须要有Artifacts才可以部署到应用服务器中。

这里使用默认的打包配置即可，默认已经配置好：

![image-20220513000241653](03%20code-study-record/数据库/assets/ssm整合/image-20220513000241653.png)

接着配置tomcat启动一下即可

# Spring和SpringMVC环境配置

### 1.在maven中导入相关依赖

```xml
<!--springmvc-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.2.6.RELEASE</version>
</dependency>
```

导入`spring-webmvc`依赖之后就会自动导入spring的其它核心依赖，所以不需要再手动导入spring相关依赖，spring-webmvc是springmvc的核心依赖

```xml
<dependency>
    <groupId>org.freemarker</groupId>
    <artifactId>freemarker</artifactId>
    <version>2.3.23</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
    <version>5.2.6.RELEASE</version>
</dependency>
```

导入`freemarker`模板引擎依赖，下面是spring支持包，必须导入支持包才可以支持模板引擎等插件的使用，这个支持包还支持一些其它的插件，后期可以研究一下，注意一定要导入`2.3.23`版本，其它28,30版本都试过都会报错

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
    <version>2.11.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
    <version>2.11.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.11.0</version>
</dependency>
```

导入`jackson` json数据解析支持包，这个json库其实真正意义来说在全球比阿里的`fastjson`用的人多得多，只是国内喜欢使用fastjson，但是jackson无疑是更好的json解析库，`jackson-annotations`依赖则是jackson的注解支持依赖，`jackson-databind`则是jackson数据绑定的依赖。

注意：默认情况下，导入依赖后，并不会自动导入tomcat的输出目录，需要手动导入到tomcat输出中

![image-20220513155940405](03%20code-study-record/数据库/assets/ssm整合/image-20220513155940405.png)

### 2.配置DispatcherServlet，这是SpringMVC的核心组件，用于请求的获取和转发

`DispatcherServlet`是前置控制器(前端控制器)，配置在web.xml文件中的。拦截匹配的请求，Servlet拦截匹配规则要自己定义，把拦截下来的请求，依据相应的规则分发到目标Controller来处理，是配置spring MVC的第一步，DispatcherServlet是前端控制器设计模式的实现，提供Spring Web MVC的集中访问点，而且负责职责的分派，而且与Spring IoC容器无缝集成，从而可以获得Spring的所有好处。

首先打开`web.xml` webapp项目配置文件，同时在resources下创建`applicationContext.xml`文件

```xml
<servlet>
  <!--创建DispatcherServlet变量-->
  <servlet-name>springmvc</servlet-name>
  <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  <!--创建DispatcherServlet配置文件所在位置-->
  <init-param>
    <param-name>contextConfigLocation</param-name>
    <!--classpath表示src/main路径，下面的java和resources都可以读取到-->
    <!--classpath*表示读取下面的多个配置文件，applicationContext*表示applicationContext开头的文件-->
    <param-value>classpath:applicationContext*.xml</param-value>
  </init-param>
  <!--启动时就加载配置文件-->
  <load-on-startup>0</load-on-startup>
</servlet>
<servlet-mapping>
  <!--拦截路径映射/，表示所有路径都拦截-->
  <servlet-name>springmvc</servlet-name>
  <url-pattern>/</url-pattern>
</servlet-mapping>
```

`applicationContext.xml`文件基本结构

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:task="http://www.springframework.org/schema/task"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="
            http://www.springframework.org/schema/beans
            http://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context
            http://www.springframework.org/schema/context/spring-context.xsd
            http://www.springframework.org/schema/task
            http://www.springframework.org/schema/task/spring-task.xsd
            http://www.springframework.org/schema/mvc
            http://www.springframework.org/schema/mvc/spring-mvc.xsd
            http://www.springframework.org/schema/tx
            http://www.springframework.org/schema/tx/spring-tx.xsd">
		<!--配置文件写在这-->
</beans>
```

### 3.启用SpringMVC的注解模式，Spring官方也是使用注解模式来开发

在`applicationContext.xml`中配置

```xml
<!--开启SpringMVC注解模式-->
<context:component-scan base-package="com.imooc" />
<mvc:annotation-driven/>
<mvc:default-servlet-handler/>
```

其中`component-scan`是配置开启spring的注解模式，有两个作用：

1. 扫描包内及其子包内的所有“类”（不包含接口），并为添加了@Service、@Component、@Controller、@Repository修饰的类创建对象并存入IOC容器
2. @Service、@Component、@Controller、@Repository修饰的类中含有@Autowired修饰的成员变量，则创建对象时会从IOC容器中取值为该成员变量赋值

就是为添加了@注入标签的bean注入到容器和取出自动注入到成员变量。

`mvc:annotation-driven`则是开启springmvc的注解模式。

`mvc:default-servlet-handler`因为前面设置了所有/都使用`DispatcherServlet`来处理请求，所以需要配置这个选项来使用默认的servlet来处理静态资源。

### 4.配置请求与响应字符集(乱码问题)

`web.xml`文件中配置项目**请求乱码**问题，请求是请求的项目目录，所以配置在web.xml请求这里

```xml
<filter>
  <filter-name>characterFilter</filter-name>
  <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>characterFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

默认只会解决post请求乱码，而get在tomcat配置文件中配置，tomcat8以后默认get就是utf-8编码

而响应是从项目返回给客户端，`DispatcherServlet`的配置文件才是处理响应的文件，所以在`applicationContext.xml`中配置**响应的中文乱码**问题，是设置在`mvc:annotation-driven`驱动中的

```xml
<mvc:annotation-driven>
    <mvc:message-converters>
        <bean class="org.springframework.http.converter.StringHttpMessageConverter">
            <property name="supportedMediaTypes">
                <list>
                    <!--springmvc不使用模板引擎中文乱码情况设置，典型场景客户端请求json返回中文时的编码设置-->
                    <value>text/html;charset=UTF-8</value>
                </list>
            </property>
        </bean>
    </mvc:message-converters>
</mvc:annotation-driven>
```

### 5.配置FreeMarker模板引擎

`applicationContext.xml`配置，因为是返回响应时的配置

```xml
<!--freemarker基础设置-->
<bean id="freemarkerConfig" class="org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer">
  <property name="templateLoaderPath" value="/WEB-INF/ftl"></property>
  <property name="freemarkerSettings">
    <props>
      <!--这里的utf-8是指freemarker在读取指定的ftl模板文件的时候的编码，避免ftl模板文件内部
                包含中文存在乱码问题，和请求以及响应的字符集-->
      <prop key="default_encoding">UTF-8</prop>
    </props>
  </property>
</bean>
<!--实际使用freemarker-->
<bean id="ViewResolver" class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">
  <!--springmvc加载freemarker产生html片段时返回数据的时候出现中文的情况-->
  <property name="contentType" value="text/html;charset=UTF-8"></property>
  <property name="suffix" value=".ftl"></property>
</bean>
```

### 6.配置Json序列化组件

`applicationContext.xml`配置，因为是返回响应时的配置

```xml
<mvc:annotation-driven>
    <mvc:message-converters>
        <bean class="org.springframework.http.converter.StringHttpMessageConverter">
            <property name="supportedMediaTypes">
                <list>
                    <!--springmvc不使用模板引擎中文乱码情况设置-->
                    <value>text/html;charset=UTF-8</value>
                    <!--JSON(Jackson)序列化输出配置-->
                    <value>application/json;charset=UTF-8</value>
                </list>
            </property>
        </bean>
    </mvc:message-converters>
</mvc:annotation-driven>
```

### 7.测试配置

创建`TestController`文件，分别测试模板引擎和json返回

```java
@Controller
public class TestController {
    // 测试模板引擎
    @GetMapping("/test/t1")
    public ModelAndView test1() {
        return new ModelAndView("/test");	// 这里返回的是ftl模板
    }

    // 测试json
    @GetMapping("/test/t2")
    @ResponseBody   // 设置ResponseBody才可以直接响应文本，json也是文本
    public Map test2() {
        Map result = new HashMap();
        result.put("name", "easylee");
        return result;
    }
}
```

### 总结

一般来讲，请求的相关配置都是在`web.xml`中进行，而响应和后续的相关配置都是在`applicationContext.xml`中进行，这个文件也是`spring`核心配置文件，应用上下文都要使用到

# Spring和MyBatis的整合配置

### 1.依赖mybatis-spring及驱动

首先导入整合相关的依赖，mybatis-spring是mybatis为了更好的使用spring的容器化技术开发的依赖

```xml
<!--mybatis-->
<!--mybatis底层仍然要通过jdbc来操作数据库，进行了封装和扩展-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.2.6.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.4</version>
</dependency>
<!--mybatis和spring整合-->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>2.0.6</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.27</version>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.14</version>
</dependency>
```

### 2.配置数据源与连接池

打开spring核心配置文件`applicationContext.xml`，增加mybatis相关的配置

首先配置阿里巴巴druid数据源

```xml
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
    <!--allowPublicKeyRetrieval为是否允许公钥检索，mysql8之后，第一次连接不允许会出错-->
    <property name="url" value="jdbc:mysql://localhost:3306/reader?useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8&amp;serverTimezone=Asia/Shanghai&amp;allowPublicKeyRetrieval=true"/>
    <property name="username" value="root"/>
    <property name="password" value="root"/>
    <property name="initialSize" value="5"/>    <!--初始化连接数-->
    <property name="maxActive" value="20"/>     <!--最大连接数-->
</bean>
```

### 3.配置SqlSessionFactory

```xml
<!-- SqlSessionFactoryBean用于根据配置信息创建SqlSessionFactory，不在需要我们自己编码new来创建了-->
<bean id="sessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="mapperLocations" value="classpath:mappers/*.xml"/>
    <!--用于指定mybatis配置文件地址-->
    <property name="configLocation" value="classpath:mybatis-config.xml"/>
</bean>
```

### 配置Mapper接口扫描器

```xml
<!--配置Mapper接口扫描器 在扫描之后会自动生成与接口对应的实现类-->
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="com.imooc.reader.mapper"/>
</bean>
```

### 创建mybatis-config.xml配置文件

在`resources`下创建即可

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <!--mybatis实现属性名和字段名的自动驼峰命名转换 字段名一般都是小写而属性都是驼峰-->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
</configuration>
```

# 整合其它组件

### 配置logback日志输出

慕课网老师使用的是logback包，其实log4j2性能更好更流行

导入依赖，spring会自动识别logback：

```xml
<!--日志依赖-->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
</dependency>
```

resources中创建配置文件`logback.xml`:

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<configuration>
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <!--%-5level级别都是5个字的空间对齐 %logger{30} class全名最长30-->
            <pattern>%d{HH:mm:ss} %-5level [%thread] %logger{30} - %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>
    <root level="debug">
        <appender-ref ref="console"/>
    </root>
</configuration>
```

### 声明式事务配置

通过声明或者注解的形式来简化我们程序中的事务管理。

添加依赖`spring-tx`，这个依赖默认在引入`spring-jdbc`时就会自动引入，如果没有再引入。

然后开始配置声明式事务，打开`applicationContext.xml`:

```xml
<!--声明式事务配置 -->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource"/>
</bean>
<!--启用基于注解的事务管理器-->
<tx:annotation-driven transaction-manager="transactionManager"/>
```

使用的时候在方法上添加事务注解即可，注意这里是在源代码中，而不是在测试用例，测试用例是无法使用的，只能去获取容器里面的bean注入到测试用例，然后调用方法：

```java
@Transactional
public void batchImport() {
    for (int i = 0;i < 5; i++) {
        if (i == 3) throw new RuntimeException("未知错误");
        testMapper.insert();
    }
}
```

### 整合JUnit单元测试

首先引入依赖

```xml
<!--单元测试依赖-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>5.2.6.RELEASE</version>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
</dependency>
<!--因为javax.servlet.ServletContext是由tomcat提供的类，当我们只是在idea中通过运行使用测试方法，或者只是idea中运行一些方法的时候，并不需要tomcat介入，只是idea运行环境运行时，但是这个方法中又使用了ServletContext是由tomcat提供的类相关的类，所以需要额外的导入下面的依赖-->
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>3.1.0</version>
  <!--只是本地运行时有效，打包的时候不需要，因为打包到tomcat运行时，自带了这个包-->
  <scope>provided</scope>
</dependency>
```

测试一下Junit是否成功：

`mapper.xml`配置文件头

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
```

首先创建TestMapper接口对应的testMapper.xml mapper配置文件以及配置sql语句，并且对应指定的insert方法

```xml
<mapper namespace="com.imooc.reader.mapper.TestMapper">
    <!--这里的id对应的mapper接口对应的方法名-->
    <insert id="insert">
        insert  into test(content) values("测试内容");
    </insert>
</mapper>
```

然后我们来创建一个service用于测试：

`com.imooc.reader.service`包下

```java
@Service
public class TestService {
  	// 注入testMapper
    @Resource
    private TestMapper testMapper;

  	// 插入5条语句
    public void batchImport() {
        for (int i = 0;i < 5; i++) {
            testMapper.insert();
        }
    }
}
```

在这个文件中command + n选择test...创建测试用例，选中上面的batchImport即可，创建成功后在test目录下打开生成的`TestServiceTest`文件:

```java
// 这个测试用例因为要依托于springIOC容器来运行的，RunWith表示运行JUnit4运行时自动初始化容器
@RunWith(SpringJUnit4ClassRunner.class)
// 设置spring配置文件的位置
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class TestServiceTest {
    @Resource
    private TestService testService;

    @Test
    public void batchImport() {
        testService.batchImport();
        System.out.println("批量导入成功");
    }
}
```

测试用例一定要注意配置运行环境，测试环境是什么都没有的，使用`@RunWith`携带运行环境，`@ContextConfiguration`设置配置文件的位置，然后运行即可

**为什么不直接运行TestService文件，而要生成对应的测试用例文件？**

其实TestService文件已经注入到容器中，它自己也需要使用容器的方式来调用，不可以直接run运行，要运行的话还是要添加@runwith和配置文件这些方法，这显然是不科学的，这是开发的源代码，添加这些额外的可能本身的功能都跑不起来了，只能重新创建一个干净的测试用例文件，单独运行这个方法。