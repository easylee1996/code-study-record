---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# 计算机网络基础

在计算机网络（谢希仁 第七版 第264页）中，是这样描述万维网的：

>  万维网（World Wide Web）并非是某种特殊的计算机网络，万维网是一个大规模的联机式信息储藏所，英文简称`Web`，万维网用**<u>链接</u>**的方法，能够非常方便地从互联网上的一个站点访问另一个站点，从而主动地按需求获取丰富的信息。

这句话说的非常官方，但是也蕴藏着许多的信息，首先它指明，我们的互联网上存在许许多多的服务器，而我们通过访问这些服务器就能快速获取服务器为我们提供的信息（比如打开百度就能展示搜索、打开小破站能刷视频、打开微博能查看实时热点）而这些服务器就是由不同的公司在运营。

其次，我们通过浏览器，只需要输入对应的网址或是点击页面中的一个链接，就能够快速地跳转到另一个页面，从而按我们的意愿来访问服务器。

而书中是这样描述万维网的工作方式：

> 万维网以客户服务器的方式工作，浏览器就是安装在用户主机上的万维网客户程序，万维网文档所驻留的主机则运行服务器程序，因此这台主机也称为万维网服务器。**客户程序向服务器程序发出请求，服务器程序向客户程序送回客户所要的万维网文档**，在一个客户程序主窗口上显示出的万维网文档称为页面。

上面提到的客户程序其实就是我们电脑上安装的浏览器，而服务端就是我们即将要去学习的Web服务器，也就是说，我们要明白如何搭建一个Web服务器并向用户发送我们提供的Web页面，在浏览器中显示的，一般就是HTML文档被解析后的样子。

那么，我们的服务器可能不止一个页面，可能会有很多个页面，那么客户端如何知道该去访问哪个服务器的哪个页面呢？这个时候就需要用到`URL`统一资源定位符。互联网上所有的资源，都有一个唯一确定的URL，比如`http://www.baidu.com`

URL的格式为：

> <协议>://<主机>:<端口>/<路径>
>
> 协议是指采用什么协议来访问服务器，不同的协议决定了服务器返回信息的格式，我们一般使用HTTP协议。
>
> 主机可以是一个域名，也可以是一个IP地址（实际上域名最后会被解析为IP地址进行访问）
>
> 端口是当前服务器上Web应用程序开启的端口，我们前面学习TCP通信的时候已经介绍过了，HTTP协议默认使用80端口，因此有时候可以省略。
>
> 路径就是我们希望去访问此服务器上的某个文件，不同的路径代表访问不同的资源。

我们接着来了解一下什么是HTTP协议：

> HTTP是面向事务的应用层协议，它是万维网上能够可靠交换文件的重要基础。HTTP不仅传送完成超文本跳转所需的必须信息，而且也传送任何可从互联网上得到的信息，如文本、超文本、声音和图像。

实际上我们之前访问百度、访问自己的网站，所有的传输都是以HTTP作为协议进行的。

我们来看看HTTP的传输原理：

> HTTP使用了面向连接的TCP作为运输层协议，保证了数据的可靠传输。HTTP不必考虑数据在传输过程中被丢弃后又怎样被重传。但是HTTP协议本身是无连接的。也就是说，HTTP虽然使用了TCP连接，但是通信的双方在交换HTTP报文之前不需要先建立HTTP连接。1997年以前使用的是HTTP/1.0协议，之后就是HTTP/1.1协议了。

那么既然HTTP是基于TCP进行通信的，我们首先来回顾一下TCP的通信原理：

![image-20220508004423271](image-20220508004423271.png)

TCP协议实际上是经历了三次握手再进行通信，也就是说保证整个通信是稳定的，才可以进行数据交换，并且在连接已经建立的过程中，双方随时可以互相发送数据，直到有一方主动关闭连接，这时在进行四次挥手，完成整个TCP通信。

而HTTP和TCP并不是一个层次的通信协议，TCP是传输层协议，而HTTP是应用层协议，因此，实际上HTTP的内容会作为TCP协议的报文被封装，并继续向下一层进行传递，而传输到客户端时，会依次进行解包，还原为最开始的HTTP数据。

![image-20220508004436964](image-20220508004436964.png)

HTTP使用TCP协议是为了使得数据传输更加可靠，既然它是依靠TCP协议进行数据传输，那么为什么说它本身是无连接的呢？我们来看一下HTTP的传输过程：

> 用户在点击鼠标链接某个万维网文档时，HTTP协议首先要和服务器建立TCP连接。这需要使用三报文握手。当建立TCP连接的三报文握手的前两部分完成后（即经过了一个RTT时间后），万维网客户就把HTTP请求报文作为建立TCP连接的三报文握手中的第三个报文的数据，发送给万维网服务器。服务器收到HTTP请求报文后，就把所请求的文档作为响应报文返回给客户。

![image-20220508004452916](image-20220508004452916.png)

因此，我们的浏览器请求一个页面，需要两倍的往返时间。

最后，我们再来了解一下HTTP的报文结构：

![image-20220508004504561](image-20220508004504561.png)

由客户端向服务端发送是报文称为请求报文，而服务端返回给客户端的称为响应报文，实际上，整个报文全部是以文本形式发送的，通过使用空格和换行来完成分段。

现在，我们已经了解了HTTP协议的全部基础知识，那么什么是Web服务器呢，实际上，它就是一个软件，但是它已经封装了所有的HTTP协议层面的操作，我们无需关心如何使用HTTP协议通信，而是直接基于服务器软件进行开发，我们只需要关心我们的页面数据如何展示、前后端如何交互即可。

# Socket技术

通过Socket技术（它是计算机之间进行**通信**的**一种约定**或一种方式），我们就可以实现两台计算机之间的通信，Socket也被翻译为`套接字`，是操作系统底层提供的一项通信技术，它支持TCP和UDP。而Java就对socket底层支持进行了一套完整的封装，我们可以通过Java来实现Socket通信。

要实现Socket通信，我们必须创建一个数据发送者和一个数据接收者，也就是客户端和服务端，我们需要提前启动服务端，来等待客户端的连接，而客户端只需要随时启动去连接服务端即可！

```java
//服务端
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        Socket socket = server.accept();  //当没有客户端连接时，线程会阻塞，直到有客户端连接为止
        System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

```java
//客户端
public static void main(String[] args) {
    try (Socket socket = new Socket("localhost", 8080)){
        System.out.println("已连接到服务端！");
    }catch (IOException e){
        System.out.println("服务端连接失败！");
        e.printStackTrace();
    }
}
```

实际上它就是一个TCP连接的建立过程

一旦TCP连接建立，服务端和客户端之间就可以相互发送数据，直到客户端主动关闭连接。当然，服务端不仅仅只可以让一个客户端进行连接，我们可以尝试让服务端一直运行来不断接受客户端的连接：

```java
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        while (true){   //无限循环等待客户端连接
            Socket socket = server.accept();
            System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
        }
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

现在我们就可以多次去连接此服务端了。

## 使用Socket进行数据传输

通过Socket对象，我们就可以获取到对应的I/O流进行网络数据传输：

```java
public static void main(String[] args) {
        try (Socket socket = new Socket("localhost", 8080);
             Scanner scanner = new Scanner(System.in)){
            System.out.println("已连接到服务端！");
            OutputStream stream = socket.getOutputStream();
            OutputStreamWriter writer = new OutputStreamWriter(stream);  //通过转换流来帮助我们快速写入内容
            System.out.println("请输入要发送给服务端的内容：");
            String text = scanner.nextLine();
            writer.write(text+'\n');   //因为对方是readLine()这里加个换行符
            writer.flush();
            System.out.println("数据已发送："+text);
        }catch (IOException e){
            System.out.println("服务端连接失败！");
            e.printStackTrace();
        }finally {
            System.out.println("客户端断开连接！");
        }
    }
}
```

```java
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        Socket socket = server.accept();
        System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));  //通过
        System.out.print("接收到客户端数据：");
        System.out.println(reader.readLine());
      	socket.close();   //和服务端TCP连接完成之后，记得关闭socket
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

同理，既然服务端可以读取客户端的内容，客户端也可以在发送后等待服务端给予响应：

```java
public static void main(String[] args) {
    try (Socket socket = new Socket("localhost", 8080);
         Scanner scanner = new Scanner(System.in)){
        System.out.println("已连接到服务端！");
        OutputStream stream = socket.getOutputStream();
        OutputStreamWriter writer = new OutputStreamWriter(stream);  //通过转换流来帮助我们快速写入内容
        System.out.println("请输入要发送给服务端的内容：");
        String text = scanner.nextLine();
        writer.write(text+'\n');   //因为对方是readLine()这里加个换行符
        writer.flush();
        System.out.println("数据已发送："+text);
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        System.out.println("收到服务器返回："+reader.readLine());
    }catch (IOException e){
        System.out.println("服务端连接失败！");
        e.printStackTrace();
    }finally {
        System.out.println("客户端断开连接！");
    }
}
```

```java
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        Socket socket = server.accept();
        System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));  //通过
        System.out.print("接收到客户端数据：");
        System.out.println(reader.readLine());
        OutputStreamWriter writer = new OutputStreamWriter(socket.getOutputStream());
        writer.write("已收到！");
        writer.flush();
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

我们可以手动关闭单向的流：

```java
socket.shutdownOutput();  //关闭输出方向的流
socket.shutdownInput();  //关闭输入方向的流
```

如果我们不希望服务端等待太长的时间，我们可以通过调用`setSoTimeout()`方法来设定IO超时时间：

```java
socket.setSoTimeout(3000);
```

当超过设定时间都依然没有收到客户端或是服务端的数据时，会抛出异常：

```java
java.net.SocketTimeoutException: Read timed out
	at java.net.SocketInputStream.socketRead0(Native Method)
	at java.net.SocketInputStream.socketRead(SocketInputStream.java:116)
	at java.net.SocketInputStream.read(SocketInputStream.java:171)
	at java.net.SocketInputStream.read(SocketInputStream.java:141)
	at sun.nio.cs.StreamDecoder.readBytes(StreamDecoder.java:284)
	at sun.nio.cs.StreamDecoder.implRead(StreamDecoder.java:326)
	at sun.nio.cs.StreamDecoder.read(StreamDecoder.java:178)
	at java.io.InputStreamReader.read(InputStreamReader.java:184)
	at java.io.BufferedReader.fill(BufferedReader.java:161)
	at java.io.BufferedReader.readLine(BufferedReader.java:324)
	at java.io.BufferedReader.readLine(BufferedReader.java:389)
	at com.test.Main.main(Main.java:41)
```

我们之前使用的都是通过构造方法直接连接服务端，那么是否可以等到我们想要的时候再去连接呢？

```java
try (Socket socket = new Socket(); //调用无参构造不会自动连接
     Scanner scanner = new Scanner(System.in)){ 
    socket.connect(new InetSocketAddress("localhost", 8080), 1000);  //手动调用connect方法进行连接
```

如果连接的双方发生意外而通知不到对方，导致一方还持有连接，这样就会占用资源，因此我们可以使用`setKeepAlive()`方法来防止此类情况发生：

```java
socket.setKeepAlive(true);
```

当客户端连接后，如果设置了keeplive为 true，当对方没有发送任何数据过来，超过一个时间(看系统内核参数配置)，那么我们这边会发送一个ack探测包发到对方，探测双方的TCP/IP连接是否有效。

TCP在传输过程中，实际上会有一个缓冲区用于数据的发送和接收：

![image-20220507155718211](image-20220507155718211.png)

此缓冲区大小为：8192，我们可以手动调整其大小来优化传输效率：

```java
socket.setReceiveBufferSize(25565);   //TCP接收缓冲区
socket.setSendBufferSize(25565);    //TCP发送缓冲区
```

## 使用Socket传输文件

既然Socket为我们提供了IO流便于数据传输，那么我们就可以轻松地实现文件传输了。

## 使用浏览器访问Socket服务器

在了解了如何使用Socket传输文件后，我们来看看，浏览器是如何向服务器发起请求的：

```java
public static void main(String[] args) {
        try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
            System.out.println("正在等待客户端连接...");
            Socket socket = server.accept();
            System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
            InputStream in = socket.getInputStream();  //通过
            System.out.println("接收到客户端数据：");
            while (true){
                int i = in.read();
                if(i == -1) break;
                System.out.print((char) i);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
```

我们现在打开浏览器，输入http://localhost:8080或是http://127.0.0.1:8080/，来连接我们本地开放的服务器。

我们发现浏览器是无法打开这个链接的，但是我们服务端却收到了不少的信息：

```properties
GET / HTTP/1.1
Host: 127.0.0.1:8080
Connection: keep-alive
Cache-Control: max-age=0
sec-ch-ua: "Chromium";v="94", "Google Chrome";v="94", ";Not A Brand";v="99"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "macOS"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,und;q=0.8,en;q=0.7
```

实际上这些内容都是Http协议规定的请求头内容。HTTP是一种应用层协议，全称为超文本传输协议，它本质也是基于TCP协议进行数据传输，因此我们的服务端能够读取HTTP请求。但是Http协议并不会保持长连接，在得到我们响应的数据后会立即关闭TCP连接。

既然使用的是Http连接，如果我们的服务器要支持响应HTTP请求，那么就需要按照HTTP协议的规则，返回一个规范的响应文本，首先是响应头，它至少要包含一个响应码：

```properties
HTTP/1.1 200 Accpeted
```

然后就是响应内容（注意一定要换行再写），我们尝试来编写一下支持HTTP协议的响应内容：

```java
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        Socket socket = server.accept();
        System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));  //通过
        System.out.println("接收到客户端数据：");
        while (reader.ready()) System.out.println(reader.readLine());   //ready是判断当前流中是否还有可读内容
        OutputStreamWriter writer = new OutputStreamWriter(socket.getOutputStream());
        writer.write("HTTP/1.1 200 Accepted\r\n");   //200是响应码，Http协议规定200为接受请求，400为错误的请求，404为找不到此资源（不止这些，还有很多）
        writer.write("\r\n");   //在请求头写完之后还要进行一次换行，然后写入我们的响应实体（会在浏览器上展示的内容）
        writer.write("lbwnb!");
        writer.flush();
    }catch (Exception e){
        e.printStackTrace();
    }
}
```

我们可以打开浏览器的开发者模式（这里推荐使用Chrome/Edge浏览器，按下F12即可打开），我们来观察一下浏览器的实际请求过程。

# Http

## 什么是HTTP

HTTP（超文本传输协议）是一个简单的请求-响应协议，它通常运行在TCP之上。

- 文本：html，字符串，~
-  超文本：图片，音乐，视频，定位，地图……. 
- 使用80端口

Https：安全的 

- 使用443端口

## 两个时代

- http1.0 HTTP/1.0：客户端可以与web服务器连接后，只能获得一个web资源，断开连接 
- http2.0：HTTP/1.1：客户端可以与web服务器连接后，可以获得多个web资源。

## Http请求

### 请求方式

请求行中的请求方式：GET

请求方式：Get，Post，HEAD,DELETE,PUT,TRACT…

- get：请求能够携带的参数比较少，大小有限制，会在浏览器的URL地址栏显示数据内容，不安全，但高效 

- post：请求能够携带的参数没有限制，大小没有限制，不会在浏览器的URL地址栏显示数据内容，安全，但不高效。

### 消息头

```xml
Accept：告诉浏览器，它所支持的数据类型
Accept-Encoding：支持哪种编码格式 GBK UTF-8 GB2312 ISO8859-1
Accept-Language：告诉浏览器，它的语言环境
Cache-Control：缓存控制 Connection：告诉浏览器，请求完成是断开还是保持连接
HOST：主机....
```



### Http响应

`响应头`

```xml
Cache-Control:private  缓存控制
Connection:Keep-Alive 连接
Content-Encoding:gzip 编码
Content-Type:text/html 类型
```



`响应体`

```xml
Accept：告诉浏览器，它所支持的数据类型 
Accept-Encoding：支持哪种编码格式 GBK 
Accept-Language：告诉浏览器，它的语言环境 
Cache-Control：缓存控制 
Connection：告诉浏览器，请求完成是断开还是保持连接 
HOST：主机..../. 
Refresh：告诉客户端，多久刷新一次； 
Location：让网页重新定位；
```



`响应状态码`

- 200：请求响应成功 200

- 3xx：请求重定向
  - 重定向：你重新到我给你新位置去； 

- 4xx：找不到资源 404 资源不存在； 
- 5xx：服务器代码错误 500 
  - 502:网关错误



# 创建新web项目

## 创建步骤

### 新建项目

- 创建一个java项目

- 项目上右键添加web相关框架支持

![image-20220426193844506](03%20code-study-record/Java/java语言基础/assets/javaweb/image-20220426193844506.png)

![image-20220426193909626](image-20220426193909626.png)

- 添加maven支持：同添加web相关框架支持

- tomcat服务器配置

![image-20220426204012405](03%20code-study-record/Java/java语言基础/assets/javaweb/image-20220426204012405.png)

注意上面的两个热更新需要配置deployment之后才会出现	![image-20220426204119333](03%20code-study-record/Java/java语言基础/assets/javaweb/image-20220426204119333.png)

# MVC三层架构

Model view Controller 模型、视图、控制器

### Model

- 业务处理 ：业务逻辑（Service） ，要注意具体的业务逻辑也是model层处理的
- 数据持久层：CRUD （Dao）

### View

- 展示数据 
- 提供链接发起Servlet请求 （a，form，img…）

### Controller 

协调几个层的中间层

- Servlet
- 接收用户的请求 ：（req：请求参数、Session信息….）
- 交给业务层处理对应的代码
- 控制视图的跳转

### 串联

登录--->接收用户的登录请求--->处理用户的请求（获取用户登录的参数，username password）---->交给业务层处理登录业务（判断用户名密码是否正确：事务）--->Dao层查询用户名和密码是否正确-->数据库

# Servlet

前面我们已经完成了基本的环境搭建，那么现在我们就可以开始来了解我们的第一个重要类——Servlet。

它是Java EE的一个标准，大部分的Web服务器都支持此标准，包括Tomcat，就像之前的JDBC一样，由官方定义了一系列接口，而具体实现由我们来编写，最后交给Web服务器（如Tomcat）来运行我们编写的Servlet。

那么，它能做什么呢？我们可以通过实现Servlet来进行动态网页响应，使用Servlet，不再是直接由Tomcat服务器发送我们编写好的静态网页内容（HTML文件），而是由我们通过Java代码进行动态拼接的结果，它能够很好地实现动态网页的返回。

当然，Servlet并不是专用于HTTP协议通信，也可以用于其他的通信，但是一般都是用于HTTP。

## 创建Servlet

那么如何创建一个Servlet呢，非常简单，我们只需要实现`Servlet`类即可，并添加注解`@WebServlet`来进行注册。

```java
@WebServlet("/test")
public class TestServlet implements Servlet {
		...实现接口方法
}
```

我们现在就可以去访问一下我们的页面：http://localhost:8080/test/test

我们发现，直接访问此页面是没有任何内容的，这是因为我们还没有为该请求方法编写实现，这里先不做讲解，后面我们会对浏览器的请求处理做详细的介绍。

除了直接编写一个类，我们也可以在`web.xml`中进行注册，现将类上`@WebServlet`的注解去掉：

```xml
<servlet>
    <servlet-name>test</servlet-name>
    <servlet-class>com.example.webtest.TestServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>test</servlet-name>
    <url-pattern>/test</url-pattern>
</servlet-mapping>
```

这样的方式也能注册Servlet，但是显然直接使用注解更加方便，因此之后我们一律使用注解进行开发。只有比较新的版本才支持此注解，老的版本是不支持的哦。

实际上，Tomcat服务器会为我们提供一些默认的Servlet，也就是说在服务器启动后，即使我们什么都不编写，Tomcat也自带了几个默认的Servlet，他们编写在conf目录下的web.xml中：

```xml
<!-- The mapping for the default servlet -->
    <servlet-mapping>
        <servlet-name>default</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

    <!-- The mappings for the JSP servlet -->
    <servlet-mapping>
        <servlet-name>jsp</servlet-name>
        <url-pattern>*.jsp</url-pattern>
        <url-pattern>*.jspx</url-pattern>
    </servlet-mapping>

```

我们发现，默认的Servlet实际上可以帮助我们去访问一些静态资源，这也是为什么我们启动Tomcat服务器之后，能够直接访问webapp目录下的静态页面。

我们可以将之前编写的页面放入到webapp目录下，来测试一下是否能直接访问。

## 探究Servlet的生命周期

我们已经了解了如何注册一个Servlet，那么我们接着来看看，一个Servlet是如何运行的。

首先我们需要了解，Servlet中的方法各自是在什么时候被调用的，我们先编写一个打印语句来看看：

```java
public class TestServlet implements Servlet {

    public TestServlet(){
        System.out.println("我是构造方法！");
    }

    @Override
    public void init(ServletConfig servletConfig) throws ServletException {
        System.out.println("我是init");
    }

    @Override
    public ServletConfig getServletConfig() {
        System.out.println("我是getServletConfig");
        return null;
    }

    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("我是service");
    }

    @Override
    public String getServletInfo() {
        System.out.println("我是getServletInfo");
        return null;
    }

    @Override
    public void destroy() {
        System.out.println("我是destroy");
    }
}
```

我们首先启动一次服务器，然后访问我们定义的页面，然后再关闭服务器，得到如下的顺序：

> 我是构造方法！
> 我是init
> 我是service
> 我是service（出现两次是因为浏览器请求了2次，是因为有一次是请求favicon.ico，浏览器通病）
>
> 我是destroy

我们可以多次尝试去访问此页面，但是init和构造方法只会执行一次，而每次访问都会执行的是`service`方法，因此，一个Servlet的生命周期为：

- 首先执行构造方法完成 Servlet 初始化
- Servlet 初始化后调用 **init ()** 方法。
- Servlet 调用 **service()** 方法来处理客户端的请求。
- Servlet 销毁前调用 **destroy()** 方法。
- 最后，Servlet 是由 JVM 的垃圾回收器进行垃圾回收的。

现在我们发现，实际上在Web应用程序运行时，每当浏览器向服务器发起一个请求时，都会创建一个线程执行一次`service`方法，来让我们处理用户的请求，并将结果响应给用户。

我们发现`service`方法中，还有两个参数，`ServletRequest`和`ServletResponse`，实际上，用户发起的HTTP请求，就被Tomcat服务器封装为了一个`ServletRequest`对象，我们得到是其实是Tomcat服务器帮助我们创建的一个实现类，HTTP请求报文中的所有内容，都可以从`ServletRequest`对象中获取，同理，`ServletResponse`就是我们需要返回给浏览器的HTTP响应报文实体类封装。

那么我们来看看`ServletRequest`中有哪些内容，我们可以获取请求的一些信息：

```java
@Override
public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    //首先将其转换为HttpServletRequest（继承自ServletRequest，一般是此接口实现）
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        
        System.out.println(request.getProtocol());  //获取协议版本
        System.out.println(request.getRemoteAddr());  //获取访问者的IP地址
  		  System.out.println(request.getMethod());   //获取请求方法
        //获取头部信息
        Enumeration<String> enumeration = request.getHeaderNames();
        while (enumeration.hasMoreElements()){
            String name = enumeration.nextElement();
            System.out.println(name + ": " + request.getHeader(name));
        }
}
```

我们发现，整个HTTP请求报文中的所有内容，都可以通过`HttpServletRequest`对象来获取，当然，它的作用肯定不仅仅是获取头部信息，我们还可以使用它来完成更多操作，后面会一一讲解。

那么我们再来看看`ServletResponse`，这个是服务端的响应内容，我们可以在这里填写我们想要发送给浏览器显示的内容：

```java
//转换为HttpServletResponse（同上）
HttpServletResponse response = (HttpServletResponse) servletResponse;
//设定内容类型以及编码格式（普通HTML文本使用text/html，之后会讲解文件传输）
response.setHeader("Content-type", "text/html;charset=UTF-8");
//获取Writer直接写入内容
response.getWriter().write("我是响应内容！");
//所有内容写入完成之后，再发送给浏览器
```

现在我们在浏览器中打开此页面，就能够收到服务器发来的响应内容了。其中，响应头部分，是由Tomcat帮助我们生成的一个默认响应头。

![image-20220508004840056](image-20220508004840056.png)

因此，实际上整个流程就已经很清晰明了了。

## 解读和使用HttpServlet

前面我们已经学习了如何创建、注册和使用Servlet，那么我们继续来深入学习Servlet接口的一些实现类。

首先`Servlet`有一个直接实现抽象类`GenericServlet`，那么我们来看看此类做了什么事情。

我们发现，这个类完善了配置文件读取和Servlet信息相关的的操作，但是依然没有去实现service方法，因此此类仅仅是用于完善一个Servlet的基本操作，那么我们接着来看`HttpServlet`，它是遵循HTTP协议的一种Servlet，继承自`GenericServlet`，它根据HTTP协议的规则，完善了service方法。

在阅读了HttpServlet源码之后，我们发现，其实我们只需要继承HttpServlet来编写我们的Servlet就可以了，并且它已经帮助我们提前实现了一些操作，这样就会给我们省去很多的时间。

```java
@Log
@WebServlet("/test")
public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write("<h1>恭喜你解锁了全新玩法</h1>");
    }
}
```

现在，我们只需要重写对应的请求方式，就可以快速完成Servlet的编写。

## @WebServlet注解详解

我们接着来看WebServlet注解，我们前面已经得知，可以直接使用此注解来快速注册一个Servlet，那么我们来想细看看此注解还有什么其他的玩法。

首先name属性就是Servlet名称，而urlPatterns和value实际上是同样功能，就是代表当前Servlet的访问路径，它不仅仅可以是一个固定值，还可以进行通配符匹配：

```java
@WebServlet("/test/*")
```

上面的路径表示，所有匹配`/test/随便什么`的路径名称，都可以访问此Servlet，我们可以在浏览器中尝试一下。

也可以进行某个扩展名称的匹配：

```java
@WebServlet("*.js")
```

这样的话，获取任何以js结尾的文件，都会由我们自己定义的Servlet处理。

那么如果我们的路径为`/`呢？

```java
@WebServlet("/")
```

此路径和Tomcat默认为我们提供的Servlet冲突，会直接替换掉默认的，而使用我们的，此路径的意思为，如果没有找到匹配当前访问路径的Servlet，那么久会使用此Servlet进行处理。

我们还可以为一个Servlet配置多个访问路径：

```java
@WebServlet({"/test1", "/test2"})
```

我们接着来看loadOnStartup属性，此属性决定了是否在Tomcat启动时就加载此Servlet，默认情况下，Servlet只有在被访问时才会加载，它的默认值为-1，表示不在启动时加载，我们可以将其修改为大于等于0的数，来开启启动时加载。并且数字的大小决定了此Servlet的启动优先级。

```java
@Log
@WebServlet(value = "/test", loadOnStartup = 1)
public class TestServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        super.init();
        log.info("我被初始化了！");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write("<h1>恭喜你解锁了全新玩法</h1>");
    }
}
```

其他内容都是Servlet的一些基本配置，这里就不详细讲解了。

## 使用POST请求完成登陆

我们前面已经了解了如何使用Servlet来处理HTTP请求，那么现在，我们就结合前端，来实现一下登陆操作。

我们需要修改一下我们的Servlet，现在我们要让其能够接收一个POST请求：

```java
@Log
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getParameterMap().forEach((k, v) -> {
            System.out.println(k + ": " + Arrays.toString(v));
        });
    }
}
```

`ParameterMap`存储了我们发送的POST请求所携带的表单数据，我们可以直接将其遍历查看，浏览器发送了什么数据。

现在我们再来修改一下前端：

```html
<body>
    <h1>登录到系统</h1>
    <form method="post" action="login">
        <hr>
        <div>
            <label>
                <input type="text" placeholder="用户名" name="username">
            </label>
        </div>
        <div>
            <label>
                <input type="password" placeholder="密码" name="password">
            </label>
        </div>
        <div>
            <button>登录</button>
        </div>
    </form>
</body>
```

通过修改form标签的属性，现在我们点击登录按钮，会自动向后台发送一个POST请求，请求地址为当前地址+/login（注意不同路径的写法），也就是我们上面编写的Servlet路径。

运行服务器，测试后发现，在点击按钮后，确实向服务器发起了一个POST请求，并且携带了表单中文本框的数据。

现在，我们根据已有的基础，将其与数据库打通，我们进行一个真正的用户登录操作，首先修改一下Servlet的逻辑：

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //首先设置一下响应类型
    resp.setContentType("text/html;charset=UTF-8");
    //获取POST请求携带的表单数据
    Map<String, String[]> map = req.getParameterMap();
    //判断表单是否完整
    if(map.containsKey("username") && map.containsKey("password")) {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        //权限校验（待完善）
    }else {
        resp.getWriter().write("错误，您的表单数据不完整！");
    }
}
```

接下来我们再去编写Mybatis的依赖和配置文件，创建一个表，用于存放我们用户的账号和密码。

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="${驱动类（含包名）}"/>
                <property name="url" value="${数据库连接URL}"/>
                <property name="username" value="${用户名}"/>
                <property name="password" value="${密码}"/>
            </dataSource>
        </environment>
    </environments>
</configuration>
```

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.7</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.27</version>
</dependency>
```

配置完成后，在我们的Servlet的init方法中编写Mybatis初始化代码，因为它只需要初始化一次。

```java
SqlSessionFactory factory;
@SneakyThrows
@Override
public void init() throws ServletException {
    factory = new SqlSessionFactoryBuilder().build(Resources.getResourceAsReader("mybatis-config.xml"));
}
```

现在我们创建一个实体类以及Mapper来进行用户信息查询：

```java
@Data
public class User {
    String username;
    String password;
}
```

```java
public interface UserMapper {

    @Select("select * from users where username = #{username} and password = #{password}")
    User getUser(@Param("username") String username, @Param("password") String password);
}
```

```xml
<mappers>
    <mapper class="com.example.dao.UserMapper"/>
</mappers>
```

好了，现在完事具备，只欠东风了，我们来完善一下登陆验证逻辑：

```java
//登陆校验（待完善）
try (SqlSession sqlSession = factory.openSession(true)){
    UserMapper mapper = sqlSession.getMapper(UserMapper.class);
    User user = mapper.getUser(username, password);
    //判断用户是否登陆成功，若查询到信息则表示存在此用户
    if(user != null){
        resp.getWriter().write("登陆成功！");
    }else {
        resp.getWriter().write("登陆失败，请验证您的用户名或密码！");
    }
}
```

现在再去浏览器上进行测试吧！

注册界面其实是同理的，这里就不多做讲解了。

## 上传和下载文件

首先我们来看看比较简单的下载文件，首先将我们的icon.png放入到resource文件夹中，接着我们编写一个Servlet用于处理文件下载：

```java
@WebServlet("/file")
public class FileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      resp.setContentType("image/png");  
      OutputStream outputStream = resp.getOutputStream();
      InputStream inputStream = Resources.getResourceAsStream("icon.png");

    }
}
```

为了更加快速地编写IO代码，我们可以引入一个工具库：

```xml
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.6</version>
</dependency>
```

使用此类库可以快速完成IO操作：

```java
resp.setContentType("image/png");
OutputStream outputStream = resp.getOutputStream();
InputStream inputStream = Resources.getResourceAsStream("icon.png");
//直接使用copy方法完成转换
IOUtils.copy(inputStream, outputStream);
```

现在我们在前端页面添加一个链接，用于下载此文件：

```html
<hr>
<a href="file" download="icon.png">点我下载高清资源</a>
```

下载文件搞定，那么如何上传一个文件呢？

首先我们编写前端部分：

```html
<form method="post" action="file" enctype="multipart/form-data">
    <div>
        <input type="file" name="test-file">
    </div>
    <div>
        <button>上传文件</button>
    </div>
</form>
```

注意必须添加`enctype="multipart/form-data"`，来表示此表单用于文件传输。

现在我们来修改一下Servlet代码：

```java
@MultipartConfig
@WebServlet("/file")
public class FileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try(FileOutputStream stream = new FileOutputStream("/Users/nagocoler/Documents/IdeaProjects/WebTest/test.png")){
            Part part = req.getPart("test-file");
            IOUtils.copy(part.getInputStream(), stream);
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().write("文件上传成功！");
        }
    }
}
```

注意，必须添加`@MultipartConfig`注解来表示此Servlet用于处理文件上传请求。

现在我们再运行服务器，并将我们刚才下载的文件又上传给服务端。

## 使用XHR请求数据

现在我们希望，网页中的部分内容，可以动态显示，比如网页上有一个时间，旁边有一个按钮，点击按钮就可以刷新当前时间。

这个时候就需要我们在网页展示时向后端发起请求了，并根据后端响应的结果，动态地更新页面中的内容，要实现此功能，就需要用到JavaScript来帮助我们，首先在js中编写我们的XHR请求，并在请求中完成动态更新：

```js
function updateTime() {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            document.getElementById("time").innerText = xhr.responseText
        }
    };
    xhr.open('GET', 'time', true);
    xhr.send();
}
```

接着修改一下前端页面，添加一个时间显示区域：

```html
<hr>
<div id="time"></div>
<br>
<button onclick="updateTime()">更新数据</button>
<script>
    updateTime()
</script>
```

最后创建一个Servlet用于处理时间更新请求：

```java
@WebServlet("/time")
public class TimeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss");
        String date = dateFormat.format(new Date());
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().write(date);
    }
}
```

现在点击按钮就可以更新了。

GET请求也能传递参数，这里做一下演示。

## 重定向与请求转发

当我们希望用户登录完成之后，直接跳转到网站的首页，那么这个时候，我们就可以使用重定向来完成。当浏览器收到一个重定向的响应时，会按照重定向响应给出的地址，再次向此地址发出请求。

实现重定向很简单，只需要调用一个方法即可，我们修改一下登陆成功后执行的代码：

```java
resp.sendRedirect("time");
```

调用后，响应的状态码会被设置为302，并且响应头中添加了一个Location属性，此属性表示，需要重定向到哪一个网址。

现在，如果我们成功登陆，那么服务器会发送给我们一个重定向响应，这时，我们的浏览器会去重新请求另一个网址。这样，我们在登陆成功之后，就可以直接帮助用户跳转到用户首页了。

那么我们接着来看请求转发，请求转发其实是一种服务器内部的跳转机制，我们知道，重定向会使得浏览器去重新请求一个页面，而请求转发则是服务器内部进行跳转，它的目的是，直接将本次请求转发给其他Servlet进行处理，并由其他Servlet来返回结果，因此它是在进行内部的转发。

```java
req.getRequestDispatcher("/time").forward(req, resp);
```

现在，在登陆成功的时候，我们将请求转发给处理时间的Servlet，注意这里的路径规则和之前的不同，我们需要填写Servlet上指明的路径，并且请求转发只能转发到此应用程序内部的Servlet，不能转发给其他站点或是其他Web应用程序。

现在再次进行登陆操作，我们发现，返回结果为一个405页面，证明了，我们的请求现在是被另一个Servlet进行处理，并且请求的信息全部被转交给另一个Servlet，由于此Servlet不支持POST请求，因此返回405状态码。

那么也就是说，该请求包括请求参数也一起被传递了，那么我们可以尝试获取以下POST请求的参数。

现在我们给此Servlet添加POST请求处理，直接转交给Get请求处理：

```java
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    this.doGet(req, resp);
}
```

再次访问，成功得到结果，但是我们发现，浏览器只发起了一次请求，并没有再次请求新的URL，也就是说，这一次请求直接返回了请求转发后的处理结果。

那么，请求转发有什么好处呢？它可以携带数据！

```java
req.setAttribute("test", "我是请求转发前的数据");
req.getRequestDispatcher("/time").forward(req, resp);
```

```java
System.out.println(req.getAttribute("test"));
```

通过`setAttribute`方法来给当前请求添加一个附加数据，在请求转发后，我们可以直接获取到该数据。

重定向属于2次请求，因此无法使用这种方式来传递数据，那么，如何在重定向之间传递数据呢？我们可以使用即将要介绍的ServletContext对象。

最后总结，两者的区别为：

* 请求转发是一次请求，重定向是两次请求
* 请求转发地址栏不会发生改变， 重定向地址栏会发生改变
* 请求转发可以共享请求参数 ，重定向之后，就获取不了共享参数了
* 请求转发只能转发给内部的Servlet

## 了解ServletContext对象

ServletContext全局唯一，它是属于整个Web应用程序的，我们可以通过`getServletContext()`来获取到此对象。

此对象也能设置附加值：

```java
ServletContext context = getServletContext();
context.setAttribute("test", "我是重定向之前的数据");
resp.sendRedirect("time");
```

```java
System.out.println(getServletContext().getAttribute("test"));
```

因为无论在哪里，无论什么时间，获取到的ServletContext始终是同一个对象，因此我们可以随时随地获取我们添加的属性。

它不仅仅可以用来进行数据传递，还可以做一些其他的事情，比如请求转发：

```java
context.getRequestDispatcher("/time").forward(req, resp);
```

它还可以获取根目录下的资源文件（注意是webapp根目录下的，不是resource中的资源）

## 初始化参数

初始化参数类似于初始化配置需要的一些值，比如我们的数据库连接相关信息，就可以通过初始化参数来给予Servlet，或是一些其他的配置项，也可以使用初始化参数来实现。

我们可以给一个Servlet添加一些初始化参数：

```java
@WebServlet(value = "/login", initParams = {
        @WebInitParam(name = "test", value = "我是一个默认的初始化参数")
})
```

它也是以键值对形式保存的，我们可以直接通过Servlet的`getInitParameter`方法获取：

```java
System.out.println(getInitParameter("test"));
```

但是，这里的初始化参数仅仅是针对于此Servlet，我们也可以定义全局初始化参数，只需要在web.xml编写即可：

```xml
<context-param>
    <param-name>lbwnb</param-name>
    <param-value>我是全局初始化参数</param-value>
</context-param>
```

我们需要使用ServletContext来读取全局初始化参数：

```java
ServletContext context = getServletContext();
System.out.println(context.getInitParameter("lbwnb"));
```

有关ServletContext其他的内容，我们需要完成后面内容的学习，才能理解。

# Cookie

什么是Cookie？不是曲奇，它可以在浏览器中保存一些信息，并且在下次请求时，请求头中会携带这些信息。

我们可以编写一个测试用例来看看：

```java
Cookie cookie = new Cookie("test", "yyds");
resp.addCookie(cookie);
resp.sendRedirect("time");
```

```java
for (Cookie cookie : req.getCookies()) {
    System.out.println(cookie.getName() + ": " + cookie.getValue());
}
```

我们可以观察一下，在`HttpServletResponse`中添加Cookie之后，浏览器的响应头中会包含一个`Set-Cookie`属性，同时，在重定向之后，我们的请求头中，会携带此Cookie作为一个属性，同时，我们可以直接通过`HttpServletRequest`来快速获取有哪些Cookie信息。

![image-20220508004956738](image-20220508004956738.png)

还有这么神奇的事情吗？那么我们来看看，一个Cookie包含哪些信息：

* name   -   Cookie的名称，Cookie一旦创建，名称便不可更改
* value  -   Cookie的值，如果值为Unicode字符，需要为字符编码。如果为二进制数据，则需要使用BASE64编码
* maxAge  -  Cookie失效的时间，单位秒。如果为正数，则该Cookie在maxAge秒后失效。如果为负数，该Cookie为临时Cookie，关闭浏览器即失效，浏览器也不会以任何形式保存该Cookie。如果为0，表示删除该Cookie。默认为-1。
* secure  -  该Cookie是否仅被使用安全协议传输。安全协议。安全协议有HTTPS，SSL等，在网络上传输数据之前先将数据加密。默认为false。
* path  -  Cookie的使用路径。如果设置为“/sessionWeb/”，则只有contextPath为“/sessionWeb”的程序可以访问该Cookie。如果设置为“/”，则本域名下contextPath都可以访问该Cookie。注意最后一个字符必须为“/”。
* domain  -  可以访问该Cookie的域名。如果设置为“.google.com”，则所有以“google.com”结尾的域名都可以访问该Cookie。注意第一个字符必须为“.”。
* comment  -  该Cookie的用处说明，浏览器显示Cookie信息的时候显示该说明。
* version  -  Cookie使用的版本号。0表示遵循Netscape的Cookie规范，1表示遵循W3C的RFC 2109规范

我们发现，最关键的其实是`name`、`value`、`maxAge`、`domain`属性。

那么我们来尝试修改一下maxAge来看看失效时间：

```java
cookie.setMaxAge(20);
```

设定为20秒，我们可以直接看到，响应头为我们设定了20秒的过期时间。20秒内访问都会携带此Cookie，而超过20秒，Cookie消失。

既然了解了Cookie的作用，我们就可以通过使用Cookie来实现记住我功能，我们可以将用户名和密码全部保存在Cookie中，如果访问我们的首页时携带了这些Cookie，那么我们就可以直接为用户进行登陆，如果登陆成功则直接跳转到首页，如果登陆失败，则清理浏览器中的Cookie。

那么首先，我们先在前端页面的表单中添加一个勾选框：

```html
<div>
    <label>
        <input type="checkbox" placeholder="记住我" name="remember-me">
        记住我
    </label>
</div>
```

接着，我们在登陆成功时进行判断，如果用户勾选了记住我，那么就讲Cookie存储到本地：

```java
if(map.containsKey("remember-me")){   //若勾选了勾选框，那么会此表单信息
    Cookie cookie_username = new Cookie("username", username);
    cookie_username.setMaxAge(30);
    Cookie cookie_password = new Cookie("password", password);
    cookie_password.setMaxAge(30);
    resp.addCookie(cookie_username);
    resp.addCookie(cookie_password);
}
```

然后，我们修改一下默认的请求地址，现在一律通过`http://localhost:8080/yyds/login`进行登陆，那么我们需要添加GET请求的相关处理：

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Cookie[] cookies = req.getCookies();
    if(cookies != null){
        String username = null;
        String password = null;
        for (Cookie cookie : cookies) {
            if(cookie.getName().equals("username")) username = cookie.getValue();
            if(cookie.getName().equals("password")) password = cookie.getValue();
        }
        if(username != null && password != null){
            //登陆校验
            try (SqlSession sqlSession = factory.openSession(true)){
                UserMapper mapper = sqlSession.getMapper(UserMapper.class);
                User user = mapper.getUser(username, password);
                if(user != null){
                    resp.sendRedirect("time");
                    return;   //直接返回
                }
            }
        }
    }
    req.getRequestDispatcher("/").forward(req, resp);   //正常情况还是转发给默认的Servlet帮我们返回静态页面
}
```

现在，30秒内都不需要登陆，访问登陆页面后，会直接跳转到time页面。

现在已经离我们理想的页面越来越接近了，但是仍然有一个问题，就是我们的首页，无论是否登陆，所有人都可以访问，那么，如何才可以实现只有登陆之后才能访问呢？这就需要用到Session了。

# Session

由于HTTP是无连接的，那么如何能够辨别当前的请求是来自哪个用户发起的呢？Session就是用来处理这种问题的，每个用户的会话都会有一个自己的Session对象，来自同一个浏览器的所有请求，就属于同一个会话。

但是HTTP协议是无连接的呀，那Session是如何做到辨别是否来自同一个浏览器呢？Session实际上是基于Cookie实现的，前面我们了解了Cookie，我们知道，服务端可以将Cookie保存到浏览器，当浏览器下次访问时，就会附带这些Cookie信息。

Session也利用了这一点，它会给浏览器设定一个叫做`JSESSIONID`的Cookie，值是一个随机的排列组合，而此Cookie就对应了你属于哪一个对话，只要我们的浏览器携带此Cookie访问服务器，服务器就会通过Cookie的值进行辨别，得到对应的Session对象，因此，这样就可以追踪到底是哪一个浏览器在访问服务器。

![image-20220508005008061](image-20220508005008061.png)

那么现在，我们在用户登录成功之后，将用户对象添加到Session中，只要是此用户发起的请求，我们都可以从`HttpSession`中读取到存储在会话中的数据：

```java
HttpSession session = req.getSession();
session.setAttribute("user", user);
```

同时，如果用户没有登录就去访问首页，那么我们将发送一个重定向请求，告诉用户，需要先进行登录才可以访问：

```java
HttpSession session = req.getSession();
User user = (User) session.getAttribute("user");
if(user == null) {
    resp.sendRedirect("login");
    return;
}
```

在访问的过程中，注意观察Cookie变化。

Session并不是永远都存在的，它有着自己的过期时间，默认时间为30分钟，若超过此时间，Session将丢失，我们可以在配置文件中修改过期时间：

```xml
<session-config>
    <session-timeout>1</session-timeout>
</session-config>
```

我们也可以在代码中使用`invalidate`方法来使Session立即失效：

```java
session.invalidate();
```

现在，通过Session，我们就可以更好地控制用户对于资源的访问，只有完成登陆的用户才有资格访问首页。

# Filter

有了Session之后，我们就可以很好地控制用户的登陆验证了，只有授权的用户，才可以访问一些页面，但是我们需要一个一个去进行配置，还是太过复杂，能否一次性地过滤掉没有登录验证的用户呢？

过滤器相当于在所有访问前加了一堵墙，来自浏览器的所有访问请求都会首先经过过滤器，只有过滤器允许通过的请求，才可以顺利地到达对应的Servlet，而过滤器不允许的通过的请求，我们可以自由地进行控制是否进行重定向或是请求转发。并且过滤器可以添加很多个，就相当于添加了很多堵墙，我们的请求只有穿过层层阻碍，才能与Servlet相拥，像极了爱情。

![image-20220508005020931](image-20220508005020931.png)

添加一个过滤器非常简单，只需要实现Filter接口，并添加`@WebFilter`注解即可：

```java
@WebFilter("/*")   //路径的匹配规则和Servlet一致，这里表示匹配所有请求
public class TestFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        
    }
}
```

这样我们就成功地添加了一个过滤器，那么添加一句打印语句看看，是否所有的请求都会经过此过滤器：

```java
HttpServletRequest request = (HttpServletRequest) servletRequest;
System.out.println(request.getRequestURL());
```

我们发现，现在我们发起的所有请求，一律需要经过此过滤器，并且所有的请求都没有任何的响应内容。

那么如何让请求可以顺利地到达对应的Servlet，也就是说怎么让这个请求顺利通过呢？我们只需要在最后添加一句：

```java
filterChain.doFilter(servletRequest, servletResponse);
```

那么这行代码是什么意思呢？

由于我们整个应用程序可能存在多个过滤器，那么这行代码的意思实际上是将此请求继续传递给下一个过滤器，当没有下一个过滤器时，才会到达对应的Servlet进行处理，我们可以再来创建一个过滤器看看效果：

```java
@WebFilter("/*")
public class TestFilter2 implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("我是2号过滤器");
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
```

由于过滤器的过滤顺序是按照类名的自然排序进行的，因此我们将第一个过滤器命名进行调整。

我们发现，在经过第一个过滤器之后，会继续前往第二个过滤器，只有两个过滤器全部经过之后，才会到达我们的Servlet中。

![image-20220508005031100](image-20220508005031100.png)

实际上，当`doFilter`方法调用时，就会一直向下直到Servlet，在Servlet处理完成之后，又依次返回到最前面的Filter，类似于递归的结构，我们添加几个输出语句来判断一下：

```java
@Override
public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("我是2号过滤器");
    filterChain.doFilter(servletRequest, servletResponse);
    System.out.println("我是2号过滤器，处理后");
}
```

```java
@Override
public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    System.out.println("我是1号过滤器");
    filterChain.doFilter(servletRequest, servletResponse);
    System.out.println("我是1号过滤器，处理后");
}
```

最后验证我们的结论。

同Servlet一样，Filter也有对应的HttpFilter专用类，它针对HTTP请求进行了专门处理，因此我们可以直接使用HttpFilter来编写：

```java
public abstract class HttpFilter extends GenericFilter {
    private static final long serialVersionUID = 7478463438252262094L;

    public HttpFilter() {
    }

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        if (req instanceof HttpServletRequest && res instanceof HttpServletResponse) {
            this.doFilter((HttpServletRequest)req, (HttpServletResponse)res, chain);
        } else {
            throw new ServletException("non-HTTP request or response");
        }
    }

    protected void doFilter(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws IOException, ServletException {
        chain.doFilter(req, res);
    }
}
```

那么现在，我们就可以给我们的应用程序添加一个过滤器，用户在未登录情况下，只允许静态资源和登陆页面请求通过，登陆之后畅行无阻：

```java
@WebFilter("/*")
public class MainFilter extends HttpFilter {
    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws IOException, ServletException {
        String url = req.getRequestURL().toString();
        //判断是否为静态资源
        if(!url.endsWith(".js") && !url.endsWith(".css") && !url.endsWith(".png")){
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("user");
            //判断是否未登陆
            if(user == null && !url.endsWith("login")){
                res.sendRedirect("login");
                return;
            }
        }
        //交给过滤链处理
        chain.doFilter(req, res);
    }
}
```

现在，我们的页面已经基本完善为我们想要的样子了。

当然，可能跟着教程编写的项目比较乱，大家可以自己花费一点时间来重新编写一个Web应用程序，加深对之前讲解知识的理解。我们也会在之后安排一个编程实战进行深化练习。

# Listener

监听器并不是我们学习的重点内容，那么什么是监听器呢？

如果我们希望，在应用程序加载的时候，或是Session创建的时候，亦或是在Request对象创建的时候进行一些操作，那么这个时候，我们就可以使用监听器来实现。

![image-20220508005051849](image-20220508005051849.png)

默认为我们提供了很多类型的监听器，我们这里就演示一下监听Session的创建即可：

```java
@WebListener
public class TestListener implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("有一个Session被创建了");
    }
}
```

有关监听器相关内容，了解即可。

# 了解JSP页面与加载规则

前面我们已经完成了整个Web应用程序生命周期中所有内容的学习，我们已经完全了解，如何编写一个Web应用程序，并放在Tomcat上部署运行，以及如何控制浏览器发来的请求，通过Session+Filter实现用户登陆验证，通过Cookie实现自动登陆等操作。到目前为止，我们已经具备编写一个完整Web网站的能力。

在之前的教程中，我们的前端静态页面并没有与后端相结合，我们前端页面所需的数据全部需要单独向后端发起请求获取，并动态进行内容填充，这是一种典型的前后端分离写法，前端只负责要数据和显示数据，后端只负责处理数据和提供数据，这也是现在更流行的一种写法，让前端开发者和后端开发者各尽其责，更加专一，这才是我们所希望的开发模式。

JSP并不是我们需要重点学习的内容，因为它已经过时了，使用JSP会导致前后端严重耦合，因此这里只做了解即可。

JSP其实就是一种模板引擎，那么何谓模板引擎呢？顾名思义，它就是一个模板，而模板需要我们填入数据，才可以变成一个页面，也就是说，我们可以直接在前端页面中直接填写数据，填写后生成一个最终的HTML页面返回给前端。

首先我们来创建一个新的项目，项目创建成功后，删除Java目录下的内容，只留下默认创建的jsp文件，我们发现，在webapp目录中，存在一个`index.jsp`文件，现在我们直接运行项目，会直接访问这个JSP页面。

```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>
<br/>
<a href="hello-servlet">Hello Servlet</a>
</body>
</html>
```

但是我们并没有编写对应的Servlet来解析啊，那么为什么这个JSP页面会被加载呢？

实际上，我们一开始提到的两个Tomcat默认的Servlet中，一个是用于请求静态资源，还有一个就是用于处理jsp的：

```xml
<!-- The mappings for the JSP servlet -->
    <servlet-mapping>
        <servlet-name>jsp</servlet-name>
        <url-pattern>*.jsp</url-pattern>
        <url-pattern>*.jspx</url-pattern>
    </servlet-mapping>
```

那么，JSP和普通HTML页面有什么区别呢，我们发现它的语法和普通HTML页面几乎一致，我们可以直接在JSP中编写Java代码，并在页面加载的时候执行，我们随便找个地方插入：

```jsp
<%
    System.out.println("JSP页面被加载");
%>
```

我们发现，请求一次页面，页面就会加载一次，并执行我们填写的Java代码。也就是说，我们可以直接在此页面中执行Java代码来填充我们的数据，这样我们的页面就变成了一个动态页面，使用`<%=  %>`来填写一个值：

```jsp
<h1><%= new Date() %></h1>
```

现在访问我们的网站，每次都会创建一个新的Date对象，因此每次访问获取的时间都不一样，我们的网站已经算是一个动态的网站的了。

虽然这样在一定程度上上为我们提供了便利，但是这样的写法相当于整个页面既要编写前端代码，也要编写后端代码，随着项目的扩大，整个页面会显得难以阅读，并且现在都是前后端开发人员职责非常明确的，如果要编写JSP页面，那就必须要招一个既会前端也会后端的程序员，这样显然会导致不必要的开销。

那么我们来研究一下，为什么JSP页面能够在加载的时候执行Java代码呢？

首先我们将此项目打包，并在Tomcat服务端中运行，生成了一个文件夹并且可以正常访问。

我们现在看到`work`目录，我们发现这个里面多了一个`index_jsp.java`和`index_jsp.class`，那么这些东西是干嘛的呢，我们来反编译一下就啥都知道了：

```java
public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase  //继承自HttpServlet
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

 ...

  public void _jspService(final jakarta.servlet.http.HttpServletRequest request, final jakarta.servlet.http.HttpServletResponse response)
      throws java.io.IOException, jakarta.servlet.ServletException {

    if (!jakarta.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSP 只允许 GET、POST 或 HEAD。Jasper 还允许 OPTIONS");
        return;
      }
    }

    final jakarta.servlet.jsp.PageContext pageContext;
    jakarta.servlet.http.HttpSession session = null;
    final jakarta.servlet.ServletContext application;
    final jakarta.servlet.ServletConfig config;
    jakarta.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    jakarta.servlet.jsp.JspWriter _jspx_out = null;
    jakarta.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
             null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>JSP - Hello World</title>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("<h1>");
      out.print( new Date() );
      out.write("</h1>\n");

    System.out.println("JSP页面被加载");

      out.write("\n");
      out.write("<br/>\n");
      out.write("<a href=\"hello-servlet\">Hello Servlet</a>\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof jakarta.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
```

我们发现，它是继承自`HttpJspBase`类，我们可以反编译一下jasper.jar（它在tomcat的lib目录中）来看看:

```java
package org.apache.jasper.runtime;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.jsp.HttpJspPage;
import java.io.IOException;
import org.apache.jasper.compiler.Localizer;

public abstract class HttpJspBase extends HttpServlet implements HttpJspPage {
    private static final long serialVersionUID = 1L;

    protected HttpJspBase() {
    }

    public final void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.jspInit();
        this._jspInit();
    }

    public String getServletInfo() {
        return Localizer.getMessage("jsp.engine.info", new Object[]{"3.0"});
    }

    public final void destroy() {
        this.jspDestroy();
        this._jspDestroy();
    }

    public final void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this._jspService(request, response);
    }

    public void jspInit() {
    }

    public void _jspInit() {
    }

    public void jspDestroy() {
    }

    protected void _jspDestroy() {
    }

    public abstract void _jspService(HttpServletRequest var1, HttpServletResponse var2) throws ServletException, IOException;
}
```

实际上，Tomcat在加载JSP页面时，会将其动态转换为一个java类并编译为class进行加载，而生成的Java类，正是一个Servlet的子类，而页面的内容全部被编译为输出字符串，这便是JSP的加载原理，因此，JSP本质上依然是一个Servlet！

![image-20220508005117672](image-20220508005117672.png)

如果同学们感兴趣的话，可以查阅一下其他相关的教程，本教程不再讲解此技术。

***

# 使用Thymeleaf模板引擎

虽然JSP为我们带来了便捷，但是其缺点也是显而易见的，那么有没有一种既能实现模板，又能兼顾前后端分离的模板引擎呢？

**Thymeleaf**（百里香叶）是一个适用于Web和独立环境的现代化服务器端Java模板引擎，官方文档：https://www.thymeleaf.org/documentation.html。

那么它和JSP相比，好在哪里呢，我们来看官网给出的例子：

```html
<table>
  <thead>
    <tr>
      <th th:text="#{msgs.headers.name}">Name</th>
      <th th:text="#{msgs.headers.price}">Price</th>
    </tr>
  </thead>
  <tbody>
    <tr th:each="prod: ${allProducts}">
      <td th:text="${prod.name}">Oranges</td>
      <td th:text="${#numbers.formatDecimal(prod.price, 1, 2)}">0.99</td>
    </tr>
  </tbody>
</table>
```

我们可以在前端页面中填写占位符，而这些占位符的实际值则由后端进行提供，这样，我们就不用再像JSP那样前后端都写在一起了。

那么我们来创建一个例子感受一下，首先还是新建一个项目，注意，在创建时，勾选Thymeleaf依赖。

首先编写一个前端页面，名称为`test.html`，注意，是放在resource目录下，在html标签内部添加`xmlns:th="http://www.thymeleaf.org"`引入Thymeleaf定义的标签属性：

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <div th:text="${title}"></div>
</body>
</html>
```

接着我们编写一个Servlet作为默认页面：

```java
@WebServlet("/index")
public class HelloServlet extends HttpServlet {

    TemplateEngine engine;
    @Override
    public void init() throws ServletException {
        engine = new TemplateEngine();
        ClassLoaderTemplateResolver r = new ClassLoaderTemplateResolver();
        engine.setTemplateResolver(r);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Context context = new Context();
        context.setVariable("title", "我是标题");
        engine.process("test.html", context, resp.getWriter());
    }
}
```

我们发现，浏览器得到的页面，就是已经经过模板引擎解析好的页面，而我们的代码依然是后端处理数据，前端展示数据，因此使用Thymeleaf就能够使得当前Web应用程序的前后端划分更加清晰。

虽然Thymeleaf在一定程度上分离了前后端，但是其依然是在后台渲染HTML页面并发送给前端，并不是真正意义上的前后端分离。

## Thymeleaf语法基础

那么，如何使用Thymeleaf呢？

首先我们看看后端部分，我们需要通过`TemplateEngine`对象来将模板文件渲染为最终的HTML页面：

```java
TemplateEngine engine;
@Override
public void init() throws ServletException {
    engine = new TemplateEngine();
  	//设定模板解析器决定了从哪里获取模板文件，这里直接使用ClassLoaderTemplateResolver表示加载内部资源文件
    ClassLoaderTemplateResolver r = new ClassLoaderTemplateResolver();
    engine.setTemplateResolver(r);
}
```

由于此对象只需要创建一次，之后就可以一直使用了。接着我们来看如何使用模板引擎进行解析：

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    //创建上下文，上下文中包含了所有需要替换到模板中的内容
    Context context = new Context();
    context.setVariable("title", "<h1>我是标题</h1>");
    //通过此方法就可以直接解析模板并返回响应
    engine.process("test.html", context, resp.getWriter());
}
```

操作非常简单，只需要简单几步配置就可以实现模板的解析。接下来我们就可以在前端页面中通过上下文提供的内容，来将Java代码中的数据解析到前端页面。

接着我们来了解Thymeleaf如何为普通的标签添加内容，比如我们示例中编写的：

```html
<div th:text="${title}"></div>
```

我们使用了`th:text`来为当前标签指定内部文本，注意任何内容都会变成普通文本，即使传入了一个HTML代码，如果我希望向内部添加一个HTML文本呢？我们可以使用`th:utext`属性：

```html
<div th:utext="${title}"></div>
```

并且，传入的title属性，不仅仅只是一个字符串的值，而是一个字符串的引用，我们可以直接通过此引用调用相关的方法：

```html
<div th:text="${title.toLowerCase()}"></div>
```

这样看来，Thymeleaf既能保持JSP为我们带来的便捷，也能兼顾前后端代码的界限划分。

除了替换文本，它还支持替换一个元素的任意属性，我们发现，`th:`能够拼接几乎所有的属性，一旦使用`th:属性名称`，那么属性的值就可以通过后端提供了，比如我们现在想替换一个图片的链接：

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Context context = new Context();
    context.setVariable("url", "http://n.sinaimg.cn/sinakd20121/600/w1920h1080/20210727/a700-adf8480ff24057e04527bdfea789e788.jpg");
  	context.setVariable("alt", "图片就是加载不出来啊");
    engine.process("test.html", context, resp.getWriter());
}
```

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <img width="700" th:src="${url}" th:alt="${alt}">
</body>
</html>
```

现在访问我们的页面，就可以看到替换后的结果了。

Thymeleaf还可以进行一些算术运算，几乎Java中的运算它都可以支持：

```html
<div th:text="${value % 2}"></div>
```

同样的，它还支持三元运算：

```html
<div th:text="${value % 2 == 0 ? 'yyds' : 'lbwnb'}"></div>
```

多个属性也可以通过`+`进行拼接，就像Java中的字符串拼接一样，这里要注意一下，字符串不能直接写，要添加单引号：

```html
<div th:text="${name}+' 我是文本 '+${value}"></div>
```

## Thymeleaf流程控制语法

除了一些基本的操作，我们还可以使用Thymeleaf来处理流程控制语句，当然，不是直接编写Java代码的形式，而是添加一个属性即可。

首先我们来看if判断语句，如果if条件满足，则此标签留下，若if条件不满足，则此标签自动被移除：

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Context context = new Context();
    context.setVariable("eval", true);
    engine.process("test.html", context, resp.getWriter());
}
```

```html
<div th:if="${eval}">我是判断条件标签</div>
```

`th:if`会根据其中传入的值或是条件表达式的结果进行判断，只有满足的情况下，才会显示此标签，具体的判断规则如下：

- 如果值不是空的：
  - 如果值是布尔值并且为`true`。
  - 如果值是一个数字，并且是非零
  - 如果值是一个字符，并且是非零
  - 如果值是一个字符串，而不是“错误”、“关闭”或“否”
  - 如果值不是布尔值、数字、字符或字符串。
- 如果值为空，th:if将计算为false

`th:if`还有一个相反的属性`th:unless`，效果完全相反，这里就不演示了。

我们接着来看多分支条件判断，我们可以使用`th:switch`属性来实现：

```html
<div th:switch="${eval}">
    <div th:case="1">我是1</div>
    <div th:case="2">我是2</div>
    <div th:case="3">我是3</div>
</div>
```

只不过没有default属性，但是我们可以使用`th:case="*"`来代替：

```html
<div th:case="*">我是Default</div>
```

最后我们再来看看，它如何实现遍历，假如我们有一个存放书籍信息的List需要显示，那么如何快速生成一个列表呢？我们可以使用`th:each`来进行遍历操作：

```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Context context = new Context();
    context.setVariable("list", Arrays.asList("伞兵一号的故事", "倒一杯卡布奇诺", "玩游戏要啸着玩", "十七张牌前的电脑屏幕"));
    engine.process("test.html", context, resp.getWriter());
}
```

```html
<ul>
    <li th:each="title : ${list}" th:text="'《'+${title}+'》'"></li>
</ul>
```

`th:each`中需要填写 "单个元素名称 : ${列表}"，这样，所有的列表项都可以使用遍历的单个元素，只要使用了`th:each`，都会被循环添加。因此最后生成的结果为：

```html
<ul>
        <li>《伞兵一号的故事》</li>
        <li>《倒一杯卡布奇诺》</li>
        <li>《玩游戏要啸着玩》</li>
        <li>《十七张牌前的电脑屏幕》</li>
    </ul>
```

我们还可以获取当前循环的迭代状态，只需要在最后添加`iterStat`即可，从中可以获取很多信息，比如当前的顺序：

```html
<ul>
    <li th:each="title, iterStat : ${list}" th:text="${iterStat.index}+'.《'+${title}+'》'"></li>
</ul>
```

状态变量在`th:each`属性中定义，并包含以下数据：

- 当前*迭代索引*，以0开头。这是`index`属性。
- 当前*迭代索引*，以1开头。这是`count`属性。
- 迭代变量中的元素总量。这是`size`属性。
- 每个迭代的*迭代变量*。这是`current`属性。
- 当前迭代是偶数还是奇数。这些是`even/odd`布尔属性。
- 当前迭代是否是第一个迭代。这是`first`布尔属性。
- 当前迭代是否是最后一个迭代。这是`last`布尔属性。

通过了解了流程控制语法，现在我们就可以很轻松地使用Thymeleaf来快速替换页面中的内容了。

## Thymeleaf模板布局

在某些网页中，我们会发现，整个网站的页面，除了中间部分的内容会随着我们的页面跳转而变化外，有些部分是一直保持一个状态的，比如打开小破站，我们翻动评论或是切换视频分P的时候，变化的仅仅是对应区域的内容，实际上，其他地方的内容会无论内部页面如何跳转，都不会改变。

Thymeleaf就可以轻松实现这样的操作，我们只需要将不会改变的地方设定为模板布局，并在不同的页面中插入这些模板布局，就无需每个页面都去编写同样的内容了。现在我们来创建两个页面：

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <div class="head">
        <div>
            <h1>我是标题内容，每个页面都有</h1>
        </div>
        <hr>
    </div>
    <div class="body">
        <ul>
            <li th:each="title, iterStat : ${list}" th:text="${iterStat.index}+'.《'+${title}+'》'"></li>
        </ul>
    </div>
</body>
</html>
```

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <div class="head">
        <div>
            <h1>我是标题内容，每个页面都有</h1>
        </div>
        <hr>
    </div>
    <div class="body">
        <div>这个页面的样子是这样的</div>
    </div>
</body>
</html>
```

接着将模板引擎写成工具类的形式：

```java
public class ThymeleafUtil {

    private static final TemplateEngine engine;
    static  {
        engine = new TemplateEngine();
        ClassLoaderTemplateResolver r = new ClassLoaderTemplateResolver();
        engine.setTemplateResolver(r);
    }

    public static TemplateEngine getEngine() {
        return engine;
    }
}
```

```java
@WebServlet("/index2")
public class HelloServlet2 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Context context = new Context();
        ThymeleafUtil.getEngine().process("test2.html", context, resp.getWriter());
    }
}
```

现在就有两个Servlet分别对应两个页面了，但是这两个页面实际上是存在重复内容的，我们要做的就是将这些重复内容提取出来。

我们单独编写一个`head.html`来存放重复部分：

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="en">
<body>
    <div class="head" th:fragment="head-title">
        <div>
            <h1>我是标题内容，每个页面都有</h1>
        </div>
        <hr>
    </div>
</body>
</html>
```

现在，我们就可以直接将页面中的内容快速替换：

```html
<div th:include="head.html::head-title"></div>
<div class="body">
    <ul>
        <li th:each="title, iterStat : ${list}" th:text="${iterStat.index}+'.《'+${title}+'》'"></li>
    </ul>
</div>
```

我们可以使用`th:insert`和`th:replace`和`th:include`这三种方法来进行页面内容替换，那么`th:insert`和`th:replace`（和`th:include`，自3.0年以来不推荐）有什么区别？

- `th:insert`最简单：它只会插入指定的片段作为标签的主体。
- `th:replace`实际上将标签直接*替换*为指定的片段。
- `th:include`和`th:insert`相似，但它没有插入片段，而是只插入此片段*的内容*。

你以为这样就完了吗？它还支持参数传递，比如我们现在希望插入二级标题，并且由我们的子页面决定：

```html
<div class="head" th:fragment="head-title">
    <div>
        <h1>我是标题内容，每个页面都有</h1>
        <h2>我是二级标题</h2>
    </div>
    <hr>
</div>
```

稍加修改，就像JS那样添加一个参数名称：

```html
<div class="head" th:fragment="head-title(sub)">
    <div>
        <h1>我是标题内容，每个页面都有</h1>
        <h2 th:text="${sub}"></h2>
    </div>
    <hr>
</div>
```

现在直接在替换位置添加一个参数即可：

```html
<div th:include="head.html::head-title('这个是第1个页面的二级标题')"></div>
<div class="body">
    <ul>
        <li th:each="title, iterStat : ${list}" th:text="${iterStat.index}+'.《'+${title}+'》'"></li>
    </ul>
</div>
```

这样，不同的页面还有着各自的二级标题。

***

# 探讨Tomcat类加载机制

有关JavaWeb的内容，我们就聊到这里，在最后，我们还是来看一下Tomcat到底是如何加载和运行我们的Web应用程序的。

Tomcat服务器既然要同时运行多个Web应用程序，那么就必须要实现不同应用程序之间的隔离，也就是说，Tomcat需要分别去加载不同应用程序的类以及依赖，还必须保证应用程序之间的类无法相互访问，而传统的类加载机制无法做到这一点，同时每个应用程序都有自己的依赖，如果两个应用程序使用了同一个版本的同一个依赖，那么还有必要去重新加载吗，带着诸多问题，Tomcat服务器编写了一套自己的类加载机制。

![image-20220508005216097](image-20220508005216097.png)

首先我们要知道，Tomcat本身也是一个Java程序，它要做的是去动态加载我们编写的Web应用程序中的类，而要解决以上提到的一些问题，就出现了几个新的类加载器，我们来看看各个加载器的不同之处：

- Common ClassLoader：Tomcat最基本的类加载器，加载路径中的class可以被Tomcat容器本身以及各个Web应用程序访问。
- Catalina ClassLoader：Tomcat容器私有的类加载器，加载路径中的class对于Web应用程序不可见。
- Shared ClassLoader：各个Web应用程序共享的类加载器，加载路径中的class对于所有Web应用程序可见，但是对于Tomcat容器不可见。
- Webapp ClassLoader：各个Web应用程序私有的类加载器，加载路径中的class只对当前Web应用程序可见，每个Web应用程序都有一个自己的类加载器，此加载器可能存在多个实例。
- JasperLoader：JSP类加载器，每个JSP文件都有一个自己的类加载器，也就是说，此加载器可能会存在多个实例。

通过这样进行划分，就很好地解决了我们上面所提到的问题，但是我们发现，这样的类加载机制，破坏了JDK的`双亲委派机制`（在JavaSE阶段讲解过），比如Webapp ClassLoader，它只加载自己的class文件，它没有将类交给父类加载器进行加载，也就是说，我们可以随意创建和JDK同包同名的类，岂不是就出问题了？

难道Tomcat的开发团队没有考虑到这个问题吗？

![image-20220508005231782](image-20220508005231782.png)

实际上，WebAppClassLoader的加载机制是这样的：WebAppClassLoader 加载类的时候，绕开了 AppClassLoader，直接先使用 ExtClassLoader 来加载类。这样的话，如果定义了同包同名的类，就不会被加载，而如果是自己定义 的类，由于该类并不是JDK内部或是扩展类，所有不会被加载，而是再次回到WebAppClassLoader进行加载，如果还失败，再使用AppClassloader进行加载。
