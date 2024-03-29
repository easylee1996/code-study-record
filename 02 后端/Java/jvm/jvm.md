---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# jvm概述

jvm即java虚拟机，是用于将所有支持java虚拟机规范的语言生成的字节码编译成机器指令的工具。

学习java虚拟机，通过字节码，我们可以发现一些实现相同功能的不同代码的真正区别是什么，如果去解决线上系统卡死、无法访问、OOM内存溢出等问题，如果手动处理和优化JVM GC垃圾回收，自定义配置JVM的参数等。

java虚拟机不仅仅是java的运行平台，目前很多语言都是使用jvm作为运行平台，同时Graal VM还可以支持所有的语言，是一个跨语言全栈虚拟机。

## jvm的相关特点

- 一次编译，到处运行：只需要编写一次java代码，可以在多个操作系统平台之上运行，这句话的真实含义是，编写的代码通过编译成字节码之后，运行在jvm之上，而不同操作系统的jvm都完整的支持。

- 多语言支持：只要将代码编译成支持jvm规范的字节码文件，任何语言都可以运行，包括自己创造的语言。

![image-20220606085051536](image-20220606085051536.png)

- 自动内存管理：不需要向C那样每次new操作都需要些对应的内存操作，但是正是因为如此，一旦出现内存泄漏和溢出就比较难处理
- 自动垃圾回收功能(GC)
