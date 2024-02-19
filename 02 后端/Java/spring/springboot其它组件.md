---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# 邮件发送：Mail

我们在注册很多的网站时，都会遇到邮件或是手机号验证，也就是通过你的邮箱或是手机短信去接受网站发给你的注册验证信息，填写验证码之后，就可以完成注册了，同时，网站也会绑定你的手机号或是邮箱。

那么，像这样的功能，我们如何实现呢？SpringBoot已经给我们提供了封装好的邮件模块使用：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
```

## 邮件发送

在学习邮件发送之前，我们需要先了解一下什么是电子邮件。

电子邮件也是一种通信方式，是互联网应用最广的服务。通过网络的电子邮件系统，用户可以以非常低廉的价格（不管发送到哪里，都只需负担网费，实际上就是把信息发送到对方服务器而已）、非常快速的方式，与世界上任何一个地方的电子邮箱用户联系。

虽说方便倒是方便，虽然是曾经的霸主，不过现在这个时代，QQ微信横行，手机短信和电子邮箱貌似就只剩收验证码这一个功能了。

要在Internet上提供电子邮件功能，必须有专门的电子邮件服务器。例如现在Internet很多提供邮件服务的厂商：新浪、搜狐、163、QQ邮箱等，他们都有自己的邮件服务器。这些服务器类似于现实生活中的邮局，它主要负责接收用户投递过来的邮件，并把邮件投递到邮件接收者的电子邮箱中。

所有的用户都可以在电子邮件服务器上申请一个账号用于邮件发送和接收，那么邮件是以什么样的格式发送的呢？实际上和Http一样，邮件发送也有自己的协议，也就是约定邮件数据长啥样以及如何通信。

![image-20220519182723460](image-20220519182723460.png)

比较常用的协议有两种：

1. SMTP协议（主要用于发送邮件 Simple Mail Transfer Protocol）
2. POP3协议（主要用于接收邮件 Post Office Protocol 3）

整个发送/接收流程大致如下：

![image-20220519182729508](image-20220519182729508.png)

实际上每个邮箱服务器都有一个smtp发送服务器和pop3接收服务器，比如要从QQ邮箱发送邮件到163邮箱，那么我们只需要通过QQ邮箱客户端告知QQ邮箱的smtp服务器我们需要发送邮件，以及邮件的相关信息，然后QQ邮箱的smtp服务器就会帮助我们发送到163邮箱的pop3服务器上，163邮箱会通过163邮箱客户端告知对应用户收到一封新邮件。

SpringBoot已经帮助我们将最基本的底层通信全部实现了，我们只需要关心smtp服务器的地址以及我们要发送的邮件长啥样即可。

这里以163邮箱 https://mail.163.com 为例，我们需要在配置文件中告诉SpringBootMail我们的smtp服务器的地址以及你的邮箱账号和密码，首先我们要去设置中开启smtp/pop3服务才可以，开启后会得到一个随机生成的密钥，这个就是我们的密码。

```yaml
spring:
  mail:
  	# 163邮箱的地址为smtp.163.com，直接填写即可
    host: smtp.163.com
    # 你申请的163邮箱
    username: xxxx@163.com
    # 注意密码是在开启smtp/pop3时自动生成的，记得保存一下，不然就找不到了
    password: xxxxxxxxxxxx
```

配置完成后，接着我们来进行一下测试：

```java
@SpringBootTest
class SpringBootTestApplicationTests {

  	//JavaMailSender是专门用于发送邮件的对象，自动配置类已经提供了Bean
    @Autowired
    JavaMailSender sender;

    @Test
    void contextLoads() {
      	//SimpleMailMessage是一个比较简易的邮件封装，支持设置一些比较简单内容
        SimpleMailMessage message = new SimpleMailMessage();
      	//设置邮件标题
        message.setSubject("【电子科技大学教务处】关于近期学校对您的处分决定");
      	//设置邮件内容
        message.setText("XXX同学您好，经监控和教务巡查发现，您近期存在旷课、迟到、早退、上课刷抖音行为，" +
                "现已通知相关辅导员，请手写5000字书面检讨，并在2022年4月1日17点前交到辅导员办公室。");
      	//设置邮件发送给谁，可以多个，这里就发给你的QQ邮箱
        message.setTo("你的QQ号@qq.com");
      	//邮件发送者，这里要与配置文件中的保持一致
        message.setFrom("xxx@163.com");
      	//OK，万事俱备只欠发送
        sender.send(message);
    }

}
```

如果需要添加附件等更多功能，可以使用MimeMessageHelper来帮助我们完成：

```java
@Test
void contextLoads() throws MessagingException {
  	//创建一个MimeMessage
    MimeMessage message = sender.createMimeMessage();
  	//使用MimeMessageHelper来帮我们修改MimeMessage中的信息
    MimeMessageHelper helper = new MimeMessageHelper(message, true);
    helper.setSubject("Test");
    helper.setText("lbwnb");
    helper.setTo("你的QQ号@qq.com");
    helper.setFrom("xxx@163.com");
  	//发送修改好的MimeMessage
    sender.send(message);
}
```

## 邮件注册

既然我们已经了解了邮件发送，那么我们接着来看如何在我们的项目中实现邮件验证。

首先明确验证流程：请求验证码 -> 生成验证码（临时有效，注意设定过期时间） -> 用户输入验证码并填写注册信息 -> 验证通过注册成功！



# 前后端分离跨域处理

我们的项目已经处于前后端分离状态了，那么前后端分离状态和我们之前的状态有什么区别的呢？

* **不分离：**前端页面看到的都是由后端控制，由后端渲染页面或重定向，后端需要控制前端的展示，前端与后端的耦合度很高。比如我们之前都是使用后端来执行重定向操作或是使用Thymeleaf来填充数据，而最终返回的是整个渲染好的页。

![image-20220519182936017](image-20220519182936017.png)

* **分离：**后端仅返回前端所需的数据，不再渲染HTML页面，不再控制前端的效果。至于前端用户看到什么效果，从后端请求的数据如何加载到前端中，都由前端通过JS等进行动态数据填充和渲染。这样后端只返回JSON数据，前端处理JSON数据并展示，这样前后端的职责就非常明确了。

实现前后端分离有两种方案，一种是直接放入SpringBoot的资源文件夹下，但是这样实际上还是在依靠SpringBoot内嵌的Tomcat服务器进行页面和静态资源的发送，我们现在就是这种方案。

另一种方案就是直接将所有的页面和静态资源单独放到代理服务器上（如Nginx），这样我们后端服务器就不必再处理静态资源和页面了，专心返回数据即可，而前端页面就需要访问另一个服务器来获取，虽然逻辑很明确，但是这样会出现跨域问题，实际上就是我们之前所说的跨站请求伪造，为了防止这种不安全的行为发生，所以对异步请求会进行一定的限制。

这里，我们将前端页面和后端页面直接分离进行测试，在登陆时得到如下错误：

```
Access to XMLHttpRequest at 'http://localhost:8080/api/auth/login' from origin 'http://localhost:63342' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

可以很清楚地看到，在Ajax发送异步请求时，我们的请求被阻止，原因是在响应头中没有包含`Access-Control-Allow-Origin`，也就表示，如果服务端允许跨域请求，那么会在响应头中添加一个`Access-Control-Allow-Origin`字段，如果不允许跨域，就像现在这样。那么，什么才算是跨域呢：

1. 请求协议`如http、https`不同
2. 请求的地址/域名不同
3. 端口不同

因为我们现在相当于前端页面访问的是静态资源服务器，而后端数据是由我们的SpringBoot项目提供，它们是两个不同的服务器，所以在跨服务器请求资源时，会被判断为存在安全风险。

但是现在，由于我们前后端是分离状态，我们希望的是能够实现跨域请求，这时我们就需要添加一个过滤器来处理跨域问题，直接在SecurityConfiguration.java中添加：

```java
@Bean
public CorsFilter corsFilter() {
    //创建CorsConfiguration对象后添加配置
    CorsConfiguration config = new CorsConfiguration();
    //设置放行哪些原始域，这里直接设置为所有
    config.addAllowedOriginPattern("*");
  	//你可以单独设置放行哪些原始域 config.addAllowedOrigin("http://localhost:2222");
    //放行哪些原始请求头部信息
    config.addAllowedHeader("*");
    //放行哪些请求方式，*代表所有
    config.addAllowedMethod("*");
    //是否允许发送Cookie，必须要开启，因为我们的JSESSIONID需要在Cookie中携带
    config.setAllowCredentials(true);
    //映射路径
    UrlBasedCorsConfigurationSource corsConfigurationSource = new UrlBasedCorsConfigurationSource();
    corsConfigurationSource.registerCorsConfiguration("/**", config);
    //返回CorsFilter
    return new CorsFilter(corsConfigurationSource);
}
```

这样，我们的SpringBoot项目就支持跨域访问了，接着我们再来尝试进行登陆，可以发现已经能够正常访问了，并且响应头中包含了以下信息：

```
Vary: Access-Control-Request-Method
Vary: Access-Control-Request-Headers
Access-Control-Allow-Origin: http://localhost:63342
Access-Control-Expose-Headers: *
Access-Control-Allow-Credentials: true
```

可以看到我们当前访问的原始域已经被放行了。

但是还有一个问题，我们的Ajax请求中没有携带Cookie信息（这个按理说属于前端知识了）这里我们稍微改一下，不然我们的请求无法确认身份：

```js
function get(url, success){
    $.ajax({
        type: "get",
        url: url,
        async: true,
        dataType: 'json',
        xhrFields: {
            withCredentials: true
        },
        success: success
    });
}

function post(url, data, success){
    $.ajax({
        type: "post",
        url: url,
        async: true,
        data: data,
        dataType: 'json',
        xhrFields: {
            withCredentials: true
        },
        success: success
    });
}
```

添加两个封装好的方法，并且将`withCredentials`开启，这样在发送异步请求时，就会携带Cookie信息了。

# 接口管理：Swagger

在前后端分离项目中，前端人员需要知道我们后端会提供什么数据，根据后端提供的数据来进行前端页面渲染（在之前我们也演示过）这个时候，我们就需要编写一个API文档，以便前端人员随时查阅。

但是这样的一个文档，我们也不可能单独写一个项目去进行维护，并且随着我们的后端项目不断更新，文档也需要跟随更新，这显然是很麻烦的一件事情，那么有没有一种比较好的解决方案呢？

当然有，那就是丝袜哥：Swagger

## 走进Swagger

Swagger的主要功能如下：

- 支持 API 自动生成同步的在线文档：使用 Swagger 后可以直接通过代码生成文档，不再需要自己手动编写接口文档了，对程序员来说非常方便，可以节约写文档的时间去学习新技术。
- 提供 Web 页面在线测试 API：光有文档还不够，Swagger 生成的文档还支持在线测试。参数和格式都定好了，直接在界面上输入参数对应的值即可在线测试接口。

结合Spring框架（Spring-fox），Swagger可以很轻松地利用注解以及扫描机制，来快速生成在线文档，以实现当我们项目启动之后，前端开发人员就可以打开Swagger提供的前端页面，查看和测试接口。依赖如下：

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>
```

SpringBoot 2.6以上版本修改了路径匹配规则，但是Swagger3还不支持，这里换回之前的，不然启动直接报错：

```yaml
spring:
	mvc:
		pathmatch:
      matching-strategy: ant_path_matcher
```

项目启动后，我们可以直接打开：http://localhost:8080/swagger-ui/index.html，这个页面（要是觉得丑，UI是可以换的，支持第三方）会显示所有的API文档，包括接口的路径、支持的方法、接口的描述等，并且我们可以直接对API接口进行测试，非常方便。

我们可以创建一个配置类去配置页面的相关信息：

```java
@Configuration
public class SwaggerConfiguration {

    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.OAS_30).apiInfo(
                new ApiInfoBuilder()
                        .contact(new Contact("你的名字", "https://www.bilibili.com", "javastudy111*@163.com"))
                        .title("图书管理系统 - 在线API接口文档")
                        .build()
        );
    }
}
```

## 接口信息配置

虽然Swagger的UI界面已经可以很好地展示后端提供的接口信息了，但是非常的混乱，我们来看看如何配置接口的一些描述信息。

首先我们的页面中完全不需要显示`ErrorController`相关的API，所以我们配置一下选择哪些Controller才会生成API信息：

```java
@Bean
public Docket docket() {
    ApiInfo info = new ApiInfoBuilder()
            .contact(new Contact("你的名字", "https://www.bilibili.com", "javastudy111@163.com"))
            .title("图书管理系统 - 在线API接口文档")
            .description("这是一个图书管理系统的后端API文档，欢迎前端人员查阅！")
            .build();
    return new Docket(DocumentationType.OAS_30)
            .apiInfo(info)
            .select()       
            //对项目中的所有API接口进行选择
             .apis(RequestHandlerSelectors.basePackage("com.example.controller"))
            .build();
}
```

接着我们来看看如何为一个Controller编写API描述信息：

```java
@Api(tags = "账户验证接口", description = "包括用户登录、注册、验证码请求等操作。")
@RestController
@RequestMapping("/api/auth")
public class AuthApiController {
```

我们可以直接在类名称上面添加`@Api`注解，并填写相关信息，来为当前的Controller设置描述信息。

接着我们可以为所有的请求映射配置描述信息：

```java
@ApiResponses({
        @ApiResponse(code = 200, message = "邮件发送成功"),  
        @ApiResponse(code = 500, message = "邮件发送失败")   //不同返回状态码描述
})
@ApiOperation("请求邮件验证码")   //接口描述
@GetMapping("/verify-code")
public RestBean<Void> verifyCode(@ApiParam("邮箱地址")   //请求参数的描述
                                 @RequestParam("email") String email){
```

```java
@ApiIgnore     //忽略此请求映射
@PostMapping("/login-success")
public RestBean<Void> loginSuccess(){
    return new RestBean<>(200, "登陆成功");
}
```

我们也可以为实体类配置相关的描述信息：

```java
@Data
@ApiModel(description = "响应实体封装类")
@AllArgsConstructor
public class RestBean<T> {

    @ApiModelProperty("状态码")
    int code;
    @ApiModelProperty("状态码描述")
    String reason;
    @ApiModelProperty("数据实体")
    T data;

    public RestBean(int code, String reason) {
        this.code = code;
        this.reason = reason;
    }
}
```

这样，我们就可以在文档中查看实体类简介以及各个属性的介绍了。

最后我们再配置一下多环境。

创建两套环境：

```xml
<profiles>
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <environment>dev</environment>
        </properties>
    </profile>
    <profile>
        <id>prod</id>
        <activation>
            <activeByDefault>false</activeByDefault>
        </activation>
        <properties>
            <environment>prod</environment>
        </properties>
    </profile>
</profiles>
```

然后在maven中添加这两个环境：

```xml
<resources>
    <resource>
        <directory>src/main/resources</directory>
        <excludes>
            <exclude>application*.yaml</exclude>
        </excludes>
    </resource>
    <resource>
        <directory>src/main/resources</directory>
        <filtering>true</filtering>
        <includes>
            <include>application.yaml</include>
            <include>application-${environment}.yaml</include>
        </includes>
    </resource>
</resources>
```

接着我们配置一下不同环境的配置文件：

```yaml
  jpa:
    show-sql: false
    hibernate:
      ddl-auto: update
springfox:
  documentation:
    enabled: false
```

在生产环境下，我们选择不开启Swagger文档以及JPA的数据库操作日志，这样我们就可以根据情况选择两套环境了。