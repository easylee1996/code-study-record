## Java 集合概览

顶层接口有：collection

之后的子接口有List，Queue， Set；

还有一个单独的Map接口

List集合是有序可重复的，支持随即访问，List接口的实现类有LinkedList，ArrayList，Vector

LinkedList底层是双向链表，不支持随即访问，但是插入与删除效率较高，ArrayList支持随机访问，但是插入与删除效率较低

Vector是线程安全的，它在一些关键方法上加了synchronized

Set集合是无序不可重复的，不支持随机访问，根据equals和hashcode判断（如果一个对象要存储在Set中，必须重写equals和hashCode方法）

Map的存储方式是通过键值对的方式存储值的，键是唯一的，不可重复，value值是可重复的

## 把非线程安全的集合转换为线程安全

通过工具类Collections将线程不安全的集合类转为线程安全的

比如Collections.synchronizedList，可以把ArrayList转换为线程安全的List
