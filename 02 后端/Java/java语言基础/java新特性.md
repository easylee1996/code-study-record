---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# Java8 新特性

参考视频：[2019-尚硅谷-*宋红康系列*-*Java8新特性*](http://www.bilibili.com/video/BV18J411x7XS)

参考网站：[Java8 新特性实战 | JavaGuide](https://javaguide.cn/java/new-features/java8-common-new-features.html#interface)

## Interface

提高接口的扩展性，在之前的版本中，如果接口进行了修改，添加了一两个方法，那么所有的实现类都需要进行修改，而大多数情况其中的大部分类是不需要这个方法的，特别的麻烦

新的Interface可以用default和static修饰添加方法，然后需要的实现类自己调用即可

1. `default`修饰的方法，是普通实例方法，可以用`this`调用，可以被子类继承、重写
2. `static`修饰的方法，使用上和一般类静态方法一样。但它不能被子类继承，只能用`Interface`调用
3. 如果同时实现了两个接口，都有同一个方法(假设一个是default修饰，一个是普通的接口方法)，那么必须重写这个方法，要不然会冲突

## Lambda 表达式

Lambda 是一个匿名函数，将一段代码向赋值一个数据一样赋值给变量，更加简洁，其实就是模仿其它编程语言的，要注意的是，在 java 中因为一切都是对象，所以整个 Lambda 表达式其实是一个接口的实例对象，而不像其它语言是一个函数。

> 要注意，可以使用 Lambda 表达式的一定是一个接口，并且接口只有一个方法，才能知道是执行的哪个方法

### 语法

总结而言，有6种形式

```java
public class LambdaTest {
    // 1. 无参，无返回值
    @Test
    public void test1() {
        Runnable r1 = new Runnable() {
            @Override
            public void run() {
                System.out.println("无参，无返回值");
            }
        };
        r1.run();
        System.out.println("***********改编后**********");
        Runnable r2 = () -> {System.out.println("无参，无返回值");};
        r2.run();
    }

    // 2. 有一个参数，无返回值
    @Test
    public void test2() {
        Consumer<String> con = new Consumer<String>() {
            @Override
            public void accept(String s) {
                System.out.println(s);
            }
        };
        con.accept("有一个参数，无返回值");
        System.out.println("***********改编后**********");
        Consumer<String> con1 = (String s) -> {
            System.out.println(s);
        };
        con1.accept("有一个参数，无返回值");  // 这个accept 就是 Consumer 接口的唯一方法
    }

    // 3. 数据类型可以省略，由编译器推断，成为类型推断，其实就是前面写上泛型或者由传入的参数类型推断
    @Test
    public void test3() {
        Consumer<String> con = new Consumer<String>() {
            @Override
            public void accept(String s) {
                System.out.println(s);
            }
        };
        con.accept("有一个参数，无返回值");
        System.out.println("***********改编后**********");
        Consumer<String> con1 = (s) -> {
            System.out.println(s);
        };
        con1.accept("有一个参数，无返回值");  // 这个accept 就是 Consumer 接口的唯一方法
    }

    // 4. 有多个参数，多条执行语句，有返回值
    @Test
    public void test4() {
        Comparator<Integer> com1 = new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                System.out.println(o1);
                System.out.println(o2);
                return o1.compareTo(o2);
            }
        };
        System.out.println(com1.compare(12,35));
        System.out.println("***********改编后**********");
        Comparator<Integer> com2 = (o1, o2) -> {
            System.out.println(o1);
            System.out.println(o2);
            return o1.compareTo(o2);
        };
        System.out.println(com1.compare(12,5));
    }

    // 5. 只有一条语句，大括号和return也可以省略
    @Test
    public void test5() {
        Comparator<Integer> com1 = new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                return o1.compareTo(o2);
            }
        };
        System.out.println(com1.compare(12,35));
        System.out.println("***********改编后**********");
        Comparator<Integer> com2 = (o1, o2) -> o1.compareTo(o2);

        System.out.println(com1.compare(12,5));
    }

    // 6. 只有一条语句，大括号和return也可以省略，同时连参数也可以省略，使用两个冒号的形式
    @Test
    public void test6() {
        Comparator<Integer> com1 = new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                return o1.compareTo(o2);
            }
        };
        System.out.println(com1.compare(12,35));
        System.out.println("***********改编后**********");
        Comparator<Integer> com2 = Integer::compareTo;

        System.out.println(com1.compare(12,5));
    }
}
```

### 总结

->符号左边：参数类型可以省略，只有一个参数，那么括号也可以省略

->符号右边：只有一条执行语句(可能是return语句)，可以省略 {} 和 return 关键字

## 函数式接口

如果一个接口中，只声明了一个抽象方法，这个接口就称为函数式接口，可以给接口添加上 @Functionallnterface 注解，表示是一个函数式接口，通常函数式接口可以用 Lambda 表达式来表示，以前一般是用的匿名接口

### 内置四大核心函数式接口

**如果写的一个接口可以用这些官方的函数式接口表示，那么就没有必要再自己创建接口了**，直接用就可以

- Consumer<T>：消费型接口，传入一个对象进行消费，然后返回一些东西，消费东西

```java
public class Test2 {
    @Test
    public void test1() {
        // 消费 money 这个对象
        happyTime(500, money -> System.out.println(money));
        // 一个参数，可以写成双冒号的形式，只需要写成具体调用的实例对象::方法
        happyTime(500, System.out::println);
    }

    public void happyTime(double money, Consumer<Double> con) {
        con.accept(money);
    }
}
```

- Supplier<T>：供给型接口，不传入参数，但是要返回东西，可不就是供给嘛
- Funtion<T,R>：函数型接口，传入参数T，返回R类型，就是一个函数的形式
- Predicate<T>：断定型接口，传入参数，判断是否满足要求，然后返回 boolean

```java
public class Test2 {
    @Test
    public void test() {
        List<String> list = Arrays.asList("北京","南京","天津");
        List<String> list1 = filterString(list, s -> s.contains("京"));
        // 这里 String::contains 因为 contains 不是静态方法，所以不能使用双冒号的形式
        // List<String> list1 = filterString(list, String::contains("京"));
        System.out.println(list1);
    }
    // 根据给定的规则，过滤集合中的字符串，规则由裁定接口的具体实现方法决定
    public List<String> filterString(List<String> list, Predicate<String> pre) {
        ArrayList<String> filterList = new ArrayList<>();

        for (String s: list) {
            if (pre.test(s)) filterList.add(s);
        }
        return filterList;
    }
}
```

其它函数式接口，后期了解

![image-20220620171053741](image-20220620171053741.png)

## 方法引用

当要传递给Lambda体的操作，已经有了实现的方法了，就可以使用方法引用，也是Lambda的更简便的使用形式，当然也是函数式接口的实例了

**简单来说，方法引用就是直接引用一些类的方法来直接代替函数式接口的那个唯一方法**

### 方法引用

具体由下面三种使用情景：

- 对象::非静态方法

```java
public class Test2 {
    // Consumer中的 void accept(T t)
    // PrintStream中的void println(T t)
    @Test
    public void test1() {
        Consumer<String> con1 = str -> System.out.println(str);
        con1.accept("北京");

        PrintStream ps = System.out;
        Consumer<String> con2 = ps :: println;  // 不传参数，因为lambda的accpet也不传参数
        con2.accept("成都");
    }
}
```

> 使用场景：当要传递给Lambda体的操作，已经有实现的方法了，可以使用方法引用，也就是引用方法可以代替Lambda体中要重写的方法
>
> 要求：接口中的抽象方法的形参列表和返回值类型和方法引用的方法的形参列表和返回值类型一样

- 类::静态方法

```java
public class Test2 {
   //Comparator中的int compare(T t1, T t2)
    //Integer中的int compare(T t1, T t2)
    @Test
    public void test1() {
        Comparator<Integer> com1 = (t1, t2) -> Integer.compare(t1, t2);
        System.out.println(com1.compare(12,21));
        Comparator<Integer> com2 = Integer::compare;
        System.out.println(com2.compare(3,2));
    }
}
```

> 使用场景：当要传递给Lambda体的操作，已经有实现的方法了，可以使用方法引用，也就是引用方法可以代替Lambda体中要重写的方法
>
> 要求：接口中的抽象方法的形参列表和返回值类型和方法引用的方法的形参列表和返回值类型一样

- 类::非静态方法

```java
public class Test2 {
    // Comparator中的int compare(T t1, T t2)
    // String中的int t1.compareTo(t2)
    @Test
    public void test1() {
        Comparator<String> com1 = (s1, s2) -> s1.compareTo(s2);
        System.out.println(com1.compare("abc","adc"));
        Comparator<String> com2 = String::compareTo;
        System.out.println(com2.compare("abc","abc"));
    }
}
```

> 使用场景：当要传递给Lambda体的操作，已经有实现的方法了，可以使用方法引用，也就是引用方法可以代替Lambda体中要重写的方法
>
> 要求：返回值类型还是一样，只是一个参数用在了前面，一个用在后面为参数，还是一样的其实
>
> 另外一种：
>
> Function中的R apply(T t)
>
> User中的String getName  // 这个没有参数，上面有一个参数，其实是把这个T用在了前面，t.getName底层实际上和上面还是一样的，都有一个参数，写法就是 T::getName;

### 构造器引用

- 空参构造器

```java
public class Test2 {
    // 构造器引用
    // Supplier中的T get()
    // User中的空参构造器：User()
    @Test
    public void test1() {
        Supplier<User> sup = () -> new User();
        System.out.println(sup.get());
        Supplier<User> sup1 = User::new;
        System.out.println(sup1.get());
    }
}
class User {
    private String name;
    public User() {
        
    }
}
```

- 一个参数的构造器

```java
public class Test2 {
    @Test
    public void test1() {
        Function<String,User> func1 = s -> new User(s);
        System.out.println(func1.apply("easylee"));
        Function<String,User> func2 = User::new;
        System.out.println(func1.apply("easylee1"));
    }
}
class User {
    private String name;

    public User(String s) {
        this.name = s;
    }
}
```

- 两个参数的构造器：使用BiFunction函数式接口

### 数组引用

```java
public class Test2 {
    @Test
    public void test() {
        Function<Integer,String[]> func1 = length -> new String[length];
        String[] arr1 = func1.apply(5);
        System.out.println(Arrays.toString(arr1));
        Function<Integer,String[]> func2 = String[]::new;
        String[] arr2 = func2.apply(5);
        System.out.println(Arrays.toString(arr2));
    }
}
```

数组引用就是构造器引用，把new String[]看成一个类，函数式接口就是作为其的构造器，传递一个参数的构造器引用

> 总体来说，这些都是语法问题，多用多看慢慢就熟练了

## Stream

流就是对Collection、Array等集合数据进行一系列操作，返回出特定的集合，要注意Stream不存储数据，只是中间处理，就和Sql语句一样。

流包括stream 串行流和parallelStream并行流，可多线程执行

### 常用方法

```java
public class Test2 {
    @Test
    public void test() {
        List<String> strings = Arrays.asList("abc","def","gkh","abc");
        // 筛选-符合条件的Stream
        Stream<String> stringStream = strings.stream().filter("abc"::equals);
        long count = stringStream.count();

        // forEach遍历
        strings.stream().forEach(System.out::println);

        //limit 获取到1个元素的stream
        Stream<String> limit = strings.stream().limit(1);
        //toArray 比如我们想看这个limitStream里面是什么，比如转换成String[],比如循环
        String[] array = limit.toArray(String[]::new);

        //map 对每个元素进行操作返回新流
        Stream<String> map = strings.stream().map(s -> s + "22");

        //sorted 排序并打印
        strings.stream().sorted().forEach(System.out::println);

        //Collectors collect 把abc放入容器中
        List<String> collect = strings.stream().filter(string -> "abc".equals(string)).collect(Collectors.toList());
        //把list转为string，各元素用，号隔开
        String mergedString = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.joining(","));

        //对数组的统计，比如用
        List<Integer> number = Arrays.asList(1, 2, 5, 4);

        IntSummaryStatistics statistics = number.stream().mapToInt((x) -> x).summaryStatistics();
        System.out.println("列表中最大的数 : "+statistics.getMax());
        System.out.println("列表中最小的数 : "+statistics.getMin());
        System.out.println("平均数 : "+statistics.getAverage());
        System.out.println("所有数之和 : "+statistics.getSum());

        //concat 合并流
        List<String> strings2 = Arrays.asList("xyz", "jqx");
        Stream.concat(strings2.stream(),strings.stream()).count();

        //注意 一个Stream只能操作一次，不能断开，否则会报错。
        Stream stream = strings.stream();
        //第一次使用
        stream.limit(2);
        //第二次使用
        stream.forEach(System.out::println);
        //报错 java.lang.IllegalStateException: stream has already been operated upon or closed

        //但是可以这样, 连续使用
        stream.limit(2).forEach(System.out::println);
    }
}
```

> 要注意，Stream的中间方法并不是立即执行的，而是执行到**非Stream方法**时才开始执行，比如forEach，执行一个非Stream方法之后就结束了，再操作这个Stream会报错，应该新开一个

## Optionnal类

`Optional`类是用来保证不报`NullPointerException`空指针异常的一个封装类

看下面的情况：

```java
class Zoo {
    // 属性是另外一个对象
    private Dog dog;

    public Dog getDog() {
        return dog;
    }
}

class Dog {
    private int age;

    public int getAge() {
        return age;
    }
}
```

当我们执行下面的方法时，会报空指针异常：

```java
public class Test2 {
    @Test
    public void test() {
        System.out.println(new Zoo().getDog().getAge());
    }
}
```

这是因为Zoo对象的`getDog()`是null，不是一个对象，那么必然不误调用null的方法

所以在以前的时候我们需要这样来判断是否为null：

```java
Zoo zoo = getZoo();
if(zoo != null){
   Dog dog = zoo.getDog();
   if(dog != null){
      int age = dog.getAge();
      System.out.println(age);
   }
}
```

现在有了Optional之后，可以更方便的判断是否为空，以及是空怎么操作，不是空怎么操作：

简单来说Optional主要有`Optional.of()`和`Optional.ofNuLLable()`两个方法：里面都是传入对象，但这个对象为空，Optional.of则会抛出异常，而Optional.ofNuLLable只会返回null，不会抛出异常

