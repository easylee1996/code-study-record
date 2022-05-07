## 关系数据库mysql

mysql数据库是一个著名的关系型数据库



### 安装

- 下载MySQL Community Server版本：[MySQL :: Download MySQL Community Server (Archived Versions)](https://downloads.mysql.com/archives/community/)，选择合适的版本，不要选择arm架构m1的即可

- 直接安装即可

- 默认root密码设置为：rootroot，root太短，新版本不支持

- 配置环境变量

  ```shell
  //打开配置文件
  vim ~/.bash_profile
  
  // 然后将 /usr/local/mysql 配置到path
  MYSQL=/usr/local/mysql
  PATH=$MYSQL/bin:$PATH
  
  // 更新文件
  source ~/.bash_profile
  ```

- 查看是否启动

  ```shell
  // 所有服务都可以使用这个命令查看
  ps axu|grep mysql
  
  // 可以直接杀掉该程序pid
  kill -9 PID
  ```

  

### 基本使用

启动、停止、重启

```shell
sudo /usr/local/mysql/support-files/mysql.server start
sudo /usr/local/mysql/support-files/mysql.server stop
sudo /usr/local/mysql/support-files/mysql.server restart
```



### python基本使用

接入mysql并操作主要有五个步骤

- 1. 创建mysql连接
- 2. 连接后创建游标对象来操作sql
- 3. 执行sql操作
- 4. 提交事务
- 5. 操作回滚
- 6. 关闭并释放资源

```python
# 安装pymysql、cryptography是用于支持mysql8的密码验证方式
pip install pymysql cryptography

import pymysql
# 1. 创建连接（Connection）
conn = pymysql.connect(host='127.0.0.1', port=3306,
                       user='root', password='rootroot',
                       charset='utf8mb4')
# 包含数据库的连接
conn = pymysql.connect(host='127.0.0.1', port=3306,
                       user='guest', password='Guest.618',
                       database='hrs', charset='utf8mb4')
# 一定要在try里面执行
try:
    # 2. 获取游标对象（Cursor）
    with conn.cursor() as cursor:
        # 3. 通过游标对象向数据库服务器发出SQL语句，游标执行sql语句
        affected_rows = cursor.execute(sql)
        if affected_rows == 1:
            print('新增部门成功!!!')
    # 4. 提交事务（transaction）
    conn.commit()
# 5. 有错误回滚
except pymysql.MySQLError as err:
    conn.rollback()
    print(type(err), err)
finally:
    # 6. 关闭连接释放资源
    conn.close()
```



### 常用sql语句

执行sql语句常用这种方式，先写sql语句，不要写在execute方法里面，格式麻烦

```python
sql="""
    create table t_student(
    sno int primary key auto_increment,
    sname varchar(30) not null,
    age int(2),
    score float(3,1)
    ) 
"""

affected_rows = cursor.execute(sql)
```

常用sql语句

```python
# 创建数据库
CREATE DATABASE hrs

# 创建用户并设置权限
create user 'guest'@'%' identified by 'Guest.618';
grant insert, delete, update, select on `hrs`.* to 'guest'@'%';
```

