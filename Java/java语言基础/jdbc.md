---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# JDBC

JDBC (Java DataBase Connection) ，通过JAVA访问数据库



## 创建连接

### 导入jar包

File -> project Structure

最好导入到src的lib目录下，创建一个目录专门存放

![image-20220328213612515](image-20220328213612515-3132382.png)



### 下载对应的java驱动包

- 官网下载：[MySQL :: MySQL Community Downloads](https://dev.mysql.com/downloads/)
- mvn下载：[Maven Repository: mysql » mysql-connector-java (mvnrepository.com)](https://mvnrepository.com/artifact/mysql/mysql-connector-java)



下载java版本

![image-20220328215333697](image-20220328215333697-3132382.png)

下载平台依赖，选择tar下载即可

![image-20220328215433915](image-20220328215433915-3132382.png)

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

![image-20220328231946315](image-20220328231946315-3132382.png)



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

