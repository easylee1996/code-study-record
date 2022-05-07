## 安装环境

- vmware Fusion
- Centos7.4
- termius-ssh链接和sftp文件传输



## 开始安装

### 创建虚拟机

>  拖入iso进入vmware fusion

![image-20211223180158418](assets/centos系统安装/image-20211223180158418.png)

>不使用快捷安装，后面自己配置

![image-20211223180235470](assets/centos系统安装/image-20211223180235470.png)

>  配置内存和硬盘

2核2G和30G即可，后期可以更改

![image-20211223180607931](assets/centos系统安装/image-20211223180607931.png)

### 开始安装

> 开始安装页面

![image-20211223180626928](assets/centos系统安装/image-20211223180626928.png)

> 选择预安装软件，最小化安装即可

![image-20211223180836648](assets/centos系统安装/image-20211223180836648.png)

> 选择安装位置，自动分配分区即可

![image-20211223180918011](assets/centos系统安装/image-20211223180918011.png)

![image-20211223180934517](assets/centos系统安装/image-20211223180934517.png)

> 开始安装即可，其余项暂时不配置

> 设置root密码，自己的使用用户，密码均为easylee
>
> 新建了一个easylee用户，密码也是easylee

## 网络配置

> 1.打开虚拟机网络配置-与我的Mac共享

![image-20211223210719473](assets/centos系统安装/image-20211223210719473.png)

> 2.分配固定内网ip地址

首先需要预先三个数据，进入mac一下的虚拟机网络配置目录查看

```bash
cd /Library/Preferences/VMware\ Fusion/vmnet8
```

- 本机网关和子网掩码

```bash
cat nat.conf
```

![image-20211223211736572](assets/centos系统安装/image-20211223211736572.png)

- 本机可以给虚拟机配置的静态ip范围

```bash
cat dhcpd.conf
```

![image-20211223211900183](assets/centos系统安装/image-20211223211900183.png)

ip地址选择这个范围内的都可以配置

- 查看本机DNS

![image-20211223211945093](assets/centos系统安装/image-20211223211945093.png)

![image-20211223211956978](assets/centos系统安装/image-20211223211956978.png)

![image-20211223212005563](assets/centos系统安装/image-20211223212005563.png)

> 3.开始配置虚拟机

- 打开虚拟机配置文件

```bash
vi /etc/sysconfig/network-scripts/ifcfg-ens33
```

非root用户一定要加sudo

![image-20211223212357796](assets/centos系统安装/image-20211223212357796.png)

- 重启网络服务

```bash
service network restart
```

- 查看网络是否联通

```bash
ping www.baidu.com
```



至此，centos就安装完毕了！