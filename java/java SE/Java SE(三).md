# JDBC

JDBC (Java DataBase Connection) ，通过JAVA访问数据库



## 创建连接

### 导入jar包

File -> project Structure

最好导入到src的lib目录下，创建一个目录专门存放

![image-20220328213612515](assets/Java SE(三)/image-20220328213612515.png)



### 下载对应的java驱动包

- 官网下载：[MySQL :: MySQL Community Downloads](https://dev.mysql.com/downloads/)
- mvn下载：[Maven Repository: mysql » mysql-connector-java (mvnrepository.com)](https://mvnrepository.com/artifact/mysql/mysql-connector-java)



下载java版本

![image-20220328215333697](assets/Java SE(三)/image-20220328215333697.png)

下载平台依赖，选择tar下载即可

![image-20220328215433915](assets/Java SE(三)/image-20220328215433915.png)

导入包中的jar文件到依赖即可



### 初始化驱动

先导入对应版本的驱动包



`初始化驱动类`

```java
Class.forName("com.mysql.jdbc.Driver");	// mysql5

  Class.forName("com.mysql.cj.jdbc.Driver");	// mysql8
```

Class.forName是把这个类加载到JVM中，加载的时候，就会执行其中的静态，获取名称就会初始化，完成驱动初始化



`连接链接`

```java
// mysql5
jdbc:mysql://127.0.0.1:3306/how2java?characterEncoding=UTF-8","root", "admin"

// mysql8
jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "password")
```



### 建立连接

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/
 * @author easylee
 * @createTime 2022/3/28 21:37
 * @updateTime 2022/3/28 21:37
 * @Version 1.0.0
 */
public class Test01 {
    public static void main(String[] args) {
        //初始化驱动
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection c = DriverManager
                    .getConnection(
                            "jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC",
                            "root", "root");

            System.out.println("连接成功，获取连接对象： " + c);

        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}
```

## 使用配置文件创建连接

### src下配置文件

```java
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC
username=root
password=123456
```



### 获取配置文件

```java
package com.easylee.jdbc;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author easylee
 * @createTime 2022/3/28 21:37
 * @updateTime 2022/3/28 21:37
 * @Version 1.0.0
 */
public class Test01 {
    private static String driver = null;
    private static String url = null;
    private static String username = null;
    private static String password = null;

    static {
        try {
            // 1.加载配置文件 配置文件必须在src下
            InputStream in = Test01.class.getClassLoader().getResourceAsStream("db.properties");
            Properties properties = new Properties();
            properties.load(in);

            driver = properties.getProperty("driver");
            url = properties.getProperty("url");
            username = properties.getProperty("username");
            password = properties.getProperty("password");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```



## 执行语句

### Statement

Statement是用于执行SQL语句的，比如增加，删除

```java
public class Test01 {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection c = DriverManager
                    .getConnection(
                            "jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC",
                            "root", "root");
            
            // 创建sql语句对象
            // Statement是java.sql.Statement包下面的，不是驱动的包下面的
            Statement s = c.createStatement();
            System.out.println("获取 Statement对象： " + s);

        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}
```



### 执行SQL语句

s.execute执行sql语句

执行成功后，用navicat进行查看，明确插入成功

执行SQL语句之前要确保数据库中有表user的存在，如果没有，需要事先创建表

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 初始化jdbc mysql驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建mysql链接
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");

        // 创建执行sql语句的对象
        Statement s = c.createStatement();

        // 准备sql语句
        // 注意： 字符串要用单引号'
        String sql = "insert into user(name) values('easylee')";
        s.execute(sql);

        System.out.println("执行插入语句成功");
    }
}
```

### 执行批处理操作

当我们要执行很多条语句时，可以不用一次一次地提交，而是一口气全部交给数据库处理，这样会节省很多的时间。

```java
public static void main(String[] args) throws ClassNotFoundException {
    try (Connection connection = DriverManager.getConnection();
         Statement statement = connection.createStatement()){

        statement.addBatch("insert into user values ('f', 1234)");
        statement.addBatch("insert into user values ('e', 1234)");   //添加每一条批处理语句
        statement.executeBatch();   //一起执行

    }catch (SQLException e){
        e.printStackTrace();
    }
}
```

### 将查询结果映射为对象

既然我们现在可以从数据库中获取数据了，那么现在就可以将这些数据转换为一个类来进行操作，首先定义我们的实体类：

```java
public class Student {
    Integer sid;
    String name;
    String sex;

    public Student(Integer sid, String name, String sex) {
        this.sid = sid;
        this.name = name;
        this.sex = sex;
    }

    public void say(){
        System.out.println("我叫："+name+"，学号为："+sid+"，我的性别是："+sex);
    }
}
```

现在我们来进行一个转换：

```java
while (set.next()){
    // 创建实体对象
    Student student = new Student(set.getInt(1), set.getString(2), set.getString(3));
    student.say();
}
```

**注意：**列的下标是从1开始的。

我们也可以利用反射机制来将查询结果映射为对象，使用反射的好处是，无论什么类型都可以通过我们的方法来进行实体类型映射：

```java
private static <T> T convert(ResultSet set, Class<T> clazz){
    try {
        Constructor<T> constructor = clazz.getConstructor(clazz.getConstructors()[0].getParameterTypes());   //默认获取第一个构造方法
        Class<?>[] param = constructor.getParameterTypes();  //获取参数列表
        Object[] object = new Object[param.length];  //存放参数
        for (int i = 0; i < param.length; i++) {   //是从1开始的
            object[i] = set.getObject(i+1);
            if(object[i].getClass() != param[i])
                throw new SQLException("错误的类型转换："+object[i].getClass()+" -> "+param[i]);
        }
        return constructor.newInstance(object);
    } catch (ReflectiveOperationException | SQLException e) {
        e.printStackTrace();
        return null;
    }
}
```

现在我们就可以通过我们的方法来将查询结果转换为一个对象了：

```java
while (set.next()){
    Student student = convert(set, Student.class);
    if(student != null) student.say();
}
```

实际上，在后面我们会学习Mybatis框架，它对JDBC进行了深层次的封装，而它就进行类似上面反射的操作来便于我们对数据库数据与实体类的转换。

### 关闭连接

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 初始化jdbc mysql驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建mysql链接
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");

        // 创建执行sql语句的对象
        Statement s = c.createStatement();

        // 准备sql语句
        // 注意： 字符串要用单引号'
        String sql = "insert into user(name) values('easylee')";
        s.execute(sql);
        System.out.println("执行插入语句成功");
        
        if (s != null) {
            // 先关闭Statement对象
            try {
                s.close();
            } catch (SQLException e) {}
            // 再关闭连接
            try {
                c.close();
            } catch (SQLException e) {}
        }
    }
}
```



### 预编译PreparedStatement执行语句

PreparedStatement天然可以防止sql注入，因为PreparedStatement会自动在输入的sql语句上再加入一层""，将之变为字符串

和 Statement一样，PreparedStatement也是用来执行sql语句的

与创建Statement不同的是，需要根据sql语句创建PreparedStatement

除此之外，还能够通过设置参数，指定相应的值，而不是Statement那样使用字符串拼接

注： 这是JAVA里唯二的基1的地方，另一个是查询语句中的ResultSet也是基1的。



### 使用PreparedStatement

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 初始化jdbc mysql驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建mysql链接
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");

        String sql = "insert into user values(null,?)";

        PreparedStatement ps = c.prepareStatement(sql);

        // 设置参数
        ps.setString(1, "提莫");
        // 执行
        ps.execute();

        if (ps != null) {
            // 先关闭Statement对象
            try {
                ps.close();
            } catch (SQLException e) {}
            // 再关闭连接
            try {
                c.close();
            } catch (SQLException e) {}
        }
    }
}
```

### PreparedStatement的优势

- Statement 需要进行字符串拼接，可读性和维护性比较差，PreparedStatement 使用参数设置，可读性好，不易犯错
- PreparedStatement有预编译机制，性能比Statement更快代码比较复制代码，比如一条语句需要执行100次，预编译会只传上面带？参数的语句一次，然后后面只需要传参数给这个语句解析即可，Statement则需要每次传输一整条语句
- 可以防止SQL注入式攻击，Statement可以传进命令，因为是包含在""里面，没有做处理，而PreparedStatement，因为是传参数，调用的是setString，setInt这种命令，这个只能接收String和int这种特定的类型，里面肯定包含不了命令



## 执行命令execute与executeUpdate的区别

### 相同点

execute与executeUpdate的相同点：都可以执行增加，删除，修改



### 不同点

- execute可以执行查询语句然后通过getResultSet，把结果集取出来
- executeUpdate不能执行查询语句
- execute返回`boolean`类型，true表示执行的是查询语句，false表示执行的是insert,delete,update等等
- executeUpdate返回的是`int`，表示有多少条数据受到了影响



## 增删改查

### 增加、删除、修改

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 初始化jdbc mysql驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建mysql链接
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");

        // 创建执行sql语句的对象
        Statement s = c.createStatement();

        // 增加
        String sql = "insert into user(name) values('easylee')";
        s.execute(sql);
        System.out.println("执行插入语句成功");

        // 删除
        String sql1 = "delete from user where id = 1";
        s.execute(sql1);
        System.out.println("执行删除语句成功");

        // 修改
        String sql2 = "update user set name='nihao' where id =2";
        s.execute(sql2);
        System.out.println("执行修改语句成功");

        if (s != null) {
            // 先关闭Statement对象
            try {
                s.close();
            } catch (SQLException e) {}
            // 再关闭连接
            try {
                c.close();
            } catch (SQLException e) {}
        }
    }
}
```



### 查询

executeQuery 执行SQL查询语句

注意java api中在executeQuery和预编译PreparedStatement时，获取的语句是从1开始排序的，比如第2列，下标就是2

```java
public class Test01 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 初始化jdbc mysql驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建mysql链接
        Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");

        // 创建执行sql语句的对象
        Statement s = c.createStatement();

        String sql = "select * from user";

        // 执行查询语句，并把结果集返回给ResultSet
        ResultSet rs = s.executeQuery(sql);
      	// 一行一行的获取查询的记录
        while (rs.next()) {
            int id = rs.getInt("id");// 可以使用字段名
            String name = rs.getString(2);// 也可以使用字段的顺序
            System.out.printf("%d\t%s\t%n", id, name);
        }

        if (s != null) {
            // 先关闭Statement对象
            try {
                s.close();
            } catch (SQLException e) {}
            // 再关闭连接
            try {
                c.close();
            } catch (SQLException e) {}
        }
    }
}
```



## JDBC事务

将一系列sql语句一直执行，其中有一条出错，所有语句都不执行，防止出错

PreparedStatement是不支持事务的，都会直接执行，只有createStatement支持事务

MYSQL 表的类型必须是INNODB才支持事务



### 不使用事务的情况

没有事务的前提下
假设业务操作是：加血，减血各做一次，结束后，英雄的血量不变

减血的SQL不小心写错写成了 updata(而非update)
那么最后结果是血量增加了，而非期望的不变

```java
//加血的SQL
String sql1 = "update hero set hp = hp +1 where id = 22";
s.execute(sql1);

//减血的SQL
//不小心写错写成了 updata(而非update)

String sql2 = "updata hero set hp = hp -1 where id = 22";
s.execute(sql2);
```



### 使用事务

必须两个都执行成功才提交

通过 c.setAutoCommit(false);关闭自动提交，不关闭，每次执行s.execute(sql);就提交了这条语句了
使用 c.commit();进行手动提交

```java
c.setAutoCommit(false);

// 加血的SQL
String sql1 = "update hero set hp = hp +1 where id = 22";
s.execute(sql1);

// 减血的SQL
// 不小心写错写成了 updata(而非update)

String sql2 = "updata hero set hp = hp -1 where id = 22";
s.execute(sql2);

// 手动提交
c.commit();
```



## ORM

对象和关系数据库的映射，一个对象，对应数据库里面的一条记录

```java
public class User {
    //增加id属性
    public int id;
    public String name;
}
```

```java
String sql = "select * from hero where id = " + id;
   
ResultSet rs = s.executeQuery(sql);

// 因为id是唯一的，ResultSet最多只能有一条记录
// 所以使用if代替while
if (rs.next()) {
  hero = new Hero();
  String name = rs.getString(2);
  float hp = rs.getFloat("hp");
  int damage = rs.getInt(4);
  hero.name = name;
  hero.hp = hp;
  hero.damage = damage;
  hero.id = id;
}
```

就是简单的将这条语句取出来，然后一一对应而已



## DAO

访问数据对象，就是专门用来对应数据库数据的对象，包含了增删改查等方法封装而已



### DAO接口

```java
public interface DAO{
    //增加
    public void add(Hero hero);
    //修改
    public void update(Hero hero);
    //删除
    public void delete(int id);
    //获取
    public Hero get(int id);
    //查询
    public List<Hero> list();
    //分页查询
    public List<Hero> list(int start, int count);
}
```



### HeroDAO

设计类HeroDAO，实现接口DAO

把驱动的初始化放在了构造方法HeroDAO里

```java
public class HeroDAO implements DAO{
  
  	// 构造方法初始化驱动
    public HeroDAO() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
  	
  	// 返回连接
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");
    }
  
    public int getTotal() {
        int total = 0;
        try (Connection c = getConnection(); Statement s = c.createStatement();) {
  
            String sql = "select count(*) from hero";
  
            ResultSet rs = s.executeQuery(sql);
            while (rs.next()) {
                total = rs.getInt(1);
            }
  
            System.out.println("total:" + total);
  
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
        return total;
    }
  
    public void add(Hero hero) {
        String sql = "insert into hero values(null,?,?,?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql);) {
  
            ps.setString(1, hero.name);
            ps.setFloat(2, hero.hp);
            ps.setInt(3, hero.damage);
  
            ps.execute();
  
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int id = rs.getInt(1);
                hero.id = id;
            }
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
    }
  
    public void update(Hero hero) {
  
        String sql = "update hero set name= ?, hp = ? , damage = ? where id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql);) {
  
            ps.setString(1, hero.name);
            ps.setFloat(2, hero.hp);
            ps.setInt(3, hero.damage);
            ps.setInt(4, hero.id);
  
            ps.execute();
  
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
  
    }
  
    public void delete(int id) {
  
        try (Connection c = getConnection(); Statement s = c.createStatement();) {
  
            String sql = "delete from hero where id = " + id;
  
            s.execute(sql);
  
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
    }
  
    public Hero get(int id) {
        Hero hero = null;
  
        try (Connection c = getConnection(); Statement s = c.createStatement();) {
  
            String sql = "select * from hero where id = " + id;
  
            ResultSet rs = s.executeQuery(sql);
  
            if (rs.next()) {
                hero = new Hero();
                String name = rs.getString(2);
                float hp = rs.getFloat("hp");
                int damage = rs.getInt(4);
                hero.name = name;
                hero.hp = hp;
                hero.damage = damage;
                hero.id = id;
            }
  
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
        return hero;
    }
  
    public List<Hero> list() {
        return list(0, Short.MAX_VALUE);
    }
  
    public List<Hero> list(int start, int count) {
        List<Hero> heros = new ArrayList<Hero>();
  
        String sql = "select * from hero order by id desc limit ?,? ";
  
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql);) {
  
            ps.setInt(1, start);
            ps.setInt(2, count);
  
            ResultSet rs = ps.executeQuery();
  
            while (rs.next()) {
                Hero hero = new Hero();
                int id = rs.getInt(1);
                String name = rs.getString(2);
                float hp = rs.getFloat("hp");
                int damage = rs.getInt(4);
                hero.id = id;
                hero.name = name;
                hero.hp = hp;
                hero.damage = damage;
                heros.add(hero);
            }
        } catch (SQLException e) {
  
            e.printStackTrace();
        }
        return heros;
    }
  
}
```



## 数据库连接池

与线程池类似的，数据库也有一个数据库连接池。 不过他们的实现思路是不一样的。



### 数据库连接池原理-传统方式

当有多个线程，每个线程都需要连接数据库执行SQL语句的话，那么每个线程都会创建一个连接，并且在使用完毕后，关闭连接。

创建连接和关闭连接的过程也是比较消耗时间的，当多线程并发的时候，系统就会变得很卡顿。

同时，一个数据库同时支持的连接总数也是有限的，如果多线程并发量很大，那么数据库连接的总数就会被消耗光，后续线程发起的数据库连接就会失败。

![image-20220328231946315](assets/Java SE(三)/image-20220328231946315.png)



### 数据库连接池原理-使用池

与传统方式不同，连接池在使用之前，就会创建好一定数量的连接。

如果有任何线程需要使用连接，那么就从连接池里面借用，而不是自己重新创建.
使用完毕后，又把这个连接归还给连接池供下一次或者其他线程使用。

倘若发生多线程并发情况，连接池里的连接被借用光了，那么其他线程就

会临时等待，直到有连接被归还回来，再继续使用。

整个过程，这些连接都不会被关闭，而是不断的被循环使用，从而节约了

启动和关闭连接的时间。



### ConnectionPool构造方法和初始化

ConnectionPool() 构造方法约定了这个连接池一共有多少连接

在init() 初始化方法中，创建了size条连接。 注意，这里不能使用try-with-resource这种自动关闭连接的方式，因为连接恰恰需要保持不关闭状态，供后续循环使用

getConnection， 判断是否为空，如果是空的就wait等待，否则就借用一条连接出去

returnConnection， 在使用完毕后，归还这个连接到连接池，并且在归还完毕后，调用notifyAll，通知那些等待的线程，有新的连接可以借用了。

```JAVA
public class ConnectionPool {
  
  	// 存放连接的集合，使用和返回连接都从这个集合中取
    List<Connection> cs = new ArrayList<Connection>();
  	
  	// 连接数量
    int size;
  	
  	// 这个ConnectionPool连接池对象只能new一次，然后每次调用这个对象的具体操作数据库的方法，都要去判断是否还有连接，也就是getConnection获取连接的时候判断，为空都在工作中，那就没法使用连接，也就没法操作数据库及其方法了
    public ConnectionPool(int size) {
        this.size = size;
        init();
    }
  
    public void init() {
        //这里恰恰不能使用try-with-resource的方式，因为这些连接都需要是"活"的，不要被自动关闭了
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            for (int i = 0; i < size; i++) {
                Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false&serverTimezone=UTC", "root", "root");
              // 添加到连接池集合中
                cs.add(c);
            }
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
  
  	// 获取连接
    public synchronized Connection getConnection() {
      	// 如果连接都在使用中，让调用连接池的对象等待
        while (cs.isEmpty()) {
            try {
              	// 这里的this也就是连接池本身，也就是说自身的可使用数量为空，就让这个连接池对象等待，不能再使用连接，操作数据库了
                this.wait();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        Connection c = cs.remove(0);
        return c;
    }
  
  	// 返回连接
    public synchronized void returnConnection(Connection c) {
        cs.add(c);
      	// 通知等待中的线程，可以使用连接池中的连接了，因为当所有的连接都使用完了的时候，这里返回了一个，就可以通知来使用这个了
        this.notifyAll();
    }
  
}
```



# 图形界面

GUI是java的图形操作界面



## 简单例子

JFrame是GUI中的容器

JButton是最常见的组件- 按钮

注意：f.setVisible(true); 会对所有的组件进行渲染，所以一定要放在最后面

```java
public class TestGui {
    public static void main(String[] args) {
        // 创建主窗体
        JFrame f = new JFrame("LoL");

        // 主窗体设置大小
        f.setSize(400, 300);

        // 主窗体设置位置，基于屏幕左上角
        f.setLocation(200, 200);

        // 主窗体中的组件设置为绝对定位，可以设置其它的布局方式，null即为绝对定位
        f.setLayout(null);

        // 按钮组件
        JButton b = new JButton("一键秒对方基地挂");

        // 同时设置组件的大小和位置
        b.setBounds(50, 50, 280, 30);

        // 把按钮加入到主窗体中
        f.add(b);

        // 关闭窗体的时候，退出程序
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 让窗体变得可见
        f.setVisible(true);
    }
}
```

### 

### 练习-在上次关闭位置启动窗口 

比如这次使用这个窗口，导致窗口被移动到了右下角。 关闭这个窗口，下一次再启动的时候，就会自动出现在右下角。

`思路提示`：
启动一个线程，每个100毫秒读取当前的位置信息，保存在文件中，比如location.txt文件。

启动的时候，从这个文件中读取位置信息，如果是空的，就使用默认位置，如果不是空的，就把位置信息设置在窗口上。

读取位置信息的办法： f.getX() 读取横坐标信息，f.getY()读取纵坐标信息。

`注：`

这个练习要求使用多线程来完成。 

还有另一个思路来完成，就是使用监听器，因为刚开始学习GUI，还没有掌握监听器的使用，所以暂时使用多线程来完成这个功能。

```java
public class TestGui {
    public static void main(String[] args) {
        // 创建主窗体
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);

        // 先启动写入位置的线程
        SavePosition savePosition = new SavePosition(f);
        new Thread(savePosition).start();
        SavePosition.Point point = savePosition.read();

        f.setLocation(point.x, point.y);
        f.setLayout(null);

        // 关闭窗体的时候，退出程序
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 让窗体变得可见
         f.setVisible(true);
    }
}
```

```java
public class SavePosition implements Runnable {
    File f =new File("src/file/location.txt");
    private JFrame jf;

    SavePosition(JFrame f) {
        this.jf = f;
    }

    @Override
    public void run() {
        while(true) {
            // 每隔一秒一直写入坐标
            try (
                    FileOutputStream fos  = new FileOutputStream(f);
                    DataOutputStream dos =new DataOutputStream(fos);
            )
            {
                // 写入特定的格式化的内容
                dos.writeInt(jf.getX());
                dos.writeInt(jf.getY());
            } catch (IOException e) {
                e.printStackTrace();
            }

            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    // 用于存放对应的坐标
    class Point {
        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
        int x;
        int y;
    }
    public Point read() {
        try (
            // 创建文件输入流
            FileInputStream fis  = new FileInputStream(f);
            // 转为数据输入流
            DataInputStream dis =new DataInputStream(fis);
        ){
            int x = dis.readInt();
            int y = dis.readInt();
            return new Point(x, y);
        } catch (IOException e) {
            return new Point(200, 200);
        }
    }
}
```



## 事件监听

### 按钮监听

创建一个匿名类实现ActionListener接口，当按钮被点击时，actionPerformed方法就会被调用

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        JButton b = new JButton("触发事件");
        b.setBounds(100,100,100,100);

        b.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("按钮被点击");
            }
        });

        jf.add(b);

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



### 键盘监听

键盘监听器： KeyListener

keyPressed 代表 键被按下

keyReleased 代表 键被弹起

keyTyped 代表 一个按下弹起的组合动作

KeyEvent.getKeyCode() 可以获取当前点下了哪个键

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        // 键盘监听器
        jf.addKeyListener(new KeyListener() {
            @Override
            public void keyTyped(KeyEvent e) {
                // 一直都是返回0，因为keyType按下弹起事件无法获取，只能获取设置的常量VK_UNDEFINED值
                System.out.println("你按下了" + e.getKeyCode() + "键");
            }

            @Override
            public void keyPressed(KeyEvent e) {
                System.out.println("你按下了" + e.getKeyCode() + "键");
            }

            @Override
            public void keyReleased(KeyEvent e) {
            }
        });

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



### 鼠标监听

MouseListener 鼠标监听器
mouseReleased 鼠标释放，一直按住松开
mousePressed 鼠标按下，一直按住
mouseExited 鼠标退出，退出面板区域
mouseEntered 鼠标进入，进入面板区域
mouseClicked 鼠标点击，单击

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        // 鼠标监听器
        jf.addMouseListener(new MouseListener() {
            @Override
            public void mouseClicked(MouseEvent e) {
                System.out.println("鼠标点击");
            }

            @Override
            public void mousePressed(MouseEvent e) {
                System.out.println("鼠标按下");
            }

            @Override
            public void mouseReleased(MouseEvent e) {
                System.out.println("鼠标释放");
            }

            @Override
            public void mouseEntered(MouseEvent e) {
                System.out.println("鼠标进入");
            }

            @Override
            public void mouseExited(MouseEvent e) {
                System.out.println("鼠标退出");
            }
        });

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



### 鼠标监听适配器

MouseAdapter 鼠标监听适配器
一般说来在写监听器的时候，会实现MouseListener。
但是MouseListener里面有很多方法实际上都没有用到，比如mouseReleased ，mousePressed，mouseExited等等。
这个时候就可以使用 鼠标监听适配器，MouseAdapter 只需要重写必要的方法即可。

`适配器简单来说和对应的接口方法都是一样的，但是是一个类，并且这个类全部实现了对应的接口，创建这个类时就不需要实现全部的方法了，只需要重写需要的方法`

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        // 鼠标监听适配器
        jf.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                System.out.println("鼠标点击");
            }
        });

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



### 练习

练习1：点击切换按钮上文字

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        JButton jButton = new JButton("测试文字");
        jButton.setBounds(100,100,100,100);
        jf.add(jButton);

        // 鼠标监听适配器
        jButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                jButton.setText("测试文字1");
            }
        });

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



练习2：练习-上下左右移动

提示：keyCode与方向的对应关系
38 上 40 下 37 左 39 右

```java
public class Listen {
    public static void main(String[] args) {
        // 创建面板相关
        JFrame jf = new JFrame();
        jf.setSize(400, 300);
        jf.setLocation(300, 300);
        jf.setLayout(null);

        JButton jButton = new JButton("测试文字");
        jButton.setBounds(100,100,100,100);
        jf.add(jButton);

        // 鼠标监听适配器
        jButton.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                //步长
                int step = 10;
                if (e.getKeyCode() == 38) {
                    // 图片向上移动 （x坐标不变，y坐标减少）
                    jButton.setLocation(jButton.getX() , jButton.getY()- step);
                }
                if (e.getKeyCode() == 40) {
                    // 图片向下移动 （x坐标不变，y坐标增加）
                    jButton.setLocation(jButton.getX() , jButton.getY()+ step);
                }
                if (e.getKeyCode() == 37) {
                    // 图片向左移动 （y坐标不变，x坐标减少）
                    jButton.setLocation(jButton.getX() - step, jButton.getY());
                }
                if (e.getKeyCode() == 39) {
                    // 图片向右移动 （y坐标不变，x坐标增加）
                    jButton.setLocation(jButton.getX() + step, jButton.getY());
                }
            }
        });

        // 退出时关闭JFrame
        jf.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 使面板可见，一定要在所有组件加入后设置
        jf.setVisible(true);
    }
}
```



## 容器

java的图形界面中，容器是用来存放 按钮，输入框等组件的。

窗体型容器有两个，一个是JFrame,一个是JDialog



### JFrame

JFrame是最常用的窗体型容器，默认情况下，在右上角有最大化最小化按钮

```java
public class TestGUI {
    public static void main(String[] args) {
         
        //普通的窗体，带最大和最小化按钮
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);
 
        f.add(b);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### JDialog

JDialog也是窗体型容器，右上角没有最大和最小化按钮

```java
public class TestGUI {
    public static void main(String[] args) {
         
        //普通的窗体，带最大和最小化按钮，而对话框却不带
        JDialog d = new JDialog();
        d.setTitle("LOL");
        d.setSize(400, 300);
        d.setLocation(200, 200);
        d.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);
 
        d.add(b);
 
        d.setVisible(true);
    }
}
```



### 模态JDialog

当一个对话框被设置为模态的时候，其背后的父窗体，是不能被激活的，除非该对话框被关闭，也就是获取不到焦点

```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("外部窗体");
        f.setSize(800, 600);
        f.setLocation(100, 100);
 
        // 根据外部窗体实例化JDialog
        JDialog d = new JDialog(f);
        // 设置为模态
        d.setModal(true);
 
        d.setTitle("模态的对话框");
        d.setSize(400, 300);
        d.setLocation(200, 200);
        d.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);
        d.add(b);
 
        f.setVisible(true);
        d.setVisible(true);
    }
}
```



### 窗体大小不可变化

通过调用方法 setResizable(false); 做到窗体大小不可变化



### 练习：模态与大小变化

首先设计一个JFrame,上面有一个按钮，文字是 "打开一个模态窗口"。

点击该按钮后，随即打开一个模态窗口。

在这个模态窗口中有一个按钮，文本是 "锁定大小", 点击后，这个模态窗口的大小就被锁定住，不能改变。 再次点击，就回复能够改变大小

```java
public class TestGui {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setSize(400,400);
        jFrame.setLocation(200,200);
        jFrame.setLayout(null);

        // 设置打开模态窗口按钮
        JButton jButton = new JButton("打开模态窗口");
        jButton.setBounds(100,100,100,100);
        jFrame.add(jButton);

        jFrame.setVisible(true);

        // 设置点击事件，这里设置按钮触发和鼠标点击事件是一样的，因为都是添加在按钮上
        // 而按钮则只有点击这个时间而已
        jButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                // 创建模态窗口
                JDialog jDialog = new JDialog();
                jDialog.setLocation(200,200);
                jDialog.setSize(300,300);
                jDialog.setModal(true);

                // 创建模态窗口按钮
                JButton jButton1 = new JButton("锁定大小");
                jButton1.setBounds(100,100,100,100);
                jDialog.add(jButton1);

                // 按钮触发事件
                jButton1.addActionListener(new ActionListener() {
                    boolean  resizable = false;
                    @Override
                    public void actionPerformed(ActionEvent e) {
                        jDialog.setResizable(resizable);
                        resizable = !resizable;
                        jButton1.setText(resizable?"解锁大小":"锁定大小");
                    }
                });

                jDialog.setVisible(true);

            }
        });

        // 关闭窗口
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}
```



## 布局器

布局器是用在容器上的。 用来决定容器上的组件摆放的位置和大小



### 绝对定位

绝对定位就是指不使用布局器，组件的位置和大小需要单独指定

```java
// 设置布局器为null，即进行绝对定位，容器上的组件都需要指定位置和大小
f.setLayout(null);
```



### FlowLayout

设置布局器为FlowLayout,顺序布局器
容器上的组件水平摆放
加入到容器即可，无需单独指定大小和位置

```java
public class TestGui {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        // 设置布局器为FlowLayerout
        // 容器上的组件水平摆放
        f.setLayout(new FlowLayout());

        JButton b1 = new JButton("英雄1");
        JButton b2 = new JButton("英雄2");
        JButton b3 = new JButton("英雄3");

        // 加入到容器即可，无需单独指定大小和位置
        f.add(b1);
        f.add(b2);
        f.add(b3);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### BorderLayout

设置布局器为BorderLayout
容器上的组件按照上北 下南 左西 右东 中的顺序摆放

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        // 设置布局器为BorderLayerout
        // 容器上的组件按照上北下南左西右东中的顺序摆放
        f.setLayout(new BorderLayout());
 
        JButton b1 = new JButton("洪七");
        JButton b2 = new JButton("段智兴");
        JButton b3 = new JButton("欧阳锋");
        JButton b4 = new JButton("黄药师");
        JButton b5 = new JButton("周伯通");
 
        // 加入到容器的时候，需要指定位置
        f.add(b1, BorderLayout.NORTH);
        f.add(b2, BorderLayout.SOUTH);
        f.add(b3, BorderLayout.WEST);
        f.add(b4, BorderLayout.EAST);
        f.add(b5, BorderLayout.CENTER);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### GridLayout

GridLayout，即网格布局器，使用表格布局

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        // 设置布局器为GridLayerout，即网格布局器
        // 该GridLayerout的构造方法表示该网格是2行3列
        f.setLayout(new GridLayout(2, 3));
 
        JButton b1 = new JButton("洪七");
        JButton b2 = new JButton("段智兴");
        JButton b3 = new JButton("欧阳锋");
        JButton b4 = new JButton("黄药师");
        JButton b5 = new JButton("周伯通");
 
        f.add(b1);
        f.add(b2);
        f.add(b3);
        f.add(b4);
        f.add(b5);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### setPreferredSize

设置布局期内组件大小

即便 使用 布局器 ，也可以 通过setPreferredSize，向布局器建议该组件显示的大小.

只对部分布局器起作用，比如FlowLayout可以起作用

比如GridLayout就不起作用，因为网格布局器必须对齐

```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new FlowLayout());

        JButton b1 = new JButton("英雄1");
        JButton b2 = new JButton("英雄2");
        JButton b3 = new JButton("英雄3");

        // 即便 使用 布局器 ，也可以 通过setPreferredSize，向布局器建议该组件显示的大小
        // new Dimension返回一个针对组件大小的对象
        b3.setPreferredSize(new Dimension(180, 40));

        f.add(b1);
        f.add(b2);
        f.add(b3);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### CardLayout

CardLayout需要用到面板，JComboBox这些内容暂时还没学的内容



### 练习-计算器上的按钮

![练习-计算器上的按钮](assets/Java SE(三)/2671.png)

```java
public class TestGUI {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setSize(new Dimension(400,500));
        jFrame.setLocation(300,300);

        // 创建布局期 5行4列，按照加入顺序从左到右从上到下加入
        jFrame.setLayout(new GridLayout(5,4));

        // 创建按钮 网格排序方式是
        jFrame.add(new JButton("7"));
        jFrame.add(new JButton("8"));
        jFrame.add(new JButton("9"));
        jFrame.add(new JButton("/"));
        jFrame.add(new JButton("sq"));

        jFrame.add(new JButton("4"));
        jFrame.add(new JButton("5"));
        jFrame.add(new JButton("6"));
        jFrame.add(new JButton("*"));
        jFrame.add(new JButton("%"));

        jFrame.add(new JButton("4"));
        jFrame.add(new JButton("5"));
        jFrame.add(new JButton("6"));
        jFrame.add(new JButton("*"));
        jFrame.add(new JButton("%"));

        jFrame.add(new JButton("4"));
        jFrame.add(new JButton("5"));
        jFrame.add(new JButton("6"));
        jFrame.add(new JButton("*"));
        jFrame.add(new JButton("%"));

        jFrame.add(new JButton("4"));
        jFrame.add(new JButton("5"));
        jFrame.add(new JButton("6"));
        jFrame.add(new JButton("*"));
        jFrame.add(new JButton("%"));

        jFrame.setVisible(true);

        // 关闭窗口
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}
```



## 组件

JAVA的图形界面下有两组控件，一组是awt,一组是swing。
一般都是使用swing



### awt和swing区别

- awt是基于本地方法的C/C++程序，其运行速度比较快，swing是基于awt的Java程序，其运行速度比较慢

- AWT的控件在不同的平台可能表现不同，而Swing在所有平台表现一致。

- AWT和Swing的实现原理不同。

- AWT的图形函数与操作系统提供的图形函数有着一一对应的关系，而Swing 不仅提供了AWT 的所有功能，还用纯粹的Java代码对AWT的功能进行了大幅度的扩充。

- awt是抽象窗口组件工具包，是 java 最早的用于编写图形节目应用程序的开发包；

  但swing是为了解决awt存在的问题而新开发的包，它以awt为基础的。

![img](assets/Java SE(三)/b8014a90f603738d18ca716dbe1bb051f919ecf9.jpeg)

在实际应用中，应该使用AWT还是Swing取决于应用程序所部署的平台类型。

对于一个嵌入式应用，目标平台的硬件资源往往非常有限，而应用程序的运行速度又是项目中至关重要的因素。

在这种矛盾的情况下，简单而高效的AWT当然成了嵌入式Java的第一选择。

在普通的基于PC或者是工作站的标准Java应用中，硬件资源对应用程序所造成的限制往往不是项目中的关键因素。

所以在标准版的Java中则提倡使用Swing， 即`通过牺牲速度来实现应用程序的功能`



### 标签

Label用于显示文字



```java
public class TestGUI {
    public static void main(String[] args) {
          
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
        JLabel l = new JLabel("LOL文字");
        //文字颜色
        l.setForeground(Color.red);
        l.setBounds(50, 50, 280, 30);
  
        f.add(l);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  
        f.setVisible(true);
    }
}
```



### 使用JLabel显示图片

java GUI 显示图片是通过在label上设置图标实现的
注： 这里的图片路径是e:/project/j2se/shana.png，所以要确保这里有图片，不然不会显示
注： 图片的后缀名和真实格式，必须保持一致，否则很有可能无法正常显示。 什么意思呢？就是文件本来是jpg的，但是仅仅是把后缀名修改成了png,那么会导致显示失败。

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 200);
        f.setLayout(null);
 
        JLabel l = new JLabel();
 
        //根据图片创建ImageIcon对象
        ImageIcon i = new ImageIcon("e:/project/j2se/shana.png");
        //设置ImageIcon
        l.setIcon(i);
        //label的大小设置为ImageIcon,否则显示不完整
        l.setBounds(50, 50, i.getIconWidth(), i.getIconHeight());
 
        f.add(l);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 按钮

JButton 普通按钮

```java
public class TestGUI {
    public static void main(String[] args) {
          
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);
  
        f.add(b);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  
        f.setVisible(true);
    }
}
```



### 复选框

JCheckBox 复选框

使用isSelected来获取是否选中了

```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 200);
        f.setLayout(null);
        JCheckBox bCheckBox = new JCheckBox("物理英雄");
        bCheckBox.setBounds(50, 50, 130, 30);
        //设置 为 默认被选中
        bCheckBox.setSelected(true);
        JCheckBox bCheckBox2 = new JCheckBox("魔法 英雄");
        bCheckBox2.setBounds(50, 100, 130, 30);
        //判断 是否 被 选中
        System.out.println(bCheckBox2.isSelected());

        f.add(bCheckBox);
        f.add(bCheckBox2);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### 单选框

JRadioButton 单选框

使用isSelected来获取是否选中了

在这个例子里，两个单选框可以被同时选中，为了实现只能选中一个，还需要用到ButtonGroup



```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 200);
        f.setLayout(null);
        JRadioButton b1 = new JRadioButton("物理英雄");
        // 设置 为 默认被选中
        b1.setSelected(true);
        b1.setBounds(50, 50, 130, 30);
        JRadioButton b2 = new JRadioButton("魔法 英雄");
        b2.setBounds(50, 100, 130, 30);
 
        System.out.println(b2.isSelected());
 
        f.add(b1);
        f.add(b2);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 按钮组

ButtonGroup 对按钮进行分组，把不同的按钮，放在同一个分组里 ，同一时间，只有一个 按钮 会被选中



```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 240);
        f.setLayout(null);
        JRadioButton b1 = new JRadioButton("物理英雄");
        b1.setSelected(true);
        b1.setBounds(50, 50, 130, 30);
        JRadioButton b2 = new JRadioButton("魔法 英雄");
        b2.setBounds(50, 100, 130, 30);
 
        // 按钮分组
        ButtonGroup bg = new ButtonGroup();
        // 把b1，b2放在 同一个 按钮分组对象里 ，这样同一时间，只有一个 按钮 会被选中
        bg.add(b1);
        bg.add(b2);
 
        f.add(b1);
        f.add(b2);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 下拉框

JComboBox 下拉框
使用getSelectedItem来获取被选中项
使用setSelectedItem() 来指定要选中项



```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 240);
        f.setLayout(null);

        //下拉框出现的条目,传入一个数组
        String[] heros = new String[] { "卡特琳娜", "库奇" };
        JComboBox cb = new JComboBox(heros);

        cb.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e) {
                System.out.println(e.SELECTED);
            }
        });

        cb.setBounds(50, 50, 80, 30);

        f.add(cb);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### 对话框

JOptionPane 用于弹出对话框

JOptionPane.showConfirmDialog(f, "是否 使用外挂 ？");
表示询问，第一个参数是该对话框以哪个组件对齐
JOptionPane.showInputDialog(f, "请输入yes，表明使用外挂后果自负");
接受用户的输入
JOptionPane.showMessageDialog(f, "你使用外挂被抓住！ 罚拣肥皂3次！");
显示消息



```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 240);
        f.setLayout(null);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setVisible(true);

        int option = JOptionPane.showConfirmDialog(f, "是否 使用外挂 ？");
        if (JOptionPane.OK_OPTION == option) {
            String answer = JOptionPane.showInputDialog(f, "请输入yes，表明使用外挂后果自负");
            if ("yes".equals(answer))
                JOptionPane.showMessageDialog(f, "你使用外挂被抓住！ 罚拣肥皂3次！");
        }

    }
}
```



### 文本框

JTextField 输入框
setText 设置文本
getText 获取文本
JTextField 是单行文本框，如果要输入多行数据，请使用JTextArea

tfPassword.grabFocus(); 表示让密码输入框获取焦点



```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new FlowLayout());

        JLabel lName = new JLabel("账号：");
        // 输入框
        JTextField tfName = new JTextField("");
        tfName.setText("请输入账号");
        tfName.setPreferredSize(new Dimension(80, 30));

        JLabel lPassword = new JLabel("密码：");
        // 输入框
        JTextField tfPassword = new JTextField("");
        tfPassword.setText("请输入密码");
        tfPassword.setPreferredSize(new Dimension(80, 30));

        f.add(lName);
        f.add(tfName);
        f.add(lPassword);
        f.add(tfPassword);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
        tfPassword.grabFocus();
    }
}
```



### 密码框

JPasswordField 密码框
与文本框不同，获取密码框里的内容，推荐使用getPassword，该方法会返回一个字符数组，而非字符串

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
 
        f.setLayout(new FlowLayout());
 
        JLabel l = new JLabel("密码：");
        // 密码框
        JPasswordField pf = new JPasswordField("");
        pf.setText("&48kdh4@#");
        pf.setPreferredSize(new Dimension(80, 30));
 
        // 与文本框不同，获取密码框里的内容，推荐使用getPassword，该方法会返回一个字符数组，而非字符串
        char[] password = pf.getPassword();
        String p = String.valueOf(password);
        System.out.println(p);
 
        f.add(l);
        f.add(pf);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 文本域

JTextArea：文本域。
和文本框JTextField不同的是，文本域可以输入多行数据
如果要给文本域初始文本，通过\n来实现换行效果
JTextArea通常会用到append来进行数据追加
如果文本太长，会跑出去，可以通过setLineWrap(true) 来做到自动换行



```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);

        f.setLayout(new FlowLayout());

        JLabel l = new JLabel("文本域：");

        JTextArea ta = new JTextArea();
        ta.setPreferredSize(new Dimension(200, 150));
        //\n换行符
        ta.setText("抢人头！\n抢你妹啊抢！\n");
        //追加数据
        ta.append("我去送了了了了了了了了了了了了了了了了了了了了了了了了");
        //设置自动换行
        ta.setLineWrap(true);
        f.add(l);
        f.add(ta);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### 进度条

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
 
        f.setLayout(new FlowLayout());
 
        JProgressBar pb = new JProgressBar();
 
        //进度条最大100
        pb.setMaximum(100);
        //当前进度是50
        pb.setValue(50);
        //显示当前进度
        pb.setStringPainted(true);
 
        f.add(pb);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 文件选择器

JFileChooser 表示文件选择器
使用FileFilter用于仅选择.txt文件

fc.showOpenDialog(); 用于打开文件
fc.showSaveDialog(); 用于保存文件



```java
public class TestGUI {
    public static void main(String[] args) {
        // 设置主窗口
        JFrame f = new JFrame("LOL");
        f.setLayout(new FlowLayout());
        // 设置文件筛选器
        JFileChooser fc = new JFileChooser();
        // 设置筛选器具体筛选的文件格式，注意是导入swing包里面的筛选器
        fc.setFileFilter(new FileFilter() {
            @Override
            public String getDescription() {
                // TODO Auto-generated method stub
                return ".txt";
            }

            @Override
            public boolean accept(File f) {
                return f.getName().toLowerCase().endsWith(".txt");
            }
        });

        JButton bOpen = new JButton("打开文件");

        JButton bSave = new JButton("保存文件");

        f.add(bOpen);
        f.add(bSave);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setSize(250, 150);
        f.setLocationRelativeTo(null);

        f.setVisible(true);

        bOpen.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                int returnVal =  fc.showOpenDialog(f);
                File file = fc.getSelectedFile();
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    JOptionPane.showMessageDialog(f, "计划打开文件:" + file.getAbsolutePath());
                }

            }
        });
        bSave.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                int returnVal =  fc.showSaveDialog(f);
                File file = fc.getSelectedFile();
                if (returnVal == JFileChooser.APPROVE_OPTION) {
                    JOptionPane.showMessageDialog(f, "计划保存到文件:" + file.getAbsolutePath());
                }
            }
        });

    }

}
```



## 面板

### 基本面板

Panel即为基本面板
面板和JFrame一样都是容器，不过面板一般用来充当中间容器，把组件放在面板上，然后再把面板放在窗体上。
一旦移动一个面板，其上面的组件，就会全部统一跟着移动，采用这种方式，便于进行整体界面的设计

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
 
        f.setLayout(null);
 
        JPanel p1 = new JPanel();
        // 设置面板大小
        p1.setBounds(50, 50, 300, 60);
        // 设置面板背景颜色
        p1.setBackground(Color.RED);
 
        // 这一句可以没有，因为JPanel默认就是采用的FlowLayout
        p1.setLayout(new FlowLayout());
 
        JButton b1 = new JButton("英雄1");
        JButton b2 = new JButton("英雄2");
        JButton b3 = new JButton("英雄3");
 
        // 把按钮加入面板
        p1.add(b1);
        p1.add(b2);
        p1.add(b3);
 
        JPanel p2 = new JPanel();
        JButton b4 = new JButton("英雄4");
        JButton b5 = new JButton("英雄5");
        JButton b6 = new JButton("英雄6");
 
        p2.add(b4);
        p2.add(b5);
        p2.add(b6);
 
        p2.setBackground(Color.BLUE);
        p2.setBounds(10, 150, 300, 60);
 
        // 把面板加入窗口
        f.add(p1);
        f.add(p2);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### ContentPane

JFrame上有一层面板，叫做ContentPane
平时通过f.add()向JFrame增加组件，其实是向JFrame上的 ContentPane加东西

```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);

        f.add(b);
        // JFrame上有一层面板，叫做ContentPane
        // 平时通过f.add()向JFrame增加组件，其实是向JFrame上的 ContentPane加东西
        // f.add等同于f.getContentPane().add(b);
        f.getContentPane().add(b);

        // b.getParent()获取按钮b所处于的容器
        // 打印出来可以看到，实际上是ContentPane而非JFrame
        System.out.println(b.getParent());

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### SplitPanel

创建一个水平JSplitPane，左边是pLeft,右边是pRight



```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);

        f.setLayout(null);

        JPanel pLeft = new JPanel();
        pLeft.setBounds(50, 50, 300, 60);

        pLeft.setBackground(Color.RED);

        pLeft.setLayout(new FlowLayout());

        JButton b1 = new JButton("盖伦");
        JButton b2 = new JButton("提莫");
        JButton b3 = new JButton("安妮");

        pLeft.add(b1);
        pLeft.add(b2);
        pLeft.add(b3);

        JPanel pRight = new JPanel();
        JButton b4 = new JButton("英雄4");
        JButton b5 = new JButton("英雄5");
        JButton b6 = new JButton("英雄6");

        pRight.add(b4);
        pRight.add(b5);
        pRight.add(b6);

        pRight.setBackground(Color.BLUE);
        pRight.setBounds(10, 150, 300, 60);

        // 创建一个水平JSplitPane，左边是p1,右边是p2
        JSplitPane sp = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, pLeft, pRight);
        // 设置分割条的位置
        sp.setDividerLocation(80);

        // 把sp当作ContentPane
        f.setContentPane(sp);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### TabbedPanel

标签页面板



```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);

        f.setLayout(null);

      	// 面板1
        JPanel p1 = new JPanel();
        p1.setBounds(50, 50, 300, 60);
        p1.setBackground(Color.RED);
        p1.setLayout(new FlowLayout());
        JButton b1 = new JButton("英雄1");
        JButton b2 = new JButton("英雄2");
        JButton b3 = new JButton("英雄3");
        p1.add(b1);
        p1.add(b2);
        p1.add(b3);

      	// 面板2
        JPanel p2 = new JPanel();
        JButton b4 = new JButton("英雄4");
        JButton b5 = new JButton("英雄5");
        JButton b6 = new JButton("英雄6");
        p2.add(b4);
        p2.add(b5);
        p2.add(b6);
        p2.setBackground(Color.BLUE);
        p2.setBounds(10, 150, 300, 60);

      	// 添加两个面板
        JTabbedPane tp = new JTabbedPane();
        tp.add(p1);
        tp.add(p2);

        // 设置tab的标题
        tp.setTitleAt(0, "红色tab");
        tp.setTitleAt(1, "蓝色tab");

        ImageIcon i = new ImageIcon("src/file/icon.png");
        tp.setIconAt(0,i );
        tp.setIconAt(1,i );

        f.setContentPane(tp);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### CardLayerout

ardLayerout 布局器 很像TabbedPanel，在本例里面上面是一个下拉框，下面是一个CardLayerout 的JPanel
这个JPanel里有两个面板，可以通过CardLayerout方便的切换

特点是：CardLayerout面板内可以添加多个面板，但是每次只显示一个，然后通过名称cl.show(cards, (String) evt.getItem())显示指定的那一个(名称在添加进这个面板时设置)



```java
public class TestGUI {

    public static void main(String[] args) {
        JFrame f = new JFrame("CardLayerout");
        JPanel comboBoxPane = new JPanel();

        // 创建下拉框
        String buttonPanel = "按钮面板";
        String inputPanel = "输入框面板";
        String comboBoxItems[] = { buttonPanel, inputPanel };
        JComboBox<String> cb = new JComboBox<>(comboBoxItems);
        // 将下拉框加入面板中
        comboBoxPane.add(cb);

        // 两个Panel充当卡片
        JPanel card1 = new JPanel();
        card1.add(new JButton("按钮 1"));
        card1.add(new JButton("按钮 2"));
        card1.add(new JButton("按钮 3"));

        JPanel card2 = new JPanel();
        card2.add(new JTextField("输入框", 20));

        // 添加一个使用CardLayout卡片布局的面板，并加入前面的两个面板
        JPanel cards = new JPanel(new CardLayout());;
        // 添加面板，并设置面板名称
        cards.add(card1, buttonPanel);
        cards.add(card2, inputPanel);

        // 将下拉框添加到上方
        f.add(comboBoxPane, BorderLayout.NORTH);
        // 将卡片布局面板添加到中间
        f.add(cards, BorderLayout.CENTER);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setSize(250, 150);
        f.setLocationRelativeTo(null);
        f.setVisible(true);

        cb.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent evt) {
                // 获取卡片面板布局方式
                CardLayout cl = (CardLayout) (cards.getLayout());
                // 显示CardLayout卡片布局的面板内指定的面板名称那一个面板(之前添加了两个设置了名称)
                cl.show(cards, (String) evt.getItem());
            }
        });
    }
}
```



### 练习-SplitPanel

设计一个像SplitPanel的左右风格的SplitPanel
左边放3个按钮，上面的文字分别是: 盖伦，提莫，安妮
右边默认显示盖伦
当左边按钮点击的时候，右边就会显示对应的图片

![练习-SplitPanel](assets/Java SE(三)/2701.png)

```java
public class TestGUI {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setLayout(null);
        jFrame.setSize(400, 400);
        jFrame.setLocation(300,300);

        // 创建左右面板
        JPanel left = new JPanel();
        JPanel right = new JPanel();
        left.setLayout(new FlowLayout());   // 采用上下流体布局

        JButton icon1 = new JButton("图片1");
        JButton icon2 = new JButton("图片2");
        ImageIcon imageIcon1 = new ImageIcon("src/file/icon.png");
        ImageIcon imageIcon2 = new ImageIcon("src/file/icon2.png");
        // 创建标签来存放图片，图片只能设置为标签的图标形式
        JLabel jLabel1 = new JLabel("");
        jLabel1.setIcon(imageIcon1);
        left.add(icon1);
        left.add(icon2);
        right.add(jLabel1);

        // 创建按钮监听事件
        icon1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                jLabel1.setIcon(imageIcon1);
            }
        });
        icon2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                jLabel1.setIcon(imageIcon2);
            }
        });

        // 创建水平面板 将这个水平面板设置为主内容面板
        JSplitPane jSplitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, left, right);
        jSplitPane.setDividerLocation(80);
        jFrame.setContentPane(jSplitPane);

        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
}
```



### 练习-按照eclipse的风格显示多个java文件

![练习-按照eclipse的风格显示多个java文件](assets/Java SE(三)/2683.png)



```java
public class TestGUI {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setLayout(null);
        jFrame.setSize(400, 400);
        jFrame.setLocation(300, 300);

        // 创建标签页面板
        JTabbedPane jTabbedPane = new JTabbedPane();

        // 获取文件内容
        // 获取包内所有文件文件名
        File folder = new File("src/com/easylee/gui");
        File[] fs = folder.listFiles(); // 返回的是文件资源
        for (int i = 0; i < fs.length; i++) {
            // 创建面板
            JPanel jPanel = new JPanel();
            jPanel.setSize(400, 350);

            // 创建文本域
            JTextArea jTextArea = new JTextArea();

            // 获取文件内容
            String fileContent = null;
            try (FileReader fr = new FileReader(fs[i])) {
                char[] all = new char[(int) fs[i].length()];    // 包含格式，格式也是字符
                fr.read(all);   // 将内容读入一个数组，write是写入文件，这个是从文件读入FileReader流
                fileContent = new String(all);

                // 添加如文本域
                jTextArea.setText(fileContent);
                jPanel.add(jTextArea);
                jTabbedPane.add(jPanel);

                // 创建tab标签的标题，注意设置之前必须先add要设置tab的数量，要不然，没有办法设置
                jTabbedPane.setTitleAt(i,fs[i].getName());
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        jFrame.setContentPane(jTabbedPane);
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
}
```



## 组件综合练习

### 练习-为空判断

在JTextField中输入数据，在旁边加一个按钮JButton,当点击按钮的时候，判断JTextFiled中有没有数据，并使用JOptionPane进行提示

```java
public class TestGUI {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setLayout(new FlowLayout()); // 自流动适应布局
        jFrame.setSize(400, 400);
        jFrame.setLocation(300, 300);

        // 不设置面板，则默认使用contentpane
        JTextField jTextField = new JTextField();
        jTextField.setPreferredSize(new Dimension(80,20));
        JButton jButton = new JButton("判断");
        jFrame.add(jTextField);
        jFrame.add(jButton);

        // 判断是否为空
        jButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (jTextField.getText().length() == 0) {
                    JOptionPane.showMessageDialog(jFrame,"请输入内容");
                }
            }
        });

        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
}
```



### 练习-数字校验

在JTextField中输入数据，在旁边加一个按钮JButton,当点击按钮的时候，判断JTextFiled中的数据是否是数字，并使用JOptionPane进行提示



```java
public class TestGUI {
    public static void main(String[] args) {
        // 创建主窗口
        JFrame jFrame = new JFrame();
        jFrame.setLayout(new FlowLayout()); // 自流动适应布局
        jFrame.setSize(400, 400);
        jFrame.setLocation(300, 300);

        // 不设置面板，则默认使用contentpane
        JTextField jTextField = new JTextField();
        jTextField.setPreferredSize(new Dimension(80,20));
        JButton jButton = new JButton("判断");
        jFrame.add(jTextField);
        jFrame.add(jButton);

        // 判断是否为空
        jButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String text =  jTextField.getText();
              // 通过是否报错来判断是否是数字
                try {
                    Integer.parseInt(text);
                } catch (NumberFormatException e1) {
                    JOptionPane.showMessageDialog(jFrame, "输入框内容不是整数");
                    jTextField.grabFocus();
                }
            }
        });

        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
}
```



## 菜单

GUI的菜单分为 菜单栏，菜单和菜单项



### 菜单栏和菜单

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
 
        // 菜单栏
        JMenuBar mb = new JMenuBar();
 
        // 菜单
        JMenu mHero = new JMenu("英雄");
        JMenu mItem = new JMenu("道具");
        JMenu mWord = new JMenu("符文");
        JMenu mSummon = new JMenu("召唤师");
        JMenu mTalent = new JMenu("天赋树");
 
        // 把菜单加入到菜单栏
        mb.add(mHero);
        mb.add(mItem);
        mb.add(mWord);
        mb.add(mSummon);
        mb.add(mTalent);
 
        // 把菜单栏加入到frame，这里用的是set而非add
        f.setJMenuBar(mb);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 菜单项

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 400);
        f.setLocation(200, 200);
 
        JMenuBar mb = new JMenuBar();
 
        JMenu mHero = new JMenu("英雄");
        JMenu mItem = new JMenu("道具");
        JMenu mWord = new JMenu("符文");
        JMenu mSummon = new JMenu("召唤师");
        JMenu mTalent = new JMenu("天赋树");
 
        // 菜单项
        mHero.add(new JMenuItem("近战-Warriar"));
        mHero.add(new JMenuItem("远程-Range"));
        mHero.add(new JMenuItem("物理-physical"));
        mHero.add(new JMenuItem("坦克-Tank"));
        mHero.add(new JMenuItem("法系-Mage"));
        mHero.add(new JMenuItem("辅助-Support"));
        mHero.add(new JMenuItem("打野-Jungle"));
        mHero.add(new JMenuItem("突进-Charge"));
        mHero.add(new JMenuItem("男性-Boy"));
        mHero.add(new JMenuItem("女性-Girl"));
        // 分隔符
        mHero.addSeparator();
        mHero.add(new JMenuItem("所有-All"));
 
        mb.add(mHero);
        mb.add(mItem);
        mb.add(mWord);
        mb.add(mSummon);
        mb.add(mTalent);
 
        f.setJMenuBar(mb);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



### 练习-完成一个完整的记事本界面

![练习-完成一个完整的记事本界面](assets/Java SE(三)/2685.png)

```java
public class MyTest {
    public static void main(String[] args) {
        JFrame jFrame = new JFrame("无标题-记事本");
        jFrame.setSize(400,400);
        jFrame.setLocation(400,400);

        // 创建菜单栏
        JMenuBar jMenuBar = new JMenuBar();
        // 创建菜单
        JMenu jMenu = new JMenu("文件");
        // 创建菜单项
        JMenuItem jMenuItem = new JMenuItem("新建");
        JMenuItem jMenuItem1 = new JMenuItem("打开");
        JMenuItem jMenuItem2 = new JMenuItem("保存");
        JMenuItem jMenuItem3 = new JMenuItem("另存为");

        // 将菜单项添加到菜单中
        jMenu.add(jMenuItem);
        jMenu.add(jMenuItem1);
        jMenu.add(jMenuItem2);
        jMenu.add(jMenuItem3);
        // 将菜单添加到菜单栏中
        jMenuBar.add(jMenu);
        // 将菜单栏添加到窗口中
        jFrame.setJMenuBar(jMenuBar);
        
        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
}
```



## 工具栏

工具栏用于存放常用的按钮



### 工具栏

```java
  public static void main(String[] args) {
 
    JFrame f = new JFrame("LoL");
    f.setSize(400, 300);
    f.setLocation(200, 200);
    // 添加菜单栏
    addMenu(f);

    // 工具栏
    JToolBar tb = new JToolBar();
    // 为工具栏增加按钮
    JButton b1 = new JButton(new ImageIcon("e:/project/j2se/1.jpg"));
    JButton b2 = new JButton(new ImageIcon("e:/project/j2se/2.jpg"));
    JButton b3 = new JButton(new ImageIcon("e:/project/j2se/3.jpg"));
    JButton b4 = new JButton(new ImageIcon("e:/project/j2se/4.jpg"));
    JButton b5 = new JButton(new ImageIcon("e:/project/j2se/5.jpg"));
    JButton b6 = new JButton(new ImageIcon("e:/project/j2se/6.jpg"));
    tb.add(b1);
    tb.add(b2);
    tb.add(b3);
    tb.add(b4);
    tb.add(b5);
    tb.add(b6);

    // 把工具栏放在north的位置
    f.setLayout(new BorderLayout());
    f.add(tb, BorderLayout.NORTH);

    f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    f.setVisible(true);
  }
```



### 给按钮设置提示信息

当鼠标放在按钮上的时候会出现提示

![给按钮设置提示信息](assets/Java SE(三)/922.png)

```java
// 给按钮设置提示信息
b1.setToolTipText("坑爹英雄");
```



### 禁止工具栏拖动

默认情况下 工具栏可以通过鼠标拖动

```java
setFloatable(false);
```



## 表格

### 基本表格

显示一个Table需要两组数据
一维数组： String[]columnNames 表示表格的标题
二维数组： String[][] heros 表格中的内容
默认情况下，表格的标题是不会显示出来了，除非使用了JScrollPane

```java
public class MyTest {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new BorderLayout());

        // 表格标题行
        String[] columnNames = new String[] { "id", "name", "hp", "damage" };
        // 表格中的内容，是一个二维数组
        String[][] heros = new String[][] { { "1", "盖伦", "616", "100" },
                { "2", "提莫", "512", "102" }, { "3", "奎因", "832", "200" } };
        JTable t = new JTable(heros, columnNames);

        f.add(t, BorderLayout.CENTER);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setVisible(true);
    }
}
```



### JScrollPane

JScrollPane: 带滚动条的Panel
把table放进去就可以看到table的title
同样的把textarea放进去，并且textarea内容够长的话，就会看到滚动条



```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new BorderLayout());

        String[] columnNames = new String[] { "id", "name", "hp", "damage" };
        String[][] heros = new String[][] { { "1", "盖伦", "616", "100" },
                { "2", "提莫", "512", "102" }, { "3", "奎因", "832", "200" } };
        JTable t = new JTable(heros, columnNames);

        // 根据t创建 JScrollPane
        JScrollPane sp = new JScrollPane(t);

        //或则创建一个空的JScrollPane，再通过setViewportView把table放在JScrollPane中
        // JScrollPane sp = new JScrollPane(t);
        // sp.setViewportView(t);

        // 把sp而非JTable加入到JFrame上，
        f.add(sp, BorderLayout.CENTER);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setVisible(true);
    }
}
```



### 列宽

```java
// 设置列宽度
t.getColumnModel().getColumn(0).setPreferredWidth(10);
```



### TableModel

首先说下TableModel的设计思想，在Model这种思想的指导下，数据和显示分离开来了。 比如对于JTable而言，有数据部分，也有显示部分(比如列宽等信息)。 数据部分，专门做一个类，叫做TableModel，就用于存放要显示的数据。


使用TableModel的方式存放Table需要显示的数据
HeroTableModel 继承AbstractTableModel ，进而实现了接口TableModel
在HeroTableModel 中提供一个table显示需要的所有信息

1. getRowCount 返回一共有多少行
2. getColumnCount 返回一共有多少列
3. getColumnName 每一列的名字
4. isCellEditable 单元格是否可以修改
5. getValueAt 每一个单元格里的值

当图形界面需要渲染第一个单元格的数据的时候，就会调用方法TabelModel的getValueAt(0,0) ，把返回值拿到并显示



```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new BorderLayout());

        //创建一个TableModel
        HeroTableModel htm= new HeroTableModel();

        //根据 TableModel来创建 Table,HeroTableModel要按照TableMolel的接口来实现
        JTable t = new JTable(htm);

        JScrollPane sp = new JScrollPane(t);

        f.add(sp, BorderLayout.CENTER);

        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}

class HeroTableModel extends AbstractTableModel {

    String[] columnNames = new String[] { "id", "name", "hp", "damage" };
    String[][] heros = new String[][] { { "1", "盖伦", "616", "100" },
            { "2", "提莫", "512", "102" }, { "3", "奎因", "832", "200" } };

    // 返回一共有多少行
    public int getRowCount() {
        // TODO Auto-generated method stub
        return heros.length;
    }

    // 返回一共有多少列
    public int getColumnCount() {
        // TODO Auto-generated method stub
        return columnNames.length;
    }

    // 获取每一列的名称
    public String getColumnName(int columnIndex) {
        // TODO Auto-generated method stub
        return columnNames[columnIndex];
    }

    // 单元格是否可以修改
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }

    // 每一个单元格里的值
    public Object getValueAt(int rowIndex, int columnIndex) {
        // TODO Auto-generated method stub
        return heros[rowIndex][columnIndex];
    }

}
```



### TableSelectionModel

通过table可以获取一个 TableSelectionModel，专门用于监听jtable选中项的变化

```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(new BorderLayout());

        final HeroTableModel htm = new HeroTableModel();

        final JTable t = new JTable(htm);
        // 准备一个Panel上面放一个Label用于显示哪条被选中了
        JPanel p = new JPanel();
        final JLabel l = new JLabel("暂时未选中条目");
        p.add(l);

        JScrollPane sp = new JScrollPane(t);

        // 使用selection监听器来监听table的哪个条目被选中
        t.getSelectionModel().addListSelectionListener(
                new ListSelectionListener() {
                    // 当选择了某一行的时候触发该事件
                    public void valueChanged(ListSelectionEvent e) {
                        System.out.println(e);
                    }
                });

        f.add(p, BorderLayout.NORTH);
        f.add(sp, BorderLayout.CENTER);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setVisible(true);
    }
}

class HeroTableModel extends AbstractTableModel {
    String[] columnNames = new String[] { "id", "name", "hp", "damage" };
    String[][] heros = new String[][] { { "1", "盖伦", "616", "100" },
            { "2", "提莫", "512", "102" }, { "3", "奎因", "832", "200" } };

    // 返回一共有多少行
    public int getRowCount() {
        // TODO Auto-generated method stub
        return heros.length;
    }

    // 返回一共有多少列
    public int getColumnCount() {
        // TODO Auto-generated method stub
        return columnNames.length;
    }

    // 获取每一列的名称
    public String getColumnName(int columnIndex) {
        // TODO Auto-generated method stub
        return columnNames[columnIndex];
    }

    // 单元格是否可以修改
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }

    // 每一个单元格里的值
    public Object getValueAt(int rowIndex, int columnIndex) {
        // TODO Auto-generated method stub
        return heros[rowIndex][columnIndex];
    }
}
```



### 选中指定行

table初始化后，应该默认选中第一行
增加数据后，也应该选中新增的这一条

```java
// 设置选择模式为 只能选中一行
t.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
// 选中第一行 （基本0）
t.getSelectionModel().setSelectionInterval(0, 0);
```



## 日期控件

### DatePicker

本例使用 datepicker.jar 包，有一个缺点，不能设置时间，只能在创建控件的时候传入指定日期。
使用需要先导入jar包

```java
public class TestGUI {
    public static void main(String[] args) {
        JFrame jFrame = new JFrame();
        jFrame.setSize(400,400);
        jFrame.setLocation(400,400);
        jFrame.setLayout(null);

        final DatePicker datepick;
        datepick = getDatePicker();

        jFrame.add(datepick);

        JButton b = new JButton("获取时间");
        b.setBounds(137, 183, 100, 30);
        jFrame.add(b);

        b.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(jFrame, "获取控件中的日期：" + datepick.getValue());
                System.out.println(datepick.getValue());
            }
        });


        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.setVisible(true);
    }
    private static DatePicker getDatePicker() {
        final DatePicker datepick;
        // 格式
        String DefaultFormat = "yyyy-MM-dd HH:mm:ss";
        // 当前时间
        Date date = new Date();
        // 字体
        Font font = new Font("Times New Roman", Font.BOLD, 14);

        Dimension dimension = new Dimension(177, 24);

        int[] hilightDays = { 1, 3, 5, 7 };

        int[] disabledDays = { 4, 6, 5, 9 };

        datepick = new DatePicker(date, DefaultFormat, font, dimension);

        datepick.setLocation(137, 83);
        datepick.setBounds(137, 83, 177, 24);
        // 设置一个月份中需要高亮显示的日子
        datepick.setHightlightdays(hilightDays, Color.red);
        // 设置一个月份中不需要的日子，呈灰色显示
        datepick.setDisableddays(disabledDays);
        // 设置国家
        datepick.setLocale(Locale.CHINA);
        // 设置时钟面板可见
        datepick.setTimePanleVisible(true);
        return datepick;
    }
}
```



### JXDatePicker

本例使用 包swingx-core-1.6.2.jar，界面比较简约，可以设置日期

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
 
        Date date = new Date();
 				
      	// 不需要额外操作，直接new即可
        final JXDatePicker datepick = new JXDatePicker();
 
        // 设置 date日期
        datepick.setDate(date);
 
        datepick.setBounds(137, 83, 177, 24);
 
        f.add(datepick);
 
        JButton b = new JButton("获取时间");
        b.setBounds(137, 183, 100, 30);
        f.add(b);
 
        b.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                // 获取 日期
                Date d = datepick.getDate();
                JOptionPane.showMessageDialog(f, "获取控件中的日期 :" + d);
 
            }
        });
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        f.setVisible(true);
    }
}
```



## SWING中的线程

### 三种线程

在Swing程序的开发中，需要建立3种线程的概念

- 初始化线程：初始化线程用于创建各种[容器](https://how2j.cn/k/gui/gui-container/404.html)，[组件](https://how2j.cn/k/gui/gui-component/407.html)并显示他们，一旦创建并显示，初始化线程的任务就结束了。
- 事件调度线程：通过[事件监听](https://how2j.cn/k/gui/gui-listener/412.html)的学习，我们了解到Swing是一个事件驱动的模型，所有和事件相关的操作都放是放在事件调度线程 (Event Dispatch)中进行的。比如点击一个按钮，对应的ActionListener.actionPerformed 方法中的代码，就是在事件调度线程 Event Dispatch Thread中执行的。
- 长耗时任务线程：有时候需要进行一些长时间的操作，比如访问数据库，文件复制，连接网络，统计文件总数等等。 这些操作就不适合放在事件调度线程中进行，因为占用时间久了，会让使用者感觉界面响应很卡顿。 为了保持界面响应的流畅性,所有长耗时任务都应该放在专门的 长耗时任务线程中进行(不单独进行，点击一下半天都没反应，影响事件调度线程)



### 事件调度线程是单线程的

在开始讲解这3种线程之前， 要建立一个概念： 事件调度线程是单线程的。
为什么呢？
这是因为 Swing里面的各种组件类，比如JTextField,JButton 都不是线程安全的，这就意味着，如果有多个线程，那么同一个JTextField的setText方法，可能会被多个线程同时调用，这会导致同步问题以及错误数据的发生。

如果把组件类设计成为线程安全的，由于Swing事件调度的复杂性，就很有可能导致死锁的发生。

为了规避同步问题，以及降低整个Swing设计的复杂度，提高Swing的相应速度，Swing中的 事件调度线程被设计成为了单线程模式，即只有一个线程在负责事件的响应工作。



### 初始化线程

如代码所示，同时我们在初始化一个图形界面的时候，都会直接在主方法的主线程里，直接调用如下代码来进行初始化

```java
new TestFrame().setVisible(true);
```

如果是小程序这没有什么问题，如果是复杂的程序就有可能产生问题了。因为这里有两个线程在同时访问组件：1. 主线程 2. 事件调度线程。 如果是复杂的图形界面程序，就有可能出现这两个线程同时操作的情况，导致同步问题的产生。

为了规避这个问题的产生，创建和显示界面的工作，最好也交给事件调度线程，这样就保证了只有一个线程在访问这些组件

```java
SwingUtilities.invokeLater(new Runnable() {
	public void run() {
		new TestFrame().setVisible(true);
	}
});
```



```java
public class TestGUI {
    public static void main(String[] args) {

      // false，不是事件调度
      new TestFrame().setVisible(true);

      // true，是事件调度  
      SwingUtilities.invokeLater(new Runnable() {
          public void run() {
              new TestFrame().setVisible(true);
          }
      });
    }

    static class TestFrame extends JFrame {
        public TestFrame() {
            setTitle("LoL");

            setSize(400, 300);

            setLocation(200, 200);

            setLayout(null);

            JButton b = new JButton("一键秒对方基地挂");

            b.setBounds(50, 50, 280, 30);

            add(b);

            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

            setVisible(true);

            System.out.println("当前线程是否是 事件调度线程: " + SwingUtilities.isEventDispatchThread());

        }
    }
}
```



### 事件调度线程

以按钮监听中的代码为例，ActionListener.actionPerformed 中的代码，就是事件调度线程执行的。

可以借助SwingUtilities.isEventDispatchThread() 确认，是事件调度线程在执行相应的代码

那么事件调度线程又是如何去执行这段代码的呢？ 这就不用你操心啦, 要解释这个问题，就需要剖析整个Swing的框架，就不是本章节所能展示的内容啦

```java
public class TestGUI {
    public static void main(String[] args) {

        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(580, 200);
        f.setLayout(null);

        final JLabel l = new JLabel();

        ImageIcon i = new ImageIcon("e:/project/j2se/shana.png");
        l.setIcon(i);
        l.setBounds(50, 50, i.getIconWidth(), i.getIconHeight());

        JButton b = new JButton("隐藏图片");
        b.setBounds(150, 200, 100, 30);

        b.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                l.setVisible(false);
                System.out.println("当前使用的是事件调度线程：" + SwingUtilities.isEventDispatchThread());
            }
        });

        f.add(l);
        f.add(b);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setVisible(true);
    }
}
```



### 长耗时任务线程

有时候需要执行长耗时任务，比如数据库查询，文件复制，访问网络等等。

而这些操作一般都会在事件响应后发起，就会自动进入[事件调度线程](https://how2j.cn/k/gui/gui-thread/708.html#step2726)。 而事件调度线程又是单线程模式，其结果就会是在执行这些长耗时任务的时候，界面就无响应了。

如图所示，当点击第一个按钮的时候，会在其中进行一个5秒钟的任务，这个期间，第一个按钮会保持按下状态，其他按钮也无法点击，出现了无响应了状态。

为了解决这个问题，Swing提供了一个SwingWorker类来解决。 SwingWorker是一个抽象类，为了使用，必须实现方法 doInBackground，在doInBackground中，就可以编写我们的任务，然后执行SwingWorker的execute方法，放在专门的工作线程中去运行。

```java
SwingWorker worker = new SwingWorker() {
	protected Object doInBackground() throws Exception {
		//长耗时任务
		return null;
	}
};
worker.execute();
```

SwingWorker又是如何工作的呢？
当SwingWorker执行execute的时候，调用默认有10根线程的线程池，执行doInBackground中的代码，通过如下代码，可以获知执行当前SwingWorder的线程名称

```java
System.out.println("执行这个SwingWorder的线程是：" + Thread.currentThread().getName());
```

```java
public class TestGUI {
    public static void main(String[] args) {
 
        JFrame f = new JFrame("LoL");
        f.setSize(300, 300);
        f.setLocation(200, 200);
        f.setLayout(new FlowLayout());
 
        JButton b1 = new JButton("在事件调度线程中执行长耗时任务");
        JButton b2 = new JButton("使用SwingWorker执行长耗时任务");
        JLabel l = new JLabel("任务执行结果");
        f.add(b1);
        f.add(b2);
        f.add(l);
 
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
 
        b1.addActionListener(new ActionListener() {
 
            @Override
            public void actionPerformed(ActionEvent e) {
                l.setText("开始执行完毕");
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
                l.setText("任务执行完毕");
            }
        });
        b2.addActionListener(new ActionListener() {
 
            @Override
            public void actionPerformed(ActionEvent e) {
                SwingWorker<Void, Void> worker = new SwingWorker<Void, Void>() {
 
                    @Override
                    protected Void doInBackground() throws Exception {
                        System.out.println("执行这个SwingWorder的线程是：" + Thread.currentThread().getName());
                        l.setText("开始执行完毕");
                        try {
                            Thread.sleep(5000);
                        } catch (InterruptedException e1) {
                            // TODO Auto-generated catch block
                            e1.printStackTrace();
                        }
                        l.setText("任务执行完毕");
                        return null;
                    }
                };
                worker.execute();
 
            }
        });
 
        f.setVisible(true);
    }
}
```

## 皮肤

Java提供了非常便捷的方式切换界面风格



### 设置皮肤

只需要提供一句代码

```java
javax.swing.UIManager.setLookAndFeel("com.birosoft.liquid.LiquidLookAndFeel");

```

就可以把所有的组件切换成不同的风格。

注： 这句话需要加在最前面，如果已经创建了界面，再加这个有时候不能正常起作用。

在右侧的附件里提供了各种皮肤，以及皮肤对应的jar包的下载

```java
public class TestGUI {
    public static void main(String[] args) {
        //设置皮肤
        setLookAndFeel();
 
        JFrame f = new JFrame("LoL");
        f.setSize(400, 300);
        f.setLocation(200, 200);
        f.setLayout(null);
        JButton b = new JButton("一键秒对方基地挂");
        b.setBounds(50, 50, 280, 30);
  
        f.add(b);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  
        f.setVisible(true);
    }
  
    private static void setLookAndFeel() {
        try {
          javax.swing.UIManager.setLookAndFeel("com.birosoft.liquid.LiquidLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.smart.SmartLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.mcwin.McWinLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.luna.LunaLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.aluminium.AluminiumLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.bernstein.BernsteinLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.hifi.HiFiLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.mint.MintLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.aero.AeroLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.fast.FastLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.acryl.AcrylLookAndFeel");
//          javax.swing.UIManager.setLookAndFeel("com.jtattoo.plaf.noire.NoireLookAndFeel");
        } catch (Exception e) {
            e.printStackTrace();
            // handle exception
        }
  
    }
}
```



# 网络编程

## IP地址和端口

### 获取本机IP地址

```java
// get local ip address
public static String getLocalIp() {
    String ip = "";
    try {
        ip = InetAddress.getLocalHost().getHostAddress();
    } catch (UnknownHostException e) {
        e.printStackTrace();
    }
    return ip;
}
```



### 使用java 执行ping命令

```java
Process p = Runtime.getRuntime().exec("ping " + "192.168.2.106");
BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
String line = null;
StringBuilder sb = new StringBuilder();
while ((line = br.readLine()) != null) {
    if (line.length() != 0)
        sb.append(line + "\r\n");
}
System.out.println("本次指令返回的消息是：");
System.out.println(sb.toString());
```



## SOCKET 收发消息

### 建立连接

服务端开启8888端口，并监听着，时刻等待着客户端的连接请求
客户端知道服务端的ip地址和监听端口号，发出请求到服务端
客户端的端口地址是系统分配的，通常都会大于1024
一旦建立了连接，服务端会得到一个新的Socket对象，该对象负责与客户端进行通信。
**注意：** 在开发调试的过程中，如果修改过了服务器Server代码，要关闭启动的Server,否则新的Server不能启动，因为8888端口被占用了

server.java

```java
try {
    // open port
    ServerSocket ss = new ServerSocket(8888);
    System.out.println("服务器已经启动，等待客户端连接...");
    // wait for client connection
    Socket s = ss.accept();
    s.close();
    ss.close();
} catch (IOException e) {
    e.printStackTrace();
}
```

client.java

```java
try {
    // link to server by ip and port
    Socket s = new Socket("127.0.0.1",8888);
    System.out.println(s);
    s.close();
} catch (IOException e) {
    e.printStackTrace();
}
```



### 收发数字

```java
// server
try {
    // open port
    ServerSocket ss = new ServerSocket(8888);
    System.out.println("server is running, please wait client in...");
    // wait for client connection
    Socket s = ss.accept();

    // get input stream
    InputStream is = s.getInputStream();

    // read data from client
    int msg = is.read();
    System.out.println(msg);
    // close input stream
    is.close();

    s.close();
    ss.close();
} catch (IOException e) {
    e.printStackTrace();
}
```

```java
// client
try {
    // link to server by ip and port
    Socket s = new Socket("127.0.0.1",8888);

    // send message to server
    // write method parameter is byte[]
    s.getOutputStream().write(110);

    s.close();
} catch (IOException e) {
    e.printStackTrace();
}
```



### 收发字符串

直接使用字节流收发字符串比较麻烦，使用数据流对字节流进行封装，这样收发字符串就容易了

把输出流封装在DataOutputStream中

使用writeUTF发送字符串 "Legendary!"

把输入流封装在DataInputStream

使用readUTF读取字符串,并打印

```java
// server
try {
    // open port
    ServerSocket ss = new ServerSocket(8888);
    System.out.println("server is running, please wait client in...");
    // wait for client connection
    Socket s = ss.accept();

    // get input stream
    InputStream is = s.getInputStream();

    // Encapsulate the input stream into a DataInputStream
    DataInputStream dis = new DataInputStream(is);

    String msg = dis.readUTF();

    System.out.println(msg);

    is.close();
    dis.close();
    s.close();
    ss.close();
} catch (IOException e) {
    e.printStackTrace();
}
```

```java
// client
try {
    // link to server by ip and port
    Socket s = new Socket("127.0.0.1",8888);

    // get output stream
    OutputStream os = s.getOutputStream();

    // encapsulate the OutputStream into DataOutputStream
    DataOutputStream dos = new DataOutputStream(os);

    dos.writeUTF("Legendary");

    dos.close();
    s.close();
} catch (IOException e) {
    e.printStackTrace();
}
```



### 使用Scanner

```java
// client
try {
    // link to server by ip and port
    Socket s = new Socket("127.0.0.1",8888);

    // get output stream
    OutputStream os = s.getOutputStream();

    // encapsulate the OutputStream into DataOutputStream
    DataOutputStream dos = new DataOutputStream(os);

    // get data from keyboard
    Scanner sc = new Scanner(System.in);
    String str = sc.next();
    dos.writeUTF(str);

    dos.close();
    s.close();
} catch (IOException e) {
    e.printStackTrace();
}
```



### 练习-服务端和客户端互聊

让服务器和客户端互相聊天

```java
// server
try {
    // open port
    ServerSocket ss = new ServerSocket(8888);
    System.out.println("server is running, please wait client in...");
    // wait for client connection
    Socket s = ss.accept();

    InputStream is = s.getInputStream();
    DataInputStream dis = new DataInputStream(is);
    OutputStream os = s.getOutputStream();
    DataOutputStream dos = new DataOutputStream(os);

    while (true) {
        String msg = dis.readUTF();
        System.out.println("get client message: " + msg);
        Scanner scanner = new Scanner(System.in);
        String str = scanner.nextLine();
        // because dos is the socket connection
        // so we can use dos to send message to client
        dos.writeUTF(str);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

```java
// client
try {
    // link to server by ip and port
    Socket s = new Socket("127.0.0.1",8888);

    InputStream is = s.getInputStream();
    DataInputStream dis = new DataInputStream(is);
    OutputStream os = s.getOutputStream();
    DataOutputStream dos = new DataOutputStream(os);

    while (true) {
        // send message to server
        Scanner sc = new Scanner(System.in);
        String str = sc.nextLine();
        dos.writeUTF(str);
        String msg = dis.readUTF();
        System.out.println("get server message" + msg);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```



## 多线程聊天

如果使用单线程开发Socket应用，那么同一时间，要么收消息，要么发消息，不能同时进行。

为了实现**同时收发消息**，就需要用到多线程



### 同时收发消息

在练习-服务端和客户端互聊中，只能一人说一句，说了之后，必须等待另一个人的回复，才能说下一句。

这是因为接受和发送都在主线程中，不能同时进行。 为了实现同时收发消息，基本设计思路是把收发分别放在不同的线程中进行

1. SendThread 发送消息线程
2. RecieveThread 接受消息线程
3. Server一旦接受到连接，就启动收发两个线程
4. Client 一旦建立了连接，就启动收发两个线程

```java
public class SendThread extends Thread {
    private Socket s;
    // set socket to create send thread
    public SendThread(Socket s){
        this.s = s;
    }
    @Override
    public void run() {
        // send message thread
        try {
            OutputStream os = s.getOutputStream();
            DataOutputStream dos = new DataOutputStream(os);

            while (true){
                Scanner sc = new Scanner(System.in);
                String str = sc.next();
                dos.writeUTF(str);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

```java
public class RecieveThread extends Thread {
    private Socket s;
    public RecieveThread(Socket s){
        this.s = s;
    }

    @Override
    public void run() {
        try {
            InputStream is = s.getInputStream();
            DataInputStream dis = new DataInputStream(is);

            while (true){
                String msg = dis.readUTF();
                System.out.println(msg);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

```java
public class Server {
    public static void main(String[] args) throws IOException {
        try {
            // open port
            ServerSocket ss = new ServerSocket(8888);
            System.out.println("server is running, please wait client in...");
            // wait for client connection
            Socket s = ss.accept();

            new SendThread(s).start();
            new RecieveThread(s).start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

```java
public class Client {
    public static void main(String[] args) {
        try {
            // link to server by ip and port
            Socket s = new Socket("127.0.0.1",8888);

            new SendThread(s).start();
            new RecieveThread(s).start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

# jdk1.8新特性

## 流Stream

Java 8 API添加了一个新的抽象称为流Stream，可以让你以一种声明的方式处理数据。Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。Stream API可以极大提高Java程序员的生产力，让程序员写出高效率、干净、简洁的代码。这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。元素流在管道中经过中间操作（intermediate operation）的处理，最后由最终操作(terminal operation)得到前面处理的结果。

![img](assets/Java SE(三)/src=http%3A%2F%2Fseo-1255598498.file.myqcloud.com%2Ffull%2F723b4e9e03e9f1cbd9078f60b265e3ddc8a582aa.jpg&refer=http%3A%2F%2Fseo-1255598498.file.myqcloud.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

它看起来就像一个工厂的流水线一样！我们就可以把一个Stream当做流水线处理：

```java
public static void main(String[] args) {
    List<String> list = new ArrayList<>();
    list.add("A");
    list.add("B");
    list.add("C");
  
  	//移除为B的元素
  	Iterator<String> iterator = list.iterator();
        while (iterator.hasNext()){
            if(iterator.next().equals("B")) iterator.remove();
        }
  
  	//Stream操作
    list = list     //链式调用
            .stream()    //获取流
            .filter(e -> !e.equals("B"))   //只允许所有不是B的元素通过流水线
            .collect(Collectors.toList());   //将流水线中的元素重新收集起来，变回List
    System.out.println(list);
}
```

可能从上述例子中还不能感受到流处理带来的便捷，我们通过下面这个例子来感受一下：

```java
public static void main(String[] args) {
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
  	list.add(3);

    list = list
            .stream()
      			.distinct()   //去重（使用equals判断）
            .sorted((a, b) -> b - a)    //进行倒序排列
            .map(e -> e+1)    //每个元素都要执行+1操作
            .limit(2)    //只放行前两个元素
            .collect(Collectors.toList());

    System.out.println(list);
}
```

当遇到大量的复杂操作时，我们就可以使用Stream来快速编写代码，这样不仅代码量大幅度减少，而且逻辑也更加清晰明了（如果你学习过SQL的话，你会发现它更像一个Sql语句）

**注意**：不能认为每一步是直接依次执行的！

```java
List<Integer> list = new ArrayList<>();
list.add(1);
list.add(2);
list.add(3);
list.add(3);

list = list
        .stream()
        .distinct()   //断点
        .sorted((a, b) -> b - a)
        .map(e -> {
            System.out.println(">>> "+e);   //断点
            return e+1;
        })
        .limit(2)   //断点
        .collect(Collectors.toList());
//实际上，stream会先记录每一步操作，而不是直接开始执行内容，当整个链式调用完成后，才会依次进行！
```

接下来，我们用一堆随机数来进行更多流操作的演示：

```java
public static void main(String[] args) {
    Random random = new Random();  //Random是一个随机数工具类
    random
            .ints(-100, 100)   //生成-100~100之间的，随机int型数字（本质上是一个IntStream）
            .limit(10)   //只获取前10个数字（这是一个无限制的流，如果不加以限制，将会无限进行下去！）
            .filter(i -> i < 0)   //只保留小于0的数字
            .sorted()    //默认从小到大排序
            .forEach(System.out::println);   //依次打印
}
```

我们可以生成一个统计实例来帮助我们快速进行统计：

```java
public static void main(String[] args) {
    Random random = new Random();  //Random是一个随机数工具类
    IntSummaryStatistics statistics = random
            .ints(0, 100)
            .limit(100)
            .summaryStatistics();    //获取语法统计实例
    System.out.println(statistics.getMax());  //快速获取最大值
    System.out.println(statistics.getCount());  //获取数量
    System.out.println(statistics.getAverage());   //获取平均值
}
```

普通的List只需要一个方法就可以直接转换到方便好用的IntStream了：

```java
public static void main(String[] args) {
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);
    list.stream()
            .mapToInt(i -> i)    //将每一个元素映射为Integer类型（这里因为本来就是Integer）
            .summaryStatistics();
}
```

我们还可以通过`flat`来对整个流进行进一步细分：

```java
public static void main(String[] args) {
    List<String> list = new ArrayList<>();
    list.add("A,B");
    list.add("C,D");
    list.add("E,F");   //我们想让每一个元素通过,进行分割，变成独立的6个元素
    list = list
            .stream()    //生成流
            .flatMap(e -> Arrays.stream(e.split(",")))    //分割字符串并生成新的流
            .collect(Collectors.toList());   //汇成新的List
    System.out.println(list);   //得到结果
}
```

我们也可以只通过Stream来完成所有数字的和，使用`reduce`方法：

```java
public static void main(String[] args) {
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
    int sum = list
            .stream()
            .reduce((a, b) -> a + b)   //计算规则为：a是上一次计算的值，b是当前要计算的参数，这里是求和
            .get();    //我们发现得到的是一个Optional类实例，不是我们返回的类型，通过get方法返回得到的值
    System.out.println(sum);
}
```

通过上面的例子，我们发现，Stream不喜欢直接给我们返回一个结果，而是通过Optinal的方式，那么什么是Optional呢？

## Optional

Optional类是Java8为了解决null值判断问题，使用Optional类可以避免显式的null值判断（null的防御性检查），避免null导致的NPE（NullPointerException）。总而言之，就是对控制的一个判断，为了避免空指针异常。

```java
public static void main(String[] args) {
    String str = null;
    if(str != null){   //当str不为空时添加元素到List中
        list.add(str);
    }
}
```

有了Optional之后，我们就可以这样写：

```java
public static void main(String[] args) {
    String str = null;
    Optional<String> optional = Optional.ofNullable(str);   //转换为Optional
    optional.ifPresent(System.out::println);  //当存在时再执行方法
}
```

就类似于Kotlin中的：

```js
var str : String? = null
str?.upperCase()
```

我们可以选择直接get或是当值为null时，获取备选值：

```java
public static void main(String[] args) {
    String str = null;
    Optional optional = Optional.ofNullable(str);   //转换为Optional（可空）
    System.out.println(optional.orElse("lbwnb"));
 		// System.out.println(optional.get());   这样会直接报错
}
```

同样的，Optional也支持过滤操作和映射操作，不过是对于单对象而言：

```java
public static void main(String[] args) {
    String str = "A";
    Optional optional = Optional.ofNullable(str);   //转换为Optional（可空）
    System.out.println(optional.filter(s -> s.equals("B")).get());   //被过滤了，此时元素为null，获取时报错
}
```

```java
public static void main(String[] args) {
    List<String> list = new ArrayList<>();
    String str = "A";
    Optional optional = Optional.ofNullable(str);   //转换为Optional（可空）
    System.out.println(optional.map(s -> s + "A").get());   //在尾部追加一个A
}
```

## 聚合操作

也就是链式操作

### Stream和管道的概念

要了解聚合操作，首先要建立Stream和管道的概念

Stream 和Collection结构化的数据不一样，Stream是一系列的元素，

就像是生产线上的罐头一样，一串串的出来。

管道指的是一系列的聚合操作。

管道又分3个部分

- 管道源：在这个例子里，源是一个List
- 中间操作： 每个中间操作，又会返回一个Stream，比如.filter()又返回一个Stream, 中间操作是“懒”操作，并不会真正进行遍历。
- 结束操作：当这个操作执行后，流就被使用“光”了，无法再被操作。所以这必定是流的最后一个操作。 结束操作不会返回Stream，但是会返回int、float、String、 Collection或者像forEach，什么都不返回, 结束操作才进行真正的遍历行为，在遍历的时候，才会去进行中间操作的相关判断

注： 这个Stream和I/O章节的InputStream,OutputStream是不一样的概念

### 管道源

数组需要使用Arrays.stream(hs)或者Stream.of(hs)的形式，后面才可以接链式方法，hs是数组

集合的话后面加.stream()就可以链式操作

```java
public class TestAggregate {
 
    public static void main(String[] args) {
        Random r = new Random();
        List<Hero> heros = new ArrayList<Hero>();
        for (int i = 0; i < 5; i++) {
            heros.add(new Hero("hero " + i, r.nextInt(1000), r.nextInt(100)));
        }
        //管道源是集合
        heros
        .stream()
        .forEach(h->System.out.println(h.name));
         
        //管道源是数组
        Hero hs[] = heros.toArray(new Hero[heros.size()]);
        Arrays.stream(hs)
        .forEach(h->System.out.println(h.name));
         
    }
}
```

`链式操作的核心就是每次一个方法操作完，将这个对象交给后面的继续操作，在java每次返回的都是stream`

中间的操作叫懒操作，运行到的时候不执行，等到运行到最后一个方法结束时，才一起执行

## lambda表达式

Lambda表达式可以看成是匿名类一点点演变过来

要使用lambda表达式的类只能是接口，并且里面只有方法，否则没法判定是哪个方法了



### lambda演变过程

```java
public class Test {
    public static void main(String[] args) {
        // 匿名类正常写法
        Hero h1 = new Hero(){
            public boolean add() {
                return true;
            }
        };

        // 去掉外面壳子，只保留方法参数和方法体
        Hero h2 = () -> {
            return true;
        };
        
        // 去掉return和{}
        Hero h3 = () -> true;
        
        // 还可以去掉()，当只有一个参数的时候Hero h4 = h -> true;
//        Hero h4 = h -> true;
    }
}
// 要实现lambda，必须是一个接口，且只能有一个方法
interface Hero {
    public boolean add();
}
```

## 新增集合方法使用

最后，我们再来看看JDK1.8中集合类新增的一些操作（之前没有提及的）首先来看看`compute`方法：

```java
public static void main(String[] args) {
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.compute(1, (k, v) -> {   //compute会将指定Key的值进行重新计算，若Key不存在，v会返回null
        return v+"M";     //这里返回原来的value+M
    });
  	map.computeIfPresent(1, (k, v) -> {   //当Key存在时存在则计算并赋予新的值
      return v+"M";     //这里返回原来的value+M
    });
    System.out.println(map);
}
```

也可以使用`computeIfAbsent`，当不存在Key时，计算并将键值对放入Map

```java
public static void main(String[] args) {
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.computeIfAbsent(0, (k) -> {   //若不存在则计算并插入新的值
        return "M";     //这里返回M
    });
    System.out.println(map);
}
```

merge方法用于处理数据：

```java
public static void main(String[] args) {
    List<Student> students = Arrays.asList(
            new Student("yoni", "English", 80),
            new Student("yoni", "Chiness", 98),
            new Student("yoni", "Math", 95),
            new Student("taohai.wang", "English", 50),
            new Student("taohai.wang", "Chiness", 72),
            new Student("taohai.wang", "Math", 41),
            new Student("Seely", "English", 88),
            new Student("Seely", "Chiness", 89),
            new Student("Seely", "Math", 92)
    );
    Map<String, Integer> scoreMap = new HashMap<>();
    students.forEach(student -> scoreMap.merge(student.getName(), student.getScore(), Integer::sum));
    scoreMap.forEach((k, v) -> System.out.println("key:" + k + "总分" + "value:" + v));
}

static class Student {
    private final String name;
    private final String type;
    private final int score;

    public Student(String name, String type, int score) {
        this.name = name;
        this.type = type;
        this.score = score;
    }

    public String getName() {
        return name;
    }

    public int getScore() {
        return score;
    }

    public String getType() {
        return type;
    }
}
```

