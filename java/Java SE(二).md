# 泛型

为了统计学生成绩，要求设计一个Score对象，包括课程名称、课程号、课程成绩，但是成绩分为两种，一种是以`优秀、良好、合格` 来作为结果，还有一种就是 `60.0、75.5、92.5` 这样的数字分数，那么现在该如何去设计这样的一个Score类呢？现在的问题就是，成绩可能是`String`类型，也可能是`Integer`类型，如何才能很好的去存可能出现的两种类型呢？

```java
public class Score {
    String name;
    String id;
    Object score;  //因为Object是所有类型的父类，因此既可以存放Integer也能存放String

  	public Score(String name, String id, Object score) {
        this.name = name;
        this.id = id;
        this.score = score;
    }
}
```

以上的方法虽然很好地解决了多种类型存储问题，但是Object类型在编译阶段并不具有良好的类型判断能力，很容易出现以下的情况：

```java
public static void main(String[] args) {

    Score score = new Score("数据结构与算法基础", "EP074512", "优秀");  //是String类型的

    //....

    Integer number = (Integer) score.score;  //获取成绩需要进行强制类型转换，虽然并不是一开始的类型，但是编译不会报错
}

//运行时出现异常！
Exception in thread "main" java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer
	at com.test.Main.main(Main.java:14)
```

使用Object类型作为引用，取值只能进行强制类型转换，显然无法在编译期确定类型是否安全，项目中代码量非常之大，进行类型比较又会导致额外的开销和增加代码量，如果不经比较就很容易出现类型转换异常，代码的健壮性有所欠缺！（此方法虽然可行，但并不是最好的方法）

为了解决以上问题，JDK1.5新增了泛型，它能够在编译阶段就检查类型安全，大大提升开发效率。

```java
public class Score<T> {   //将Score转变为泛型类<T>
    String name;
    String id;
    T score;  //T为泛型，根据用户提供的类型自动变成对应类型

    public Score(String name, String id, T score) {   //提供的score类型即为T代表的类型
        this.name = name;
        this.id = id;
        this.score = score;
    }
}
```

```java
public static void main(String[] args) {
    //直接确定Score的类型是字符串类型的成绩
    Score<String> score = new Score<String>("数据结构与算法基础", "EP074512", "优秀");

    Integer i = score.score;  //编译不通过，因为成员变量score类型被定为String！
}
```

`泛型将数据类型的确定控制在了编译阶段，在编写代码的时候就能明确泛型的类型`！如果类型不符合，将无法通过编译！

`泛型本质上也是一个语法糖（并不是JVM所支持的语法，编译后会转成编译器支持的语法，比如之前的foreach就是），在编译后会被擦除，变回上面的Object类型调用，但是类型转换由编译器帮我们完成，而不是我们自己进行转换（安全）`

```java
//反编译后的代码
public static void main(String[] args) {
        Score score = new Score("数据结构与算法基础", "EP074512", "优秀");
  			//其实依然会变为强制类型转换，但是这是由编译器帮我们完成的
        String i = (String)score.score;   
    }
```

像这样在编译后泛型的内容消失转变为Object的情况称为`类型擦除`（重要，需要完全理解），所以泛型只是为了方便我们在编译阶段确定类型的一种语法而已，并不是JVM所支持的。

综上，泛型其实就是一种类型参数，用于指定类型。

## 泛型的使用

### 泛型类

上一节我们已经提到泛型类的定义，实际上就是普通的类多了一个类型参数，也就是在使用时需要指定具体的泛型类型。泛型的名称一般取单个大写字母，比如T代表Type，也就是`类型`的英文单词首字母，当然也可以添加数字和其他的字符。

```java
public class Score<T> {   //将Score转变为泛型类<T>
    String name;
    String id;
    T score;  //T为泛型，根据用户提供的类型自动变成对应类型

    public Score(String name, String id, T score) {   //提供的score类型即为T代表的类型
        this.name = name;
        this.id = id;
        this.score = score;
    }
}
```

在一个普通类型中定义泛型，泛型T称为`参数化类型`，在定义泛型类的引用时，需要明确指出类型：

```java
 Score<String> score = new Score<String>("数据结构与算法基础", "EP074512", "优秀");
```

此时类中的泛型T已经被替换为String了，在我们获取此对象的泛型属性时，编译器会直接告诉我们类型：

```java
Integer i = score.score;   //编译不通过，因为成员变量score明确为String类型
```

注意，泛型只能用于对象属性，也就是非静态的成员变量才能使用：

```java
static T score;   //错误，不能在静态成员上定义
```

由此可见，`泛型是只有在创建对象后编译器才能明确泛型类型，而静态类型是类所具有的属性，不足以使得编译器完成类型推断。`

`泛型无法使用基本类型`，如果需要基本类型，只能使用基本类型的包装类进行替换！

```java
Score<double> score = new Score<double>("数据结构与算法基础", "EP074512", 90.5);  //编译不通过
```

那么为什么泛型无法使用基本类型呢？回想上一节提到的类型擦除，其实就很好理解了。由于JVM没有泛型概念，因此泛型最后还是会被编译器编译为Object，并采用强制类型转换的形式进行类型匹配，而我们的`基本数据类型和引用类型之间无法进行类型转换`，所以只能使用基本类型的包装类来处理。

### 类的泛型方法

泛型方法的使用也很简单，我们只需要把它当做一个未知的类型来使用即可：

```java
public T getScore() {    //若方法的返回值类型为泛型，那么编译器会自动进行推断
  return score;
}

public void setScore(T score) {   //若方法的形式参数为泛型，那么实参只能是定义时的类型
  this.score = score;
}
```

```java
Score<String> score = new Score<String>("数据结构与算法基础", "EP074512", "优秀");
score.setScore(10);   //编译不通过，因为只接受String类型
```

同样地，静态方法无法直接使用类定义的泛型（注意是无法直接使用，静态方法可以使用泛型，在方法里面和参数可以定义自己的泛型参数）

### 自定义泛型方法

那么如果我想在静态方法中使用泛型呢？首先我们要明确之前为什么无法使用泛型，因为之前我们的泛型定义是在类上的，只有`明确具体的类型才能开始使用，也就是创建对象时完成类型确定`，但是静态方法不需要依附于对象，那么只能在使用时再来确定了，所以静态方法可以使用泛型，但是需要单独定义：

```java
public static <E> void test(E e){   //在方法定义前声明泛型
  System.out.println(e);
}
```

同理，成员方法也能自行定义泛型，在实际使用时再进行类型确定：

```java
public <E> void test(E e){
  System.out.println(e);
}
```

其实，无论是泛型类还是泛型方法，再使用时一定要能够进行类型推断，明确类型才行。

注意一定要区分类定义的泛型和方法前定义的泛型！

### 泛型引用

可以看到我们在定义一个泛型类的引用时，需要在后面指出此类型：

```java
Score<Integer> score;  //声明泛型为Integer类型
```

如果不希望指定类型，或是希望此引用类型可以引用任意泛型的`Score`类对象，可以使用`?`通配符，来表示自动匹配任意的可用类型：

```java
Score<?> score;   //score可以引用任意的Score类型对象了！
```

那么使用通配符之后，得到的泛型成员变量会是什么类型呢？

```java
Object o = score.getScore();   //只能变为Object
```

因为使用了通配符，编译器就无法进行类型推断，所以只能使用原始类型。

在学习了泛型的界限后，我们还会继续了解通配符的使用。

### 泛型的界限

现在有一个新的需求，现在没有String类型的成绩了，但是成绩依然可能是整数，也可能是小数，这时我们不希望用户将泛型指定为除数字类型外的其他类型，我们就需要使用到泛型的上界定义：

```java
public class Score<T extends Number> {   //设定泛型上界，必须是Number的子类
    private final String name;
    private final String id;
    private T score;

    public Score(String name, String id, T score) {
        this.name = name;
        this.id = id;
        this.score = score;
    }

    public T getScore() {
        return score;
    }
}
```

通过`extends`关键字进行上界限定，只有指定类型或指定类型的子类才能作为类型参数。

同样的，泛型通配符也支持泛型的界限：

```java
Score<? extends Number> score;  //限定为匹配Number及其子类的类型
```

同理，既然泛型有上限，那么也有下限：

```java
Score<? super Integer> score;   //限定为匹配Integer及其父类
```

通过`super`关键字进行下界限定，只有指定类型或指定类型的父类才能作为类型参数。

图解如下：

![png](assets/Java SE(二)/b_0_201912091523263309.png)

![png](assets/Java SE(二)/b_0_201912091523264595.jpg)

那么限定了上界后，我们再来使用这个对象的泛型成员，会变成什么类型呢？

```java
Score<? extends Number> score = new Score<>("数据结构与算法基础", "EP074512", 10);
Number o = score.getScore();    //得到的结果为上界类型
```

也就是说，一旦我们指定了上界后，编译器就将范围从原始类型`Object`提升到我们指定的上界`Number`，但是依然无法明确具体类型。思考：那如果定义下限呢？

那么既然我们可以给泛型类限定上界，现在我们来看编译后结果呢：

```java
//使用javap -l 进行反编译
public class com.test.Score<T extends java.lang.Number> {
  public com.test.Score(java.lang.String, java.lang.String, T);
    LineNumberTable:
      line 8: 0
      line 9: 4
      line 10: 9
      line 11: 14
      line 12: 19
    LocalVariableTable:
      Start  Length  Slot  Name   Signature
          0      20     0  this   Lcom/test/Score;
          0      20     1  name   Ljava/lang/String;
          0      20     2    id   Ljava/lang/String;
          0      20     3 score   Ljava/lang/Number;   //可以看到score的类型直接被编译为Number类

  public T getScore();
    LineNumberTable:
      line 15: 0
    LocalVariableTable:
      Start  Length  Slot  Name   Signature
          0       5     0  this   Lcom/test/Score;
}

```

因此，一旦确立上限后，编译器会自动将类型提升到上限类型。

### 钻石运算符

我们发现，每次创建泛型对象都需要在前后都标明类型，但是实际上后面的类型声明是可以去掉的，因为我们在传入参数时或定义泛型类的引用时，就已经明确了类型，因此JDK1.7提供了钻石运算符来简化代码：

```java
Score<Integer> score = new Score<Integer>("数据结构与算法基础", "EP074512", 10);  //1.7之前

Score<Integer> score = new Score<>("数据结构与算法基础", "EP074512", 10);  //1.7之后
```

### 泛型与多态

泛型不仅仅可以可以定义在类上，同时也能定义在接口上：

```java
public interface ScoreInterface<T> {
    T getScore();
    void setScore(T t);
}
```

当实现此接口时，我们可以选择在实现类明确泛型类型或是继续使用此泛型，让具体创建的对象来确定类型。

```java
public class Score<T> implements ScoreInterface<T>{   //将Score转变为泛型类<T>
    private final String name;
    private final String id;
    private T score;

    public Score(String name, String id, T score) { 
        this.name = name;
        this.id = id;
        this.score = score;
    }

    public T getScore() {
        return score;
    }

    @Override
    public void setScore(T score) {
        this.score = score;
    }
}
```

```java
public class StringScore implements ScoreInterface<String>{   //在实现时明确类型

    @Override
    public String getScore() {
        return null;
    }

    @Override
    public void setScore(String s) {

    }
}
```

抽象类同理，这里就不多做演示了。

### 多态类型擦除

思考一个问题，既然继承后明确了泛型类型，那么为什么`@Override`不会出现错误呢，重写的条件是需要和父类的返回值类型、形式参数一致，而`泛型默认的原始类型是Object类型`，子类明确后变为Number类型，这显然不满足重写的条件，但是为什么依然能编译通过呢？

```java
class A<T>{
    private T t;
    public T get(){
        return t;
    }
    public void set(T t){
        this.t=t;
    }
}

class B extends A<Number>{
    private Number n;

    @Override
    public Number get(){   //这并不满足重写的要求，因为只能重写父类同样返回值和参数的方法，但是这样却能够通过编译！
        return t;
    }

    @Override
    public void set(Number t){
        this.t=t;
    }
}
```

通过反编译进行观察，实际上是编译器帮助我们生成了两个桥接方法用于支持重写：

```java
@Override
// 编译器生成添加了Object的重写方法，T泛型和Object就可以匹配重写了，然后再调用我们的方法，就是桥接了一下，我们的不满足，弄一个满足的然后调用我们的方法
public Object get(){
  return this.get();//调用返回Number的那个方法
}

@Override
public void set(Object t ){
  this.set((Number)t ); //调用参数是Number的那个方法
}
```

## 泛型通配符

### 常见标识

- E — Element，常用在java Collection里，如：List<E>,Iterator<E>,Set<E>
- K,V — Key，Value，代表Map的键值对
- N — Number，数字
- T — Type，类型，如String，Integer等等
- S,U,V etc. - 2nd, 3rd, 4th 类型，和T的用法一样
- ？标识不确定的java类型

本质上这些都是通配符，没啥区别，只不过是编码时的一种约定俗成的东西。比如上述代码中的 T ，我们可以换成 A-Z 之间的任何一个 字母都可以，并不会影响程序的正常运行，但是如果换成其他的字母代替 T ，在可读性上可能会弱一些。



### 上界通配符< ? extends E>

表示这个泛型只能是E或者E的子类

```java
private <K extends A, E extends B> E test(K arg1, E arg2){
    E result = arg2;
    arg2.compareTo(arg1);
    //.....
    return result;
}
```



### 下界通配符 < ? super E>

表示这个泛型只能是E或者E的父类

```java
private <T> void test(List<? super T> dst, List<T> src){
    for (T t : src) {
        dst.add(t);
    }
}

public static void main(String[] args) {
    List<Dog> dogs = new ArrayList<>();
    List<Animal> animals = new ArrayList<>();
    new Test3().test(animals,dogs);
}
// Dog 是 Animal 的子类
class Dog extends Animal {

}
```



# 集合

## 认识集合类

集合表示一组对象，称为其元素。一些集合允许重复的元素，而另一些则不允许。一些集合是有序的，而其他则是无序的。

集合类其实就是为了更好地组织、管理和操作我们的数据而存在的，包括列表、集合、队列、映射等数据结构。从这一块开始，我们会从源码角度给大家讲解（数据结构很重要！），不仅仅是教会大家如何去使用。

集合类最顶层不是抽象类而是接口，因为接口代表的是某个功能，而抽象类是已经快要成形的类型，不同的集合类的底层实现是不相同的，同时一个集合类可能会同时具有两种及以上功能（既能做队列也能做列表），所以采用接口会更加合适，接口只需定义支持的功能即可。

![img](assets/Java SE(二)/src=http%3A%2F%2Fwww.mianfeiwendang.com%2Fpic%2F29a5b61e9e5e19fe10103b4c%2F1-356-jpg_6_0_______-858-0-0-858.jpg&refer=http%3A%2F%2Fwww.mianfeiwendang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

### 数组与集合

相同之处：

1. 它们都是容器，都能够容纳一组元素。

不同之处：

1. 数组的大小是固定的，集合的大小是可变的。
2. 数组可以存放基本数据类型，但集合只能存放对象。
3. 数组存放的类型只能是一种，但集合可以有不同种类的元素。



## Collection接口

本接口中定义了全部的集合基本操作，我们可以在源码中看看。

Collection包含List和Set，是单列集合，也就是说里面的数据都是单列的



### Collection接口常用方法

```java
// 以ArrayList为例
Collection col = new ArrayList();

// 1. add()添加元素
col.add(111);
col.add(new Object());
col.add("nihao");

// 2. clear()：清空集合中所有的元素
// 3. remove(E e)：移除集合中指定的元素
// 4. contains(E e)：检查集合中是否包含指定的对象
// 5. isEmpty()：判断集合是否为空
// 6. size()：判断集合中元素的个数
// 7. toArray()：把集合元素存储到数组中
```

### 其它常用方法

- Object max(Collection)：根据元素的自然顺序，返回给定集合中的最大
  元素
- Object max(Collection, Comparator)：根据 Comparator 指定的顺序，
  返回给定集合中的最大元素，就是传入一个匿名内部类，其中有一个compare方法，会自动去调用这个方法，这个方法返回-1，0, 1，用于判断大小
- Object min (Collection)
- Object min(Collection, Comparator)
- int frequency (Collection, Object)：返回指定集合中指定元素的出现次
  数
- void copy(List dest, List src)：将src中的内容复制到dest中
- boolean replaceAll (List list,Object oldVal, Object newVal)：使用
  新值替换 List 对象的所有旧值

## 迭代器

### 集合的遍历

所有的集合类，都支持foreach循环！

```java
public static void main(String[] args) {
    List<Integer> list = new LinkedList<Integer>(){   //Java9才支持匿名内部类使用钻石运算符
        {
            this.add(10);
            this.add(2);
            this.add(5);
            this.add(8);
        }
    };
    for (Integer integer : list) {
        System.out.println(integer);
    }
}
```

当然，也可以使用JDK1.8新增的forEach方法，它接受一个Consumer接口实现：

```java
list.forEach(i -> {
    System.out.println(i);
});
```

从JDK1.8开始，lambda表达式开始逐渐成为主流，我们需要去适应函数式编程的这种语法，包括批量替换，也是用到了函数式接口来完成的。

```java
list.replaceAll((i) -> {
  if(i == 2) return 3;   //将所有的2替换为3
  else return i;   //不是2就不变
});
System.out.println(list);
```

### Iterable和Iterator接口

我们之前学习数据结构时，已经得知，不同的线性表实现，在获取元素时的效率也不同，因此我们需要一种更好地方式来统一不同数据结构的遍历。

由于ArrayList对于随机访问的速度更快，而LinkedList对于顺序访问的速度更快，因此在上述的传统for循环遍历操作中，ArrayList的效率更胜一筹，因此我们要使得LinkedList遍历效率提升，就需要采用顺序访问的方式进行遍历，如果没有迭代器帮助我们统一标准，那么我们在应对多种集合类型的时候，就需要对应编写不同的遍历算法，很显然这样会降低我们的开发效率，而迭代器的出现就帮助我们解决了这个问题。

我们先来看看迭代器里面方法：

```java
public interface Iterator<E> {
  //...
}
```

每个集合类都有自己的迭代器，通过`iterator()`方法来获取：

```java
Iterator<Integer> iterator = list.iterator();   //生成一个新的迭代器
while (iterator.hasNext()){    //判断是否还有下一个元素
  Integer i = iterator.next();     //获取下一个元素（获取一个少一个）
  System.out.println(i);
}
```

迭代器生成后，默认指向第一个元素，每次调用`next()`方法，都会将指针后移，当指针移动到最后一个元素之后，调用`hasNext()`将会返回`false`，迭代器是一次性的，用完即止，如果需要再次使用，需要调用`iterator()`方法。

```java
ListIterator<Integer> iterator = list.listIterator();   //List还有一个更好地迭代器实现ListIterator
```

`ListIterator`是List中独有的迭代器，在原有迭代器基础上新增了一些额外的操作。

## List

List类主要包含ArrayList和Vector



### 常用方法

```java
// List接口常用方法
List list = new ArrayList();
list.add(111);
list.add(222);

// 1) void add (int index, Object ele):在index位置插入ele元素
list.add(1,333);

// 2) boolean addAll(int index, Collection eles):从index位置开始将eles中的所有元素添加进来，添加另外一个集合元素

// 3) Object get(int index);获取指定index位置的元素
System.out.println(list.get(2));

// 4) int indexOf(Object obj);返口obj在集合中首次出现的位置
System.out.println(list.indexOf(222));

// 5)int lastindexOf(Object obj);返口obj在当前集合中未次出现的位置

// 6) Object remove (int index) ：移除指定index位置的元素，并返回此元素
list.remove(2);
// 7) Objegt set(int index, Object ele)-设置指定index位置的元素为ele,相当子是替换.
list.set(0, 444);

// 8) List subList(int fromlndex, int tolndex):返回从fromlndex到tolndex位置的子集合

for (Object item:list) {
System.out.println(item);
}
```

### 集合的排序

```java
List<Integer> list = new LinkedList<Integer>(){   //Java9才支持匿名内部类使用钻石运算符
    {
        this.add(10);
        this.add(2);
        this.add(5);
        this.add(8);
    }
};
list.sort((a, b) -> {    //排序已经由JDK实现，现在只需要填入自定义规则，完成Comparator接口实现
  return a - b;    //返回值小于0，表示a应该在b前面，返回值大于0，表示b应该在a后面，等于0则不进行交换
});
System.out.println(list);
```

### 使用细节

- list集合类中元素是有序的，即添加顺序和取出顺序一致、且可以重复
- List集合中的每个元素都有其对应的顺序索引，即支持索引



### ArrayList类

`使用细节`

- ArrayList 可以加入null并且多个
- ArrayList 是由数组来实现数据存储的
- ArrayList基本等同于Vector
- 线程不安全，执行效率高



`底层分析`

- ArrayList中维护了一个Object类型的数组elementData，用于存储数据，也就是说ArrayList是使用数组储存数据的
- 当创建ArrayList对象时，如果使用的是无参构造器，则初始elementData容量为0，第1次添加，则扩容elementData为10，如需要再次扩容，则扩容elementData为1.5倍
- 如果使用的是指定大小的构造器，则初始elementData容量为指定大小，如果需要扩容
  则直接扩容elementData为1.5倍。



### Vector类

`使用细节`

- 线程是同步的，当使用多线程时，有限考虑Vector



`底层分析`

- 底层也是一个对象数组



### LinkedList类

`使用细节`

- 可以添加任意元素，元素可以重复，包括null
- 线程不安全，没有实现同步



`底层分析`

- LinkedList底层是使用双向链表和双端队列

![image-20220315183535547](assets/Java SE(二)/image-20220315183535547.png)

- LinkedList中维护了两个属性first和last分别指向首节点和尾节点
- 每个节点 (Node对象），里面又维护了prev、next、item三个属性，其中通过
  prev指向前一个，通过next指向后个节点，最终实现双向链表
- 所以LinkedList的元素的添加和删除，不是通过数组完成的，`相对来说效率较高`，因为不涉及到数组的扩容，只是把对象元素和元素之间用一个prev和next属性连接起来



### 类对比

![image-20220315183112088](assets/Java SE(二)/image-20220315183112088.png)

![image-20220315183908615](assets/Java SE(二)/image-20220315183908615.png)



`如何选择`

- 改查操作多，选择ArrayList，或Vecotr(多线程)，因为有索引
- 增删操作多，选择LinkedList，因为只是使用一个属性连接，增加删除只是改变属性的内容而已，不需要扩容等操作
- 一般来说，在程序中，80%-90%都是查询，因此大部分情况下会选择ArrayList
- 在一个项目中，根据业务灵活选择，也可能这样，一个模块使用的是Arraylist,另一个模块是LinkedList



## Set集合

Set接口中定义的方法都是Collection中直接继承的，因此，Set支持的功能其实也就和Collection中定义的差不多，只不过使用方法上稍有不同。



### Set集合特点

- Set接口都是无序的，没有索引，不支持随机访问（不允许通过下标访问）
- 不允许重复元素，所以最多包含一个null



### HashSet类

HashSet的底层就是采用哈希表实现的

```java
public static void main(String[] args) {
    HashSet<Integer> set = new HashSet<>();
    set.add(120);    //支持插入元素，但是不支持指定位置插入
    set.add(13);
    set.add(11);
    for (Integer integer : set) {
      System.out.println(integer);
    }
}
```

运行上面代码发现，最后`Set集合中存在的元素顺序，并不是我们的插入顺序`，这是因为HashSet底层是采用`哈希表`来实现的，实际的存放顺序是由Hash算法决定的。

#### 使用细节

- 可以存放null值，但是只能有一个null，因为不允许重复
- HashSet不保证元素是有序的，是根据hash值确定具体的索引，不由添加的时间确定顺序
- 不允许重复元素/对象



#### 底层分析

- HashSet实际上是HashMap
- 底层结构是数组 + 链表 + 红黑树：简单来讲就是首先一个数组，每个格子里面一个链表，当数组长度大于64，链表就会进行树化，而不再是一个单纯的直线链表

![image-20220315190149096](assets/Java SE(二)/image-20220315190149096.png)



### LinkedHashSet类

LinkedHashSet类是HashSet类的子类，`会将插入的元素按照插入顺序保存`

```java
public static void main(String[] args) {
    LinkedHashSet<Integer> set = new LinkedHashSet<>();  //会自动保存我们的插入顺序
    set.add(120);
    set.add(13);
    set.add(11);
    for (Integer integer : set) {
        System.out.println(integer);
    }
}
```

LinkedHashSet底层维护的不再是一个HashMap，而是LinkedHashMap，它能够在插入数据时利用链表自动维护顺序，因此这样就能够保证我们插入顺序和最后的迭代顺序一致了。

#### 底层分析

- LinkedHashSet底层是一个LinkedHashMap，底层是 数组 + 双向链表
- LinkedHashSet 根据元素的 hashCode 值来決定元素的存储位置，同时使
  用链表维护元素的次序(图)，这使得元素看起来是以插入顺序保存的

![image-20220315190610217](assets/Java SE(二)/image-20220315190610217.png)

#### 使用细节

- 不允许添加重复元素
- 插入查询按照插入顺序



### TreeSet

TreeSet会在插入元素时进行排序

```java
public static void main(String[] args) {
    TreeSet<Integer> set = new TreeSet<>();
    set.add(1);
    set.add(3);
    set.add(2);
    System.out.println(set);
}
```

可以看到最后得到的结果并不是我们插入顺序，而是按照数字的大小进行排列。当然，我们也可以自定义排序规则：

```java
public static void main(String[] args) {
    TreeSet<Integer> set = new TreeSet<>((a, b) -> b - a);   //在创建对象时指定规则即可
    set.add(1);
    set.add(3);
    set.add(2);
    System.out.println(set);
}
```

现在的结果就是我们自定义的排序规则了。



### 总结

虽然Set集合比较粗略，学习Map之后，还会回来看我们Set的底层实现，所以说`最重要的还是Map`，只需要记住Set的性质、使用即可。

## Map映射

### 什么是映射

我们在高中阶段其实已经学习过映射了，映射指两个元素的之间相互“对应”的关系，也就是说，我们的元素之间是两两对应的，是以键值对的形式存在。

![映射](assets/Java SE(二)/format,f_jpg.jpeg)

### Map接口

Map就是为了实现这种数据结构而存在的，我们通过保存键值对的形式来存储映射关系。

Map接口都是双列集合，是键值对的形式

### Map常用类

常用类包括：HashTable、HashMap、TreeMap、Properties等

![image-20220315210112587](assets/Java SE(二)/image-20220315210112587.png)

### 常用方法

```java
// 以HashMap为例
Map map = new HashMap();

// 1)put:添加
map.put("easylee", 18);
map.put("easylee1", 20);

// 2)remove:根据键删除映射关系
map.remove("easylee");

// 3)get：根据键获取值
map.get("easylee1");
// 4) size;获取元素个数
System.out.println(map.size());

// 5) isEmpty:判断个数是否为0
// 6)clear-清除
// 7)containskey-查找键是否存在
```

### Map遍历

```java
// 第一组：先取出 所有的Key，通过key，取出对应的value
Set keyset = map.keySet();
for (Object key:keyset) {
	System.out.println(map.get(key));
}

// 第二组：把所有的values取出
Collection values = map.values();
for (Object value : values) {
	System.out.println(value);
}

// 第三组：通过EntrySet 来获取k-v
// EntrySet<Map.Entry<K,V>>,EntrySet是一组一组的Entry键值对
Set entrySet = map.entrySet();
for (Object entry : entrySet) {
  // 转为Map.Entry才可以使用获取k，v的方法
  Map.Entry m = (Map.Entry) entry;
  System.out.println(m.getKey() + "-" + m.getValue());
}
```



#### 使用细节

- Map 中的key 不允许重复
- Map 中的value 可以重复
- Map 的key 可以为null, value 也可以为null，注意 key 为null，只能有一个，value为null，可以有多个
- 常用String作为Map的key



### HashMap类

HashMap的实现过程，相比List，就非常地复杂了，它并不是简简单单的表结构，而是利用哈希表存放映射关系，我们来看看HashMap是如何实现的，首先回顾我们之前学习的哈希表，它长这样：

![img](assets/Java SE(二)/webp)

哈希表的本质其实就是一个用于存放后续节点的头结点的数组，数组里面的每一个元素都是一个头结点（也可以说就是一个链表），当要新插入一个数据时，会先计算该数据的哈希值，找到数组下标，然后创建一个新的节点，添加到对应的链表后面。

而HashMap就是采用的这种方式，我们可以看到源码中同样定义了这样的一个结构：

```java
/**
 * The table, initialized on first use, and resized as
 * necessary. When allocated, length is always a power of two.
 * (We also tolerate length zero in some operations to allow
 * bootstrapping mechanics that are currently not needed.)
 */
transient Node<K,V>[] table;
```

这个表会在第一次使用时初始化，同时在必要时进行扩容，并且它的大小永远是2的倍数！

```java
/**
 * The default initial capacity - MUST be a power of two.
 */
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
```

我们可以看到默认的大小为2的4次方，每次都需要是2的倍数，也就是说，下一次增长之后，大小会变成2的5次方。

我们现在需要思考一个问题，当我们表中的数据不断增加之后，链表会变得越来越长，这样会严重导致查询速度变慢，首先想到办法就是，我们可以对数组的长度进行扩容，来存放更多的链表，那么什么情况下会进行扩容呢？

```java
/**
 * The load factor for the hash table.
 *
 * @serial
 */
final float loadFactor;
```

我们还发现HashMap源码中有这样一个变量，也就是`负载因子`，那么它是干嘛的呢？

负载因子其实就是用来衡量当前情况是否需要进行扩容的标准。我们可以看到默认的负载因子是`0.75`

```java
/**
 * The load factor used when none specified in constructor.
 */
static final float DEFAULT_LOAD_FACTOR = 0.75f;
```

那么负载因子是怎么控制扩容的呢？`0.75`的意思是，在插入新的结点后，如果当前数组的占用率达到75%则进行扩容。在扩容时，会将所有的数据，重新计算哈希值，得到一个新的下标，组成新的哈希表。

但是这样依然有一个问题，链表过长的情况还是有可能发生，所以，为了从根源上解决这个问题，在JDK1.8时，引入了红黑树这个数据结构。

![](assets/Java SE(二)/5884577601a5ab1aabe10ee95696557b8d3b5338.jpg)

当链表的长度达到8时，会自动将链表转换为红黑树，这样能使得原有的查询效率大幅度降低！当使用红黑树之后，我们就可以利用二分搜索的思想，快速地去寻找我们想要的结果，而不是像链表一样挨个去看。

```java
/**
 * Entry for Tree bins. Extends LinkedHashMap.Entry (which in turn
 * extends Node) so can be used as extension of either regular or
 * linked node.
 */
static final class TreeNode<K,V> extends LinkedHashMap.Entry<K,V> {
```

除了Node以外，HashMap还有TreeNode，很明显这就是为了实现红黑树而设计的内部类。不过我们发现，TreeNode并不是直接继承Node，而是使用了LinkedHashMap中的Entry实现，它保存了前后节点的顺序（也就是我们的插入顺序）。

```java
/**
 * HashMap.Node subclass for normal LinkedHashMap entries.
 */
static class Entry<K,V> extends HashMap.Node<K,V> {
    Entry<K,V> before, after;
    Entry(int hash, K key, V value, Node<K,V> next) {
        super(hash, key, value, next);
    }
}
```

#### 使用细节

- HashMap是 Map 接口使用频率最高的实现类
- HashMap 是以 key-val 对的方式来存储数据
- key 不能重复，但是值可以重复，允许使用null键和null值
- 如果添加相同的key，则会覆盖原来的key-val,等同于修改.(key不会替换，val会替换）
- 不保证是有序的，因为底层是Hash表的方式来存储的
- HashMap不是线程安全的

### LinkedHashMap

LinkedHashMap是直接继承自HashMap，具有HashMap的全部性质，同时得益于每一个节点都是一个双向链表，保存了插入顺序，这样我们在遍历LinkedHashMap时，顺序就同我们的插入顺序一致。当然，也可以使用访问顺序，也就是说对于刚访问过的元素，会被排到最后一位。

```java
public static void main(String[] args) {
    LinkedHashMap<Integer, String> map = new LinkedHashMap<>(16, 0.75f, true);  //以访问顺序
    map.put(1, "A");
    map.put(2, "B");
    map.put(3, "C");
    map.get(2);
    System.out.println(map);
}
```

观察结果，我们发现，刚访问的结果被排到了最后一位。

### TreeMap

TreeMap其实就是自动维护顺序的一种Map，就和我们前面提到的TreeSet一样：

```java
/**
 * The comparator used to maintain order in this tree map, or
 * null if it uses the natural ordering of its keys.
 *
 * @serial
 */
private final Comparator<? super K> comparator;

private transient Entry<K,V> root;

/**
* Node in the Tree.  Doubles as a means to pass key-value pairs back to
* user (see Map.Entry).
*/

static final class Entry<K,V> implements Map.Entry<K,V> {
```

我们发现它的内部直接维护了一个红黑树，就像它的名字一样，就是一个Tree，因为它默认就是有序的，所以说直接采用红黑树会更好。我们在创建时，直接给予一个比较规则即可。

### Properties类

Properties类继承自HashTable类并且实现了Map接口，也是使用一种键值对的形式来保存数据

#### 使用细节

- 使用特点和HashTable类似
- 主要用于保存配置文件信息，存为一个单独的配置文件

### Map的使用

我们首先来看看Map的一些基本操作：

```java
public static void main(String[] args) {
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.put(3, "C");
    System.out.println(map.get(1));    //获取Key为1的值
    System.out.println(map.getOrDefault(0, "K"));  //不存在就返回K
   	map.remove(1);   //移除这个Key的键值对
}
```

由于Map并未实现迭代器接口，因此不支持foreach，但是JDK1.8为我们提供了forEach方法使用：

```java
public static void main(String[] args) {
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.put(3, "C");
    map.forEach((k, v) -> System.out.println(k+"->"+v));
  
  	for (Map.Entry<Integer, String> entry : map.entrySet()) {   //也可以获取所有的Entry来foreach
      int key = entry.getKey();
      String value = entry.getValue();
      System.out.println(key+" -> "+value);
    }
}
```

我们也可以单独获取所有的值或者是键：

```java
public static void main(String[] args) {
    Map<Integer, String> map = new HashMap<>();
    map.put(1, "A");
    map.put(2, "B");
    map.put(3, "C");
    System.out.println(map.keySet());   //直接获取所有的key
    System.out.println(map.values());   //直接获取所有的值
}
```

### 再谈Set原理

通过观察HashSet的源码发现，HashSet几乎都在操作内部维护的一个HashMap，也就是说，HashSet只是一个表壳，而内部维护的HashMap才是灵魂！

```java
// Dummy value to associate with an Object in the backing Map
private static final Object PRESENT = new Object();
```

我们发现，在添加元素时，其实添加的是一个键为我们插入的元素，而值就是`PRESENT`常量：

```java
/**
 * Adds the specified element to this set if it is not already present.
 * More formally, adds the specified element <tt>e</tt> to this set if
 * this set contains no element <tt>e2</tt> such that
 * <tt>(e==null&nbsp;?&nbsp;e2==null&nbsp;:&nbsp;e.equals(e2))</tt>.
 * If this set already contains the element, the call leaves the set
 * unchanged and returns <tt>false</tt>.
 *
 * @param e element to be added to this set
 * @return <tt>true</tt> if this set did not already contain the specified
 * element
 */
public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```

观察其他的方法，也几乎都是在用HashMap做事，所以说，HashSet利用了HashMap内部的数据结构，轻松地就实现了Set定义的全部功能！

再来看TreeSet，实际上用的就是我们的TreeMap：

```java
/**
 * The backing map.
 */
private transient NavigableMap<E,Object> m;
```

同理，这里就不多做阐述了。

## 集合的嵌套

既然集合类型中的元素类型是泛型，那么能否嵌套存储呢？

```java
public static void main(String[] args) {
    Map<String, List<Integer>> map = new HashMap<>();   //每一个映射都是 字符串<->列表
    map.put("卡布奇诺今犹在", new LinkedList<>());
    map.put("不见当年倒茶人", new LinkedList<>());
    System.out.println(map.keySet());
    System.out.println(map.values());
}
```

通过Key获取到对应的值后，就是一个列表：

```java
map.get("卡布奇诺今犹在").add(10);
System.out.println(map.get("卡布奇诺今犹在").get(0));
```

让套娃继续下去：

```java
public static void main(String[] args) {
    Map<Integer, Map<Integer, Map<Integer, String>>> map = new HashMap<>();
}
```

你也可以使用List来套娃别的：

```java
public static void main(String[] args) {
    List<Map<String, Set<String>>> list = new LinkedList<>();
}
```

### 

## 如何选择集合

### 判断存储类型

判断存储的数据类型是一个个的对象还是键值对对象



### 单独对象

使用Collection接口

- 允许重复：使用List
  - `增删多`使用LinkedList，底层维护了一个双向链表，
  - `改查多`使用ArrayList，底层维护了一个可变数组
- 不允许重复：使用Set
  - 无序使用HashSet，底层是HashMap，维护了一个哈希表（数组+链表+红黑树）
  - 排序使用TreeSet
  - 插入和取出顺序一致，使用LinkedHashSet，底层LinkedHashMap底层HashMap，维护数组+双向链表



### 一组键值对

使用Map

- 键无序：使用HashMap，底层哈希表，数组+链表+红黑树
- 键排序：TreeMap
- 键插入和取出顺序一致：LinkedHashMap
- 读取文件：Properties



# Java多线程

**注意：**本章节会涉及到 操作系统 相关知识。

在了解多线程之前，让我们回顾一下`操作系统`中提到的进程概念：

![img](assets/Java SE(二)/u=2613039280,4140201323&fm=26&fmt=auto-20220504193850388.jpeg)

进程是程序执行的实体，每一个进程都是一个应用程序（比如我们运行QQ、浏览器、LOL、网易云音乐等软件），都有自己的内存空间，CPU一个核心同时只能处理一件事情，当出现多个进程需要同时运行时，CPU一般通过`时间片轮转调度`算法，来实现多个进程的同时运行。

![img](assets/Java SE(二)/src=http%3A%2F%2Fhiphotos.baidu.com%2Fdoc%2Fpic%2Fitem%2Faec379310a55b3193e6caaf24aa98226cefc179b.jpg&refer=http%3A%2F%2Fhiphotos.baidu-20220504193850368.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

在早期的计算机中，进程是拥有资源和独立运行的最小单位，也是程序执行的最小单位。但是，如果我希望两个任务同时进行，就必须运行两个进程，由于每个进程都有一个自己的内存空间，进程之间的通信就变得非常麻烦（比如要共享某些数据）而且执行不同进程会产生上下文切换，非常耗时，那么能否实现在一个进程中就能够执行多个任务呢？

![img](assets/Java SE(二)/src=http%3A%2F%2Fs2.51cto.com%2Fwyfs02%2FM00%2F84%2F3A%2FwKiom1eIqY7il2J7AAAyvcssSjs721.gif&refer=http%3A%2F%2Fs2.51cto-20220504193850381.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

后来，线程横空出世，一个进程可以有多个线程，线程是程序执行中一个单一的顺序控制流程，现在线程才是程序执行流的最小单元，各个线程之间共享程序的内存空间（也就是所在进程的内存空间），上下文切换速度也高于进程。

在Java中，我们从开始，一直以来编写的都是单线程应用程序（运行`main()`方法的内容），也就是说只能同时执行一个任务（无论你是调用方法、还是进行计算，始终都是依次进行的，也就是同步的），而如果我们希望同时执行多个任务（两个方法**同时**在运行或者是两个计算同时在进行，也就是异步的），就需要用到Java多线程框架。实际上一个Java程序启动后，会创建很多线程，不仅仅只运行一个主线程：

```java
public static void main(String[] args) {
    ThreadMXBean bean = ManagementFactory.getThreadMXBean();
    long[] ids = bean.getAllThreadIds();
    ThreadInfo[] infos = bean.getThreadInfo(ids);
    for (ThreadInfo info : infos) {
        System.out.println(info.getThreadName());
    }
}
```

关于除了main线程默认以外的线程，涉及到JVM相关底层原理，在这里不做讲解，了解就行。

***

## 线程的创建和启动

通过创建Thread对象来创建一个新的线程，Thread构造方法中需要传入一个Runnable接口的实现（其实就是编写要在另一个线程执行的内容逻辑）同时Runnable只有一个未实现方法，因此可以直接使用lambda表达式：

```java
@FunctionalInterface
public interface Runnable {
    /**
     * When an object implementing interface <code>Runnable</code> is used
     * to create a thread, starting the thread causes the object's
     * <code>run</code> method to be called in that separately executing
     * thread.
     * <p>
     * The general contract of the method <code>run</code> is that it may
     * take any action whatsoever.
     *
     * @see     java.lang.Thread#run()
     */
    public abstract void run();
}
```

创建好后，通过调用`start()`方法来运行此线程：

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {    //直接编写逻辑
        System.out.println("我是另一个线程！");
    });
    t.start();   //调用此方法来开始执行此线程
}
```

可能上面的例子看起来和普通的单线程没两样，那我们先来看看下面这段代码的运行结果：

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        System.out.println("我是线程："+Thread.currentThread().getName());
        System.out.println("我正在计算 0-10000 之间所有数的和...");
        int sum = 0;
        for (int i = 0; i <= 10000; i++) {
            sum += i;
        }
        System.out.println("结果："+sum);
    });
    t.start();
    System.out.println("我是主线程！");
}
```

我们发现，这段代码执行输出结果并不是按照从上往下的顺序了，因为他们分别位于两个线程，他们是同时进行的！如果你还是觉得很疑惑，我们接着来看下面的代码运行结果：

```java
public static void main(String[] args) {
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 50; i++) {
            System.out.println("我是一号线程："+i);
        }
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 50; i++) {
            System.out.println("我是二号线程："+i);
        }
    });
    t1.start();
    t2.start();
}
```

我们可以看到打印实际上是在交替进行的，也证明了他们是在同时运行！

**注意**：我们发现还有一个run方法，也能执行线程里面定义的内容，但是run是直接在当前线程执行，并不是创建一个线程执行！

![img](assets/Java SE(二)/src=http%3A%2F%2Fwww.liuhaihua.cn%2Fwp-content%2Fuploads%2F2019%2F09%2F3AfuQrV.png&refer=http%3A%2F%2Fwww.liuhaihua-20220504193850378.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

实际上，线程和进程差不多，也会等待获取CPU资源，一旦获取到，就开始按顺序执行我们给定的程序，当需要等待外部IO操作（比如Scanner获取输入的文本），就会暂时处于休眠状态，等待通知，或是调用`sleep()`方法来让当前线程休眠一段时间：

```java
public static void main(String[] args) throws InterruptedException {
    System.out.println("l");
    Thread.sleep(1000);    //休眠时间，以毫秒为单位，1000ms = 1s
    System.out.println("b");
    Thread.sleep(1000);
    System.out.println("w");
    Thread.sleep(1000);
    System.out.println("nb!");
}
```

我们也可以使用`stop()`方法来强行终止此线程：

```java
public static void main(String[] args) throws InterruptedException {
    Thread t = new Thread(() -> {
        Thread me = Thread.currentThread();   //获取当前线程对象
        for (int i = 0; i < 50; i++) {
            System.out.println("打印:"+i);
            if(i == 20) me.stop();  //此方法会直接终止此线程
        }
    });
    t.start();
}
```

虽然`stop()`方法能够终止此线程，但是并不是所推荐的做法，有关线程中断相关问题，我们会在后面继续了解。

**思考**：猜猜以下程序输出结果：

```java
private static int value = 0;

public static void main(String[] args) throws InterruptedException {
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) value++;
        System.out.println("线程1完成");
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) value++;
        System.out.println("线程2完成");
    });
    t1.start();
    t2.start();
    Thread.sleep(1000);  //主线程停止1秒，保证两个线程执行完成
    System.out.println(value);
}
```

我们发现，value最后的值并不是我们理想的结果，有关为什么会出现这种问题，在我们学习到线程锁的时候，再来探讨。

***

## 线程的休眠和中断

我们前面提到，一个线程处于运行状态下，线程的下一个状态会出现以下情况：

* 当CPU给予的运行时间结束时，会从运行状态回到就绪（可运行）状态，等待下一次获得CPU资源。
* 当线程进入休眠 / 阻塞(如等待IO请求) / 手动调用`wait()`方法时，会使得线程处于等待状态，当等待状态结束后会回到就绪状态。
* 当线程出现异常或错误 / 被`stop()` 方法强行停止 / 所有代码执行结束时，会使得线程的运行终止。

而这个部分我们着重了解一下线程的休眠和中断，首先我们来了解一下如何使得线程进如休眠状态：

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        try {
            System.out.println("l");
            Thread.sleep(1000);   //sleep方法是Thread的静态方法，它只作用于当前线程（它知道当前线程是哪个）
            System.out.println("b");    //调用sleep后，线程会直接进入到等待状态，直到时间结束
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });
    t.start();
}
```

通过调用`sleep()`方法来将当前线程进入休眠，使得线程处于等待状态一段时间。我们发现，此方法显示声明了会抛出一个InterruptedException异常，那么这个异常在什么时候会发生呢？

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        try {
            Thread.sleep(10000);  //休眠10秒
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });
    t.start();
    try {
        Thread.sleep(3000);   //休眠3秒，一定比线程t先醒来
        t.interrupt();   //调用t的interrupt方法
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
}
```

我们发现，每一个Thread对象中，都有一个`interrupt()`方法，调用此方法后，会给指定线程添加一个中断标记以告知线程需要立即停止运行或是进行其他操作，由线程来响应此中断并进行相应的处理，我们前面提到的`stop()`方法是强制终止线程，这样的做法虽然简单粗暴，但是很有可能导致资源不能完全释放，而类似这样的发送通知来告知线程需要中断，让线程自行处理后续，会更加合理一些，也是更加推荐的做法。我们来看看interrupt的用法：

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        System.out.println("线程开始运行！");
        while (true){   //无限循环
            if(Thread.currentThread().isInterrupted()){   //判断是否存在中断标志
                break;   //响应中断
            }
        }
        System.out.println("线程被中断了！");
    });
    t.start();
    try {
        Thread.sleep(3000);   //休眠3秒，一定比线程t先醒来
        t.interrupt();   //调用t的interrupt方法
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
}
```

通过`isInterrupted()`可以判断线程是否存在中断标志，如果存在，说明外部希望当前线程立即停止，也有可能是给当前线程发送一个其他的信号，如果我们并不是希望收到中断信号就是结束程序，而是通知程序做其他事情，我们可以在收到中断信号后，复位中断标记，然后继续做我们的事情：

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        System.out.println("线程开始运行！");
        while (true){
            if(Thread.currentThread().isInterrupted()){   //判断是否存在中断标志
                System.out.println("发现中断信号，复位，继续运行...");
                Thread.interrupted();  //复位中断标记（返回值是当前是否有中断标记，这里不用管）
            }
        }
    });
    t.start();
    try {
        Thread.sleep(3000);   //休眠3秒，一定比线程t先醒来
        t.interrupt();   //调用t的interrupt方法
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
}
```

复位中断标记后，会立即清除中断标记。那么，如果现在我们想暂停线程呢？我们希望线程暂时停下，比如等待其他线程执行完成后，再继续运行，那这样的操作怎么实现呢？

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        System.out.println("线程开始运行！");
        Thread.currentThread().suspend();   //暂停此线程
        System.out.println("线程继续运行！");
    });
    t.start();
    try {
        Thread.sleep(3000);   //休眠3秒，一定比线程t先醒来
        t.resume();   //恢复此线程
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
}
```

虽然这样很方便地控制了线程的暂停状态，但是这两个方法我们发现实际上也是不推荐的做法，它很容易导致死锁！有关为什么被弃用的原因，我们会在线程锁继续探讨。

***

## 线程的优先级

实际上，Java程序中的每个线程并不是平均分配CPU时间的，为了使得线程资源分配更加合理，Java采用的是抢占式调度方式，优先级越高的线程，优先使用CPU资源！我们希望CPU花费更多的时间去处理更重要的任务，而不太重要的任务，则可以先让出一部分资源。线程的优先级一般分为以下三种：

* MIN_PRIORITY   最低优先级
* MAX_PRIORITY   最高优先级
* NOM_PRIORITY  常规优先级

```java
public static void main(String[] args) {
    Thread t = new Thread(() -> {
        System.out.println("线程开始运行！");
    });
    t.start();
    t.setPriority(Thread.MIN_PRIORITY);  //通过使用setPriority方法来设定优先级
}
```

优先级越高的线程，获得CPU资源的概率会越大，并不是说一定优先级越高的线程越先执行！

## 线程的礼让和加入

我们还可以在当前线程的工作不重要时，将CPU资源让位给其他线程，通过使用`yield()`方法来将当前资源让位给其他同优先级线程：

```java
public static void main(String[] args) {
    Thread t1 = new Thread(() -> {
        System.out.println("线程1开始运行！");
        for (int i = 0; i < 50; i++) {
            if(i % 5 == 0) {
                System.out.println("让位！");
                Thread.yield();
            }
            System.out.println("1打印："+i);
        }
        System.out.println("线程1结束！");
    });
    Thread t2 = new Thread(() -> {
        System.out.println("线程2开始运行！");
        for (int i = 0; i < 50; i++) {
            System.out.println("2打印："+i);
        }
    });
    t1.start();
    t2.start();
}
```

观察结果，我们发现，在让位之后，尽可能多的在执行线程2的内容。

当我们希望一个线程等待另一个线程执行完成后再继续进行，我们可以使用`join()`方法来实现线程的加入：

```java
public static void main(String[] args) {
    Thread t1 = new Thread(() -> {
        System.out.println("线程1开始运行！");
        for (int i = 0; i < 50; i++) {
            System.out.println("1打印："+i);
        }
        System.out.println("线程1结束！");
    });
    Thread t2 = new Thread(() -> {
        System.out.println("线程2开始运行！");
        for (int i = 0; i < 50; i++) {
            System.out.println("2打印："+i);
            if(i == 10){
                try {
                    System.out.println("线程1加入到此线程！");
                    t1.join();    //在i==10时，让线程1加入，先完成线程1的内容，在继续当前内容
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    });
    t1.start();
    t2.start();
}
```

我们发现，线程1加入后，线程2等待线程1待执行的内容全部执行完成之后，再继续执行的线程2内容。注意，线程的加入只是等待另一个线程的完成，并不是将另一个线程和当前线程合并！我们来看看：

```java
public static void main(String[] args) {
    Thread t1 = new Thread(() -> {
        System.out.println(Thread.currentThread().getName()+"开始运行！");
        for (int i = 0; i < 50; i++) {
            System.out.println(Thread.currentThread().getName()+"打印："+i);
        }
        System.out.println("线程1结束！");
    });
    Thread t2 = new Thread(() -> {
        System.out.println("线程2开始运行！");
        for (int i = 0; i < 50; i++) {
            System.out.println("2打印："+i);
            if(i == 10){
                try {
                    System.out.println("线程1加入到此线程！");
                    t1.join();    //在i==10时，让线程1加入，先完成线程1的内容，在继续当前内容
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    });
    t1.start();
    t2.start();
}
```

实际上，t2线程只是暂时处于等待状态，当t1执行结束时，t2才开始继续执行，只是在效果上看起来好像是两个线程合并为一个线程在执行而已。

***

## 线程锁和线程同步

在开始讲解线程同步之前，我们需要先了解一下多线程情况下Java的内存管理：

![img](https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fvlambda.com%2Fimg%3Furl%3Dhttps%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_png%2F2LlmEpiamhyq7hTfsoWa1GMIQlOtRuD8SScvIeB3KD7w4OoGu8wx13lBjMJLhYgYqTHND48X05m901TIEicGg49w%2F640%3Fwx_fmt%3Dpng&refer=http%3A%2F%2Fvlambda.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637562962&t=830ccc4dbe09f2699660bfcc9a292c63)

线程之间的共享变量（比如之前悬念中的value变量）存储在主内存（main memory）中，每个线程都有一个私有的工作内存（本地内存），工作内存中存储了该线程以读/写共享变量的副本。它类似于我们在`计算机组成原理`中学习的多处理器高速缓存机制：

![img](assets/Java SE(二)/WEBb1fa2c9cd0784fb19f0d8ebeb8e00976-20220504193850629.png)

高速缓存通过保存内存中数据的副本来提供更加快速的数据访问，但是如果多个处理器的运算任务都涉及同一块内存区域，就可能导致各自的高速缓存数据不一致，在写回主内存时就会发生冲突，这就是引入高速缓存引发的新问题，称之为：缓存一致性。

实际上，Java的内存模型也是这样类似设计的，当我们同时去操作一个共享变量时，如果仅仅是读取还好，但是如果同时写入内容，就会出现问题！好比说一个银行，如果我和我的朋友同时在银行取我账户里面的钱，难道取1000还可能吐2000出来吗？我们需要一种更加安全的机制来维持秩序，保证数据的安全性！

### 悬念破案

我们再来回顾一下之前留给大家的悬念：

```java
private static int value = 0;

public static void main(String[] args) throws InterruptedException {
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) value++;
        System.out.println("线程1完成");
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) value++;
        System.out.println("线程2完成");
    });
    t1.start();
    t2.start();
    Thread.sleep(1000);  //主线程停止1秒，保证两个线程执行完成
    System.out.println(value);
}
```

实际上，当两个线程同时读取value的时候，可能会同时拿到同样的值，而进行自增操作之后，也是同样的值，再写回主内存后，本来应该进行2次自增操作，实际上只执行了一次！

![img](https://gimg2.baidu.com/image_search/src=http%3A%2F%2Faliyunzixunbucket.oss-cn-beijing.aliyuncs.com%2Fjpg%2F3154ff892af3cb3373a3b6b82b501a1d.jpg%3Fx-oss-process%3Dimage%2Fresize%2Cp_100%2Fauto-orient%2C1%2Fquality%2Cq_90%2Fformat%2Cjpg%2Fwatermark%2Cimage_eXVuY2VzaGk%3D%2Ct_100&refer=http%3A%2F%2Faliyunzixunbucket.oss-cn-beijing.aliyuncs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637565388&t=20091d33bae457edc36af7718ef1325b)

那么要去解决这样的问题，我们就必须采取某种同步机制，来限制不同线程对于共享变量的访问！我们希望的是保证共享变量value自增操作的原子性（原子性是指一个操作或多个操作要么全部执行，且执行的过程不会被任何因素打断，包括其他线程，要么就都不执行）

### 线程锁

通过synchronized关键字来创造一个线程锁，首先我们来认识一下synchronized代码块，它需要在括号中填入一个内容，必须是一个对象或是一个类，我们在value自增操作外套上同步代码块：

```java
private static int value = 0;

public static void main(String[] args) throws InterruptedException {
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) {
            synchronized (Main.class){
                value++;
            }
        }
        System.out.println("线程1完成");
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) {
            synchronized (Main.class){
                value++;
            }
        }
        System.out.println("线程2完成");
    });
    t1.start();
    t2.start();
    Thread.sleep(1000);  //主线程停止1秒，保证两个线程执行完成
    System.out.println(value);
}
```

我们发现，现在得到的结果就是我们想要的内容了，因为在同步代码块执行过程中，拿到了我们传入对象或类的锁（传入的如果是对象，就是对象锁，不同的对象代表不同的对象锁，如果是类，就是类锁，类锁只有一个，实际上类锁也是对象锁，是Class类实例，但是Class类实例同样的类无论怎么获取都是同一个），但是注意两个线程必须使用同一把锁！

当一个线程进入到同步代码块时，会获取到当前的锁，而这时如果其他使用同样的锁的同步代码块也想执行内容，就必须等待当前同步代码块的内容执行完毕，在执行完毕后会自动释放这把锁，而其他的线程才能拿到这把锁并开始执行同步代码块里面的内容。（实际上synchronized是一种悲观锁，随时都认为有其他线程在对数据进行修改，后面有机会我们还会讲到乐观锁，如CAS算法）

那么我们来看看，如果使用的是不同对象的锁，那么还能顺利进行吗？

```java
private static int value = 0;

public static void main(String[] args) throws InterruptedException {
    Main main1 = new Main();
    Main main2 = new Main();
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) {
            synchronized (main1){
                value++;
            }
        }
        System.out.println("线程1完成");
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) {
            synchronized (main2){
                value++;
            }
        }
        System.out.println("线程2完成");
    });
    t1.start();
    t2.start();
    Thread.sleep(1000);  //主线程停止1秒，保证两个线程执行完成
    System.out.println(value);
}
```

当对象不同时，获取到的是不同的锁，因此并不能保证自增操作的原子性，最后也得不到我们想要的结果。

synchronized关键字也可以作用于方法上，调用此方法时也会获取锁：

```java
private static int value = 0;

private static synchronized void add(){
    value++;
}

public static void main(String[] args) throws InterruptedException {
    Thread t1 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) add();
        System.out.println("线程1完成");
    });
    Thread t2 = new Thread(() -> {
        for (int i = 0; i < 10000; i++) add();
        System.out.println("线程2完成");
    });
    t1.start();
    t2.start();
    Thread.sleep(1000);  //主线程停止1秒，保证两个线程执行完成
    System.out.println(value);
}
```

我们发现实际上效果是相同的，只不过这个锁不用你去给，如果是静态方法，就是使用的类锁，而如果是普通成员方法，就是使用的对象锁。通过灵活的使用synchronized就能很好地解决我们之前提到的问题了！

### 死锁

其实死锁的概念在`操作系统`中也有提及，它是指两个线程相互持有对方需要的锁，但是又迟迟不释放，导致程序卡住：

![img](assets/Java SE(二)/src=http%3A%2F%2Fpic4.zhimg.com%2Fv2-9852c978350cc5e8641ba778619351bb_b.png&refer=http%3A%2F%2Fpic4.zhimg-20220504193850362.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

我们发现，线程A和线程B都需要对方的锁，但是又被对方牢牢把握，由于线程被无限期地阻塞，因此程序不可能正常终止。我们来看看以下这段代码会得到什么结果：

```java
public static void main(String[] args) throws InterruptedException {
    Object o1 = new Object();
    Object o2 = new Object();
    Thread t1 = new Thread(() -> {
        synchronized (o1){
            try {
                Thread.sleep(1000);
                synchronized (o2){
                    System.out.println("线程1");
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    });
    Thread t2 = new Thread(() -> {
        synchronized (o2){
            try {
                Thread.sleep(1000);
                synchronized (o1){
                    System.out.println("线程2");
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    });
    t1.start();
    t2.start();
}
```

那么我们如何去检测死锁呢？我们可以利用jstack命令来检测死锁，首先利用jps找到我们的java进程：

```shell
nagocoler@NagodeMacBook-Pro ~ % jps
51592 Launcher
51690 Jps
14955 
51693 Main
nagocoler@NagodeMacBook-Pro ~ % jstack 51693
...
Java stack information for the threads listed above:
===================================================
"Thread-1":
	at com.test.Main.lambda$main$1(Main.java:46)
	- waiting to lock <0x000000076ad27fc0> (a java.lang.Object)
	- locked <0x000000076ad27fd0> (a java.lang.Object)
	at com.test.Main$$Lambda$2/1867750575.run(Unknown Source)
	at java.lang.Thread.run(Thread.java:748)
"Thread-0":
	at com.test.Main.lambda$main$0(Main.java:34)
	- waiting to lock <0x000000076ad27fd0> (a java.lang.Object)
	- locked <0x000000076ad27fc0> (a java.lang.Object)
	at com.test.Main$$Lambda$1/396873410.run(Unknown Source)
	at java.lang.Thread.run(Thread.java:748)

Found 1 deadlock.
```

jstack自动帮助我们找到了一个死锁，并打印出了相关线程的栈追踪信息。

不推荐使用 `suspend() `去挂起线程的原因，是因为` suspend() `在使线程暂停的同时，并不会去释放任何锁资源。其他线程都无法访问被它占用的锁。直到对应的线程执行` resume() `方法后，被挂起的线程才能继续，从而其它被阻塞在这个锁的线程才可以继续执行。但是，如果` resume() `操作出现在` suspend() `之前执行，那么线程将一直处于挂起状态，同时一直占用锁，这就产生了死锁。

### wait和notify方法

其实我们之前可能就发现了，Object类还有三个方法我们从来没有使用过，分别是`wait()`、`notify()`以及`notifyAll()`，他们其实是需要配合synchronized来使用的，只有在同步代码块中才能使用这些方法，我们来看看他们的作用是什么：

```java
public static void main(String[] args) throws InterruptedException {
    Object o1 = new Object();
    Thread t1 = new Thread(() -> {
        synchronized (o1){
            try {
                System.out.println("开始等待");
                o1.wait();     //进入等待状态并释放锁
                System.out.println("等待结束！");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    });
    Thread t2 = new Thread(() -> {
        synchronized (o1){
            System.out.println("开始唤醒！");
            o1.notify();     //唤醒处于等待状态的线程
          	for (int i = 0; i < 50; i++) {
               	System.out.println(i);   
            }
          	//唤醒后依然需要等待这里的锁释放之前等待的线程才能继续
        }
    });
    t1.start();
    Thread.sleep(1000);
    t2.start();
}
```

我们可以发现，对象的`wait()`方法会暂时使得此线程进入等待状态，同时会释放当前代码块持有的锁，这时其他线程可以获取到此对象的锁，当其他线程调用对象的`notify()`方法后，会唤醒刚才变成等待状态的线程（这时并没有立即释放锁）。注意，必须是在持有锁（同步代码块内部）的情况下使用，否则会抛出异常！

notifyAll其实和notify一样，也是用于唤醒，但是前者是唤醒所有调用`wait()`后处于等待的线程，而后者是看运气随机选择一个。

### synchronized 同步对象

synchronized表示独占当前对象，其它线程只能等待

```java
Synchronization_ synchronization_ = new Synchronization_();
// 同步对象,将synchronization_设为同步对象
synchronized (synchronization_) {
	synchronization_.add();	
}
```

将一个方法设置为synchronized，那么这个方法操作的对象自动就是独占的

```java
public synchronized void add() {
    volumn++;
}
```

如果一个类都是线程独占的方法，那么就是同步类



### lock同步对象

与synchronized类似的，lock也能够达到同步的效果

当一个线程占用 synchronized 同步对象，其他线程就不能占用了，直到释放这个同步对象为止

与 `synchronized (someObject)`类似的，`lock()`方法，表示当前线程占用lock对象，一旦占用，其他线程就不能占用了。

与 synchronized 不同的是，一旦synchronized 块结束，就会自动释放对someObject的占用。 lock却必须调用`unlock`方法进行手动释放，为了保证释放的执行，往往会把unlock() 放在finally中进行。

```java
public class TestThread {
    public static void main(String[] args) {
        Cat cat = new Cat();
        new Thread(cat, "小狗").start();
        new Thread(cat, "小猫").start();
    }

}
class Cat implements Runnable {
    public String name = "cat";
    // 必须在需要创建lock锁的对象中，首先有这个成员，必须是对象的成员
    private Lock lock = new ReentrantLock();

    @Override
    public void run() {
        try {
            // lock成员不能在这里声明，否者就不是对象的成员了
            // lock表示独占当前这个对象，其它线程无法占用
            lock.lock();
            for (int i = 0; i < 10; i++) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                this.name = Thread.currentThread().getName();
                System.out.println(this.name);
            }
        } finally {
            // 不解锁，将一直无法使用
            lock.unlock();
        }
    }
}
```

同时lock还提供了一个trylock方法，在指定时间范围内`试图占用`，占用不到就拉倒

```java
locked = lock.tryLock(1,TimeUnit.SECONDS);
```

### ThreadLocal的使用

既然每个线程都有一个自己的工作内存，那么能否只在自己的工作内存中创建变量仅供线程自己使用呢？

![img](assets/Java SE(二)/1368768-20190613220434628-1803630402-20220504193850387.png)

我们可以是ThreadLocal类，来创建工作内存中的变量，它将我们的变量值存储在内部（只能存储一个变量），不同的变量访问到ThreadLocal对象时，都只能获取到自己线程所属的变量。

```java
public static void main(String[] args) throws InterruptedException {
    ThreadLocal<String> local = new ThreadLocal<>();  //注意这是一个泛型类，存储类型为我们要存放的变量类型
    Thread t1 = new Thread(() -> {
        local.set("lbwnb");   //将变量的值给予ThreadLocal
        System.out.println("变量值已设定！");
        System.out.println(local.get());   //尝试获取ThreadLocal中存放的变量
    });
    Thread t2 = new Thread(() -> {
        System.out.println(local.get());   //尝试获取ThreadLocal中存放的变量
    });
    t1.start();
    Thread.sleep(3000);    //间隔三秒
    t2.start();
}
```

上面的例子中，我们开启两个线程分别去访问ThreadLocal对象，我们发现，第一个线程存放的内容，第一个线程可以获取，但是第二个线程无法获取，我们再来看看第一个线程存入后，第二个线程也存放，是否会覆盖第一个线程存放的内容：

```java
public static void main(String[] args) throws InterruptedException {
    ThreadLocal<String> local = new ThreadLocal<>();  //注意这是一个泛型类，存储类型为我们要存放的变量类型
    Thread t1 = new Thread(() -> {
        local.set("lbwnb");   //将变量的值给予ThreadLocal
        System.out.println("线程1变量值已设定！");
        try {
            Thread.sleep(2000);    //间隔2秒
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("线程1读取变量值：");
        System.out.println(local.get());   //尝试获取ThreadLocal中存放的变量
    });
    Thread t2 = new Thread(() -> {
        local.set("yyds");   //将变量的值给予ThreadLocal
        System.out.println("线程2变量值已设定！");
    });
    t1.start();
    Thread.sleep(1000);    //间隔1秒
    t2.start();
}
```

我们发现，即使线程2重新设定了值，也没有影响到线程1存放的值，所以说，不同线程向ThreadLocal存放数据，只会存放在线程自己的工作空间中，而不会直接存放到主内存中，因此各个线程直接存放的内容互不干扰。

我们发现在线程中创建的子线程，无法获得父线程工作内存中的变量：

```java
public static void main(String[] args) {
    ThreadLocal<String> local = new ThreadLocal<>();
    Thread t = new Thread(() -> {
       local.set("lbwnb");
        new Thread(() -> {
            System.out.println(local.get());
        }).start();
    });
    t.start();
}
```

我们可以使用InheritableThreadLocal来解决：

```java
public static void main(String[] args) {
    ThreadLocal<String> local = new InheritableThreadLocal<>();
    Thread t = new Thread(() -> {
       local.set("lbwnb");
        new Thread(() -> {
            System.out.println(local.get());
        }).start();
    });
    t.start();
}
```

在InheritableThreadLocal存放的内容，会自动向子线程传递。

***

## 定时器

我们有时候会有这样的需求，我希望定时执行任务，比如3秒后执行，其实我们可以通过使用`Thread.sleep()`来实现：

```java
public static void main(String[] args) {
    new TimerTask(() -> System.out.println("我是定时任务！"), 3000).start();   //创建并启动此定时任务
}

static class TimerTask{
    Runnable task;
    long time;

    public TimerTask(Runnable runnable, long time){
        this.task = runnable;
        this.time = time;
    }

    public void start(){
        new Thread(() -> {
            try {
                Thread.sleep(time);
                task.run();   //休眠后再运行
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

我们通过自行封装一个TimerTask类，并在启动时，先休眠3秒钟，再执行我们传入的内容。那么现在我们希望，能否循环执行一个任务呢？比如我希望每隔1秒钟执行一次代码，这样该怎么做呢？

```java
public static void main(String[] args) {
    new TimerLoopTask(() -> System.out.println("我是定时任务！"), 3000).start();   //创建并启动此定时任务
}

static class TimerLoopTask{
    Runnable task;
    long loopTime;

    public TimerLoopTask(Runnable runnable, long loopTime){
        this.task = runnable;
        this.loopTime = loopTime;
    }

    public void start(){
        new Thread(() -> {
            try {
                while (true){   //无限循环执行
                    Thread.sleep(loopTime);
                    task.run();   //休眠后再运行
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

现在我们将单次执行放入到一个无限循环中，这样就能一直执行了，并且按照我们的间隔时间进行。

但是终究是我们自己实现，可能很多方面还没考虑到，Java也为我们提供了一套自己的框架用于处理定时任务：

```java
public static void main(String[] args) {
    Timer timer = new Timer();    //创建定时器对象
    timer.schedule(new TimerTask() {   //注意这个是一个抽象类，不是接口，无法使用lambda表达式简化，只能使用匿名内部类
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getName());    //打印当前线程名称
        }
    }, 1000);    //执行一个延时任务
}
```

我们可以通过创建一个Timer类来让它进行定时任务调度，我们可以通过此对象来创建任意类型的定时任务，包延时任务、循环定时任务等。我们发现，虽然任务执行完成了，但是我们的程序并没有停止，这是因为Timer内存维护了一个任务队列和一个工作线程：

```java
public class Timer {
    /**
     * The timer task queue.  This data structure is shared with the timer
     * thread.  The timer produces tasks, via its various schedule calls,
     * and the timer thread consumes, executing timer tasks as appropriate,
     * and removing them from the queue when they're obsolete.
     */
    private final TaskQueue queue = new TaskQueue();

    /**
     * The timer thread.
     */
    private final TimerThread thread = new TimerThread(queue);
  
		...
}
```

TimerThread继承自Thread，是一个新创建的线程，在构造时自动启动：

```java
public Timer(String name) {
    thread.setName(name);
    thread.start();
}
```

而它的run方法会循环地读取队列中是否还有任务，如果有任务依次执行，没有的话就暂时处于休眠状态：

```java
public void run() {
    try {
        mainLoop();
    } finally {
        // Someone killed this Thread, behave as if Timer cancelled
        synchronized(queue) {
            newTasksMayBeScheduled = false;
            queue.clear();  // Eliminate obsolete references
        }
    }
}

/**
 * The main timer loop.  (See class comment.)
 */
private void mainLoop() {
  try {
       TimerTask task;
       boolean taskFired;
       synchronized(queue) {
         	// Wait for queue to become non-empty
          while (queue.isEmpty() && newTasksMayBeScheduled)   //当队列为空同时没有被关闭时，会调用wait()方法暂时处于等待状态，当有新的任务时，会被唤醒。
                queue.wait();
          if (queue.isEmpty())
             break;    //当被唤醒后都没有任务时，就会结束循环，也就是结束工作线程
                      ...
}
```

`newTasksMayBeScheduled`实际上就是标记当前定时器是否关闭，当它为false时，表示已经不会再有新的任务到来，也就是关闭，我们可以通过调用`cancel()`方法来关闭它的工作线程：

```java
public void cancel() {
    synchronized(queue) {
        thread.newTasksMayBeScheduled = false;
        queue.clear();
        queue.notify();  //唤醒wait使得工作线程结束
    }
}
```

因此，我们可以在使用完成后，调用Timer的`cancel()`方法以正常退出我们的程序：

```java
public static void main(String[] args) {
    Timer timer = new Timer();
    timer.schedule(new TimerTask() {
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getName());
            timer.cancel();  //结束
        }
    }, 1000);
}
```

***

## 守护线程

不要把守护进程和守护线程相提并论！守护进程在后台运行运行，不需要和用户交互，本质和普通进程类似。而守护线程就不一样了，当其他所有的非守护线程结束之后，守护线程是自动结束，也就是说，Java中所有的线程都执行完毕后，守护线程自动结束，因此守护线程不适合进行IO操作，只适合打打杂：

```java
public static void main(String[] args) throws InterruptedException{
    Thread t = new Thread(() -> {
        while (true){
            try {
                System.out.println("程序正常运行中...");
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    });
    t.setDaemon(true);   //设置为守护线程（必须在开始之前，中途是不允许转换的）
    t.start();
    for (int i = 0; i < 5; i++) {
        Thread.sleep(1000);
    }
}
```

在守护线程中产生的新线程也是守护的：

```java
public static void main(String[] args) throws InterruptedException{
    Thread t = new Thread(() -> {
        Thread it = new Thread(() -> {
            while (true){
                try {
                    System.out.println("程序正常运行中...");
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
        it.start();
    });
    t.setDaemon(true);   //设置为守护线程（必须在开始之前，中途是不允许转换的）
    t.start();
    for (int i = 0; i < 5; i++) {
        Thread.sleep(1000);
    }
}
```

***

## 再谈集合类并行方法

其实我们之前在讲解集合类的根接口时，就发现有这样一个方法：

```java
default Stream<E> parallelStream() {
    return StreamSupport.stream(spliterator(), true);
}
```

并行流，其实就是一个多线程执行的流，它通过默认的ForkJoinPool实现（这里不讲解原理），它可以提高你的多线程任务的速度。

```java
public static void main(String[] args) {
    List<Integer> list = new ArrayList<>(Arrays.asList(1, 4, 5, 2, 9, 3, 6, 0));
    list
            .parallelStream()    //获得并行流
            .forEach(i -> System.out.println(Thread.currentThread().getName()+" -> "+i));
}
```

我们发现，forEach操作的顺序，并不是我们实际List中的顺序，同时每次打印也是不同的线程在执行！我们可以通过调用`forEachOrdered()`方法来使用单线程维持原本的顺序：

```java
public static void main(String[] args) {
    List<Integer> list = new ArrayList<>(Arrays.asList(1, 4, 5, 2, 9, 3, 6, 0));
    list
            .parallelStream()    //获得并行流
            .forEachOrdered(System.out::println);
}
```

我们之前还发现，在Arrays数组工具类中，也包含大量的并行方法：

```java
public static void main(String[] args) {
    int[] arr = new int[]{1, 4, 5, 2, 9, 3, 6, 0};
    Arrays.parallelSort(arr);   //使用多线程进行并行排序，效率更高
    System.out.println(Arrays.toString(arr));
}
```

更多地使用并行方法，可以更加充分地发挥现代计算机多核心的优势，但是同时需要注意多线程产生的异步问题！

```java
public static void main(String[] args) {
    int[] arr = new int[]{1, 4, 5, 2, 9, 3, 6, 0};
    Arrays.parallelSetAll(arr, i -> {
        System.out.println(Thread.currentThread().getName());
        return arr[i];
    });
    System.out.println(Arrays.toString(arr));
}
```

## 线程池

当需要创建大量的线程进行业务时，重复的创建销毁会浪费大量的开销，所以需要线程池来进行线程管理，对线程进行重复使用



### 设计原理

准备一个任务容器

 一次性启动10个 消费者线程

刚开始任务容器是空的，所以线程都`wait`在上面

直到一个外部线程往这个任务容器中扔了一个任务，就会有一个消费者线程被唤醒`notify`

这个消费者线程取出任务，并且执行这个任务，执行完毕后，继续等待下一次任务的到来。

如果短时间内，有较多的任务加入，那么就会有多个线程被唤醒，去执行这些任务。

在整个过程中，都不需要创建新的线程，而是`循环使用这些已经存在的线程`



### 自定义线程池

创建任务

```java
package com.easylee.multithreading;

public class TestThread {
    public static void main(String[] args) {
        // 1.创建线程池
        ThreadPool pool = new ThreadPool();

        // 2.创建了5个任务
        for (int i = 0; i < 5; i++) {
            // 将任务添加到线程池，然后让线程池里的线程分别处理这五个任务
            pool.add(new Runnable() {
                @Override
                public void run() {
                    System.out.println("正在执行任务");
                }
            });

            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

    }

}
```

线程池设计

```java
package com.easylee.multithreading;

import java.util.LinkedList;

public class ThreadPool {

    // 线程池大小
    int threadPoolSize;

    // 任务容器，这个是存放任务的容器，线程池独立开来的
    LinkedList<Runnable> tasks = new LinkedList<Runnable>();

    // 1.1 创建线程池
    public ThreadPool() {
        threadPoolSize = 10;

        // 启动10个任务消费者线程，创建后就是闲置等待状态
        // 基于锁定tasks的线程，不会让tasks中资源同时被多个线程操作
        synchronized (tasks) {
            for (int i = 0; i < threadPoolSize; i++) {
                // 创建具体的每个线程池中的线程
                new TaskConsumeThread("任务消费者线程 " + i).start();
            }
        }
    }
  
    // 1.2 消费者线程
    class TaskConsumeThread extends Thread {
        public TaskConsumeThread(String name) {
            super(name);
        }

        // 线程池中具体的某个任务
        Runnable task;

        public void run() {
            System.out.println("启动： " + this.getName());
            while (true) {
                synchronized (tasks) {
                    // 没有任务时，将线程任务池全部置为闲置
                    // 如果一直没有任务，将一直保持等待状态，并在此while循环
                    // 10个线程，就表示有10个线程在闲置在此处并循环
                    while (tasks.isEmpty()) {
                        try {
                          // 等待中，释放task对象，后面的代码就不会执行了，包括这个自己这个while，notifyAll之后才会继续执行while
                            tasks.wait();
                        } catch (InterruptedException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                    }
                    // 当没有任务时，下面的代码都不会执行

                    // 当添加任务后，上面的代码不执行了，执行下面的代码完成任务
                    // 2.3 获取最后一个任务
                    task = tasks.removeLast();
                }
                System.out.println(this.getName() + " 获取到任务，并执行");
                task.run();
                // 执行完成后又继续返回上面开始等待
            }
        }
    }

    // 2.1 将任务添加到任务容器中，并通知线程池中所有线程唤醒
    public void add(Runnable r) {
        synchronized (tasks) {
            // 添加到任务容器中，但是线程还是等待中
            tasks.add(r);
            // 2.2 唤醒等待的任务消费者线程，让其继续执行后面的代码
            // 这里一唤醒，整个10个线程都被唤醒，继续执行其while
            tasks.notifyAll();
        }
    }

}
```

注意

等待永远是基于对象的线程等待，就是等待在这个对象上的线程，这个线程是在等待这个对象可以使用

当然这个对象不可以使用，那么基于这个对象的线程也就没有作用，闲置，只有这个对象被唤醒，这些线程才被唤醒



### java自带线程池

java提供自带的线程池，而不需要自己去开发一个自定义线程池了。

线程池类ThreadPoolExecutor在包java.util.concurrent下

```java
ThreadPoolExecutor threadPool= new ThreadPoolExecutor(10, 15, 60, TimeUnit.SECONDS, new LinkedBlockingQueue<Runnable>());
```

第一个参数10 表示这个线程池初始化了10个线程在里面工作

第二个参数15 表示如果10个线程不够用了，就会自动增加到最多15个线程

第三个参数60 结合第四个参数TimeUnit.SECONDS，表示经过60秒，多出来的线程还没有接到活儿，就会回收，最后保持池子里就10个
第四个参数TimeUnit.SECONDS 如上
第五个参数 new LinkedBlockingQueue() 用来放任务的集合

execute方法用于添加新的任务，独立于LinkedBlockingQueue集合任务的任务

```java
package multiplethread;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class TestThread {
  public static void main(String[] args) throws InterruptedException {
      ThreadPoolExecutor threadPool= new ThreadPoolExecutor(10, 15, 60, TimeUnit.SECONDS, new LinkedBlockingQueue<Runnable>());

      threadPool.execute(new Runnable(){
          @Override
          public void run() {
              // TODO Auto-generated method stub
              System.out.println("任务1");
          }

      });
   
	}
}
```



## 原子性

所谓的`原子性操作`即不可中断的操作，比如赋值操作

```java
int i = 5;
```

原子性操作本身是线程安全的
但是 i++ 这个行为，事实上是有3个原子性操作组成的。

- 步骤 1. 把i读取到用户空间
- 步骤 2. i + 1
- 步骤 3. 然后再把i写道内核空间

这三个步骤，每一步都是一个原子操作，但是合在一起，就不是原子操作。就不是线程安全的。
换句话说，一个线程在步骤1 取i 的值结束后，还没有来得及进行步骤2，另一个线程也可以取 i的值了。
i++ ，i--， i = i+1 这些都是非原子性操作。
`只有int i = 1,这个赋值操作是原子性的`，加减法都不是



### AtomicInteger

JDK6 以后，新增加了一个包java.util.concurrent.atomic，里面有各种原子类，比如AtomicInteger。
而AtomicInteger提供了各种自增，自减等方法，这些方法都是原子性的。 换句话说，自增方法 incrementAndGet 是线程安全的，同一个时间，只有一个线程可以调用这个方法。

```java
package multiplethread;
   
import java.util.concurrent.atomic.AtomicInteger;
   
public class TestThread {
   
    public static void main(String[] args) throws InterruptedException {
        AtomicInteger atomicI =new AtomicInteger();
        int i = atomicI.decrementAndGet();
        int j = atomicI.incrementAndGet();
        int k = atomicI.addAndGet(3);	// k + 3
    }
}
```



### 原子操作测试

```java
package com.easylee.multithreading;

import java.util.concurrent.atomic.AtomicInteger;

/
 * @author easylee
 * @createTime 2022/3/27 07:59
 * @updateTime 2022/3/27 07:59
 * @Version 1.0.0
 */
public class Atomicity {
    private static int value = 0;
    // 创建原子对象
    private static AtomicInteger atomicValue =new AtomicInteger();
    public static void main(String[] args) {
        // 创建100000个线程
        int number = 100000;
        Thread[] ts1 = new Thread[number];
        for (int i = 0; i < number; i++) {
            Thread t =new Thread(){
                public void run(){
                    value++;
                }
            };
            t.start();
            // 将已经启动的线程保存到线程数组中，当然这些线程已经启动过一次
            ts1[i] = t;
        }

        //
        for (Thread t : ts1) {
            try {
                // 加入的线程必须已经启动，加入主线程，再次启动运行
                t.join();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        // 现在性能过快，可能值还是100000，但是有时候是999998或999999
        System.out.printf("%d个线程进行value++后，value的值变成:%d%n", number,value);

        Thread[] ts2 = new Thread[number];
        for (int i = 0; i < number; i++) {
            Thread t =new Thread(){
                public void run(){
                    atomicValue.incrementAndGet();
                }
            };
            t.start();
            ts2[i] = t;
        }

        //等待这些线程全部结束
        for (Thread t : ts2) {
            try {
                t.join();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        System.out.printf("%d个线程进行atomicValue.incrementAndGet();后，atomicValue的值变成:%d%n", number,atomicValue.intValue());
    }
}
```

# Java I/O

**注意：**这块会涉及到操作系统和计算机组成原理相关内容。

I/O简而言之，就是输入输出，那么为什么会有I/O呢？其实I/O无时无刻都在我们的身边，比如读取硬盘上的文件，网络文件传输，鼠标键盘输入，也可以是接受单片机发回的数据，而能够支持这些操作的设备就是I/O设备。

我们可以大致看一下整个计算机的总线结构：

![img](assets/Java SE(二)/src=http%3A%2F%2Fimg2020.cnblogs.com%2Fblog%2F1896043%2F202005%2F1896043-20200507143508957-1866569205.jpg&refer=http%3A%2F%2Fimg2020.cnblogs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

常见的I/O设备一般是鼠标、键盘这类通过USB进行传输的外设或者是通过Sata接口或是M.2连接的硬盘。一般情况下，这些设备是由CPU发出指令通过南桥芯片间接进行控制，而不是由CPU直接操作。

而我们在程序中，想要读取这些外部连接的I/O设备中的内容，就需要将数据传输到内存中。而需要实现这样的操作，单单凭借一个小的程序是无法做到的，而操作系统（如：Windows/Linux/MacOS）就是专门用于控制和管理计算机硬件和软件资源的软件，我们需要读取一个IO设备的内容时，可以向操作系统发出请求，由操作系统帮助我们来和底层的硬件交互以完成我们的读取/写入请求。从读取硬盘文件的角度来说，不同的操作系统有着不同的文件系统（也就是文件在硬盘中的存储排列方式，如Windows就是NTFS、MacOS就是APFS），硬盘只能存储一个个0和1这样的二进制数据，至于0和1如何排列，各自又代表什么意思，就是由操作系统的文件系统来决定的。从网络通信角度来说，网络信号通过网卡等设备翻译为二进制信号，再交给系统进行读取，最后再由操作系统来给到程序。

JDK提供了一套用于IO操作的框架，根据流的传输方向和读取单位，分为字节流InputStream和OutputStream以及字符流Reader和Writer，当然，这里的Stream并不是前面集合框架认识的Stream，这里的流指的是数据流，通过流，我们就可以一直从流中读取数据，直到读取到尽头，或是不断向其中写入数据，直到我们写入完成。而这类IO就是我们所说的BIO，

字节流一次读取一个字节，也就是一个`byte`的大小，而字符流顾名思义，就是一次读取一个字符，也就是一个`char`的大小（在读取纯文本文件的时候更加适合），有关这两种流，会在后面详细介绍，这个章节我们需要学习16个关键的流。

## 文件流

要学习和使用IO，首先就要从最易于理解的读取文件开始说起。

### 文件字节流

首先介绍一下FileInputStream，通过它来获取文件的输入流。

```java
public static void main(String[] args) {
    try {
        FileInputStream inputStream = new FileInputStream("路径");
        //路径支持相对路径和绝对路径
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    }
}
```

相对路径是在当前运行的路径下寻找文件，而绝对路径，是从根目录开始寻找。路径分割符支持使用`/`或是`\\`，但是不能写为`\`因为它是转义字符！

在使用完成一个流之后，必须关闭这个流来完成对资源的释放，否则资源会被一直占用！

```java
public static void main(String[] args) {
    FileInputStream inputStream = null;    //定义可以先放在try外部
    try {
        inputStream = new FileInputStream("路径");
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {    //建议在finally中进行，因为这个是任何情况都必须要执行的！
            if(inputStream != null) inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

虽然这样的写法才是最保险的，但是显得过于繁琐了，尤其是finally中再次嵌套了一个try-catch块，因此在JDK1.7新增了try-with-resource语法，用于简化这样的写法（本质上还是和这样的操作一致，只是换了个写法）

```java
public static void main(String[] args) {

    //注意，这种语法只支持实现了AutoCloseable接口的类！
    try(FileInputStream inputStream = new FileInputStream("路径")) {   //直接在try()中定义要在完成之后释放的资源

    } catch (IOException e) {   //这里变成IOException是因为调用close()可能会出现，而FileNotFoundException是继承自IOException的
        e.printStackTrace();
    }
    //无需再编写finally语句块，因为在最后自动帮我们调用了close()
}
```

之后为了方便，我们都使用此语法进行教学。

```java
public static void main(String[] args) {
    //test.txt：a
    try(FileInputStream inputStream = new FileInputStream("test.txt")) {
        //使用read()方法进行字符读取
        System.out.println((char) inputStream.read());  //读取一个字节的数据（英文字母只占1字节，中文占2字节）
        System.out.println(inputStream.read());   //唯一一个字节的内容已经读完了，再次读取返回-1表示没有内容了
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

使用read可以直接读取一个字节的数据，注意，流的内容是有限的，读取一个少一个！我们如果想一次性全部读取的话，可以直接使用一个while循环来完成：

```java
public static void main(String[] args) {
    //test.txt：abcd
    try(FileInputStream inputStream = new FileInputStream("test.txt")) {
        int tmp;
        while ((tmp = inputStream.read()) != -1){   //通过while循环来一次性读完内容
            System.out.println((char)tmp);
        }
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

使用方法能查看当前可读的剩余字节数量（注意：并不一定真实的数据量就是这么多，尤其是在网络I/O操作时，这个方法只能进行一个预估也可以说是暂时能一次性读取的数量）

```java
try(FileInputStream inputStream = new FileInputStream("test.txt")) {
    System.out.println(inputStream.available());  //查看剩余数量
}catch (IOException e){
    e.printStackTrace();
}
```

当然，一个一个读取效率太低了，那能否一次性全部读取呢？我们可以预置一个合适容量的byte[]数组来存放。

```java
public static void main(String[] args) {
    //test.txt：abcd
    try(FileInputStream inputStream = new FileInputStream("test.txt")) {
        byte[] bytes = new byte[inputStream.available()];   //我们可以提前准备好合适容量的byte数组来存放
        System.out.println(inputStream.read(bytes));   //一次性读取全部内容（返回值是读取的字节数）
        System.out.println(new String(bytes));   //通过String(byte[])构造方法得到字符串
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

也可以控制要读取数量：

```java
System.out.println(inputStream.read(bytes, 1, 2));   //第二个参数是从给定数组的哪个位置开始放入内容，第三个参数是读取流中的字节数
```

**注意**：一次性读取同单个读取一样，当没有任何数据可读时，依然会返回-1

通过`skip()`方法可以跳过指定数量的字节：

```java
public static void main(String[] args) {
    //test.txt：abcd
    try(FileInputStream inputStream = new FileInputStream("test.txt")) {
        System.out.println(inputStream.skip(1));
        System.out.println((char) inputStream.read());   //跳过了一个字节
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

注意：FileInputStream是不支持`reset()`的，虽然有这个方法，但是这里先不提及。

既然有输入流，那么文件输出流也是必不可少的：

```java
public static void main(String[] args) {
    //输出流也需要在最后调用close()方法，并且同样支持try-with-resource
    try(FileOutputStream outputStream = new FileOutputStream("output.txt")) {
        //注意：若此文件不存在，会直接创建这个文件！
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

输出流没有`read()`操作而是`write()`操作，使用方法同输入流一样，只不过现在的方向变为我们向文件里写入内容：

```java
public static void main(String[] args) {
    try(FileOutputStream outputStream = new FileOutputStream("output.txt")) {
        outputStream.write('c');   //同read一样，可以直接写入内容
      	outputStream.write("lbwnb".getBytes());   //也可以直接写入byte[]
      	outputStream.write("lbwnb".getBytes(), 0, 1);  //同上输入流
      	outputStream.flush();  //建议在最后执行一次刷新操作（强制写入）来保证数据正确写入到硬盘文件中
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

那么如果是我只想在文件尾部进行追加写入数据呢？我们可以调用另一个构造方法来实现：

```java
public static void main(String[] args) {
    try(FileOutputStream outputStream = new FileOutputStream("output.txt", true)) {
        outputStream.write("lb".getBytes());   //现在只会进行追加写入，而不是直接替换原文件内容
        outputStream.flush();
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

利用输入流和输出流，就可以轻松实现文件的拷贝了：

```java
public static void main(String[] args) {
    try(FileOutputStream outputStream = new FileOutputStream("output.txt");
        FileInputStream inputStream = new FileInputStream("test.txt")) {   //可以写入多个
        byte[] bytes = new byte[10];    //使用长度为10的byte[]做传输媒介
        int tmp;   //存储本地读取字节数
        while ((tmp = inputStream.read(bytes)) != -1){   //直到读取完成为止
            outputStream.write(bytes, 0, tmp);    //写入对应长度的数据到输出流
        }
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

### 文件字符流

字符流不同于字节，字符流是以一个具体的字符进行读取，因此它只适合读纯文本的文件，如果是其他类型的文件不适用：

```java
public static void main(String[] args) {
    try(FileReader reader = new FileReader("test.txt")){
      	reader.skip(1);   //现在跳过的是一个字符
        System.out.println((char) reader.read());   //现在是按字符进行读取，而不是字节，因此可以直接读取到中文字符
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

同理，字符流只支持`char[]`类型作为存储：

```java
public static void main(String[] args) {
    try(FileReader reader = new FileReader("test.txt")){
        char[] str = new char[10];
        reader.read(str);
        System.out.println(str);   //直接读取到char[]中
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

既然有了Reader肯定也有Writer：

```java
public static void main(String[] args) {
    try(FileWriter writer = new FileWriter("output.txt")){
      	writer.getEncoding();   //支持获取编码（不同的文本文件可能会有不同的编码类型）
       writer.write('牛');
       writer.append('牛');   //其实功能和write一样
      	writer.flush();   //刷新
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

我们发现不仅有`write()`方法，还有一个`append()`方法，但是实际上他们效果是一样的，看源码：

```java
/**
 * Appends the specified character to this writer.
 *
 * <p> An invocation of this method of the form <tt>out.append(c)</tt>
 * behaves in exactly the same way as the invocation
 *
 * <pre>
 *     out.write(c) </pre>
 *
 * @param  c
 *         The 16-bit character to append
 *
 * @return  This writer
 *
 * @throws  IOException
 *          If an I/O error occurs
 *
 * @since 1.5
 */
public Writer append(char c) throws IOException {
    write(c);
    return this;
}
```

append支持像StringBuilder那样的链式调用，返回的是Writer对象本身。

**练习**：尝试一下用Reader和Writer来拷贝纯文本文件

### File类

File类专门用于表示一个文件或文件夹，只不过它只是代表这个文件，但并不是这个文件本身。通过File对象，可以更好地管理和操作硬盘上的文件。

```java
public static void main(String[] args) {
    File file = new File("test.txt");   //直接创建文件对象，可以是相对路径，也可以是绝对路径
    System.out.println(file.exists());   //此文件是否存在
    System.out.println(file.length());   //获取文件的大小
    System.out.println(file.isDirectory());   //是否为一个文件夹
    System.out.println(file.canRead());   //是否可读
    System.out.println(file.canWrite());   //是否可写
    System.out.println(file.canExecute());   //是否可执行
}
```

通过File对象，我们就能快速得到文件的所有信息，如果是文件夹，还可以获取文件夹内部的文件列表等内容：

```java
File file = new File("/");
System.out.println(Arrays.toString(file.list()));   //快速获取文件夹下的文件名称列表
for (File f : file.listFiles()){   //所有子文件的File对象
    System.out.println(f.getAbsolutePath());   //获取文件的绝对路径
}
```

如果我们希望读取某个文件的内容，可以直接将File作为参数传入字节流或是字符流：

```java
File file = new File("test.txt");
try (FileInputStream inputStream = new FileInputStream(file)){   //直接做参数
    System.out.println(inputStream.available());
}catch (IOException e){
    e.printStackTrace();
}
```

**练习**：尝试拷贝文件夹下的所有文件到另一个文件夹

***

## 缓冲流

虽然普通的文件流读取文件数据非常便捷，但是每次都需要从外部I/O设备去获取数据，由于外部I/O设备的速度一般都达不到内存的读取速度，很有可能造成程序反应迟钝，因此性能还不够高，而缓冲流正如其名称一样，它能够提供一个缓冲，提前将部分内容存入内存（缓冲区）在下次读取时，如果缓冲区中存在此数据，则无需再去请求外部设备。同理，当向外部设备写入数据时，也是由缓冲区处理，而不是直接向外部设备写入。

![img](assets/Java SE(二)/src=http%3A%2F%2Fwww.wityx.com%2Fimage%2F201908%2F480873DBD936EBA9518F721ACDC22BFE.png&refer=http%3A%2F%2Fwww.wityx.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

### 缓冲字节流

要创建一个缓冲字节流，只需要将原本的流作为构造参数传入BufferedInputStream即可：

```java
public static void main(String[] args) {
    try (BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream("test.txt"))){   //传入FileInputStream
        System.out.println((char) bufferedInputStream.read());   //操作和原来的流是一样的
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

实际上进行I/O操作的并不是BufferedInputStream，而是我们传入的FileInputStream，而BufferedInputStream虽然有着同样的方法，但是进行了一些额外的处理然后再调用FileInputStream的同名方法，这样的写法称为`装饰者模式`

```java
public void close() throws IOException {
    byte[] buffer;
    while ( (buffer = buf) != null) {
        if (bufUpdater.compareAndSet(this, buffer, null)) {  //CAS无锁算法，并发会用到，暂时不管
            InputStream input = in;
            in = null;
            if (input != null)
                input.close();
            return;
        }
        // Else retry in case a new buf was CASed in fill()
    }
}
```

实际上这种模式是父类FilterInputStream提供的规范，后面我们还会讲到更多FilterInputStream的子类。

我们可以发现在BufferedInputStream中还存在一个专门用于缓存的数组：

```java
/**
 * The internal buffer array where the data is stored. When necessary,
 * it may be replaced by another array of
 * a different size.
 */
protected volatile byte buf[];
```

I/O操作一般不能重复读取内容（比如键盘发送的信号，主机接收了就没了），而缓冲流提供了缓冲机制，一部分内容可以被暂时保存，BufferedInputStream支持`reset()`和`mark()`操作，首先我们来看看`mark()`方法的介绍：

```java
/**
 * Marks the current position in this input stream. A subsequent
 * call to the <code>reset</code> method repositions this stream at
 * the last marked position so that subsequent reads re-read the same bytes.
 * <p>
 * The <code>readlimit</code> argument tells this input stream to
 * allow that many bytes to be read before the mark position gets
 * invalidated.
 * <p>
 * This method simply performs <code>in.mark(readlimit)</code>.
 *
 * @param   readlimit   the maximum limit of bytes that can be read before
 *                      the mark position becomes invalid.
 * @see     java.io.FilterInputStream#in
 * @see     java.io.FilterInputStream#reset()
 */
public synchronized void mark(int readlimit) {
    in.mark(readlimit);
}
```

当调用`mark()`之后，输入流会以某种方式保留之后读取的`readlimit`数量的内容，当读取的内容数量超过`readlimit`则之后的内容不会被保留，当调用`reset()`之后，会使得当前的读取位置回到`mark()`调用时的位置。

```java
public static void main(String[] args) {
    try (BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream("test.txt"))){
        bufferedInputStream.mark(1);   //只保留之后的1个字符
        System.out.println((char) bufferedInputStream.read());
        System.out.println((char) bufferedInputStream.read());
        bufferedInputStream.reset();   //回到mark时的位置
        System.out.println((char) bufferedInputStream.read());
        System.out.println((char) bufferedInputStream.read());
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

我们发现虽然后面的部分没有保存，但是依然能够正常读取，其实`mark()`后保存的读取内容是取`readlimit`和BufferedInputStream类的缓冲区大小两者中的最大值，而并非完全由`readlimit`确定。因此我们限制一下缓冲区大小，再来观察一下结果：

```java
public static void main(String[] args) {
    try (BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream("test.txt"), 1)){  //将缓冲区大小设置为1
        bufferedInputStream.mark(1);   //只保留之后的1个字符
        System.out.println((char) bufferedInputStream.read());
        System.out.println((char) bufferedInputStream.read());   //已经超过了readlimit，继续读取会导致mark失效
        bufferedInputStream.reset();   //mark已经失效，无法reset()
        System.out.println((char) bufferedInputStream.read());
        System.out.println((char) bufferedInputStream.read());
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

了解完了BufferedInputStream之后，我们再来看看BufferedOutputStream，其实和BufferedInputStream原理差不多，只是反向操作：

```java
public static void main(String[] args) {
    try (BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream("output.txt"))){
        outputStream.write("lbwnb".getBytes());
        outputStream.flush();
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

操作和FileOutputStream一致，这里就不多做介绍了。

### 缓冲字符流

缓存字符流和缓冲字节流一样，也有一个专门的缓冲区，BufferedReader构造时需要传入一个Reader对象：

```java
public static void main(String[] args) {
    try (BufferedReader reader = new BufferedReader(new FileReader("test.txt"))){
        System.out.println((char) reader.read());
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

使用和reader也是一样的，内部也包含一个缓存数组：

```java
private char cb[];
```

相比Reader更方便的是，它支持按行读取：

```java
public static void main(String[] args) {
    try (BufferedReader reader = new BufferedReader(new FileReader("test.txt"))){
        System.out.println(reader.readLine());   //按行读取
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

读取后直接得到一个字符串，当然，它还能把每一行内容依次转换为集合类提到的Stream流：

```java
public static void main(String[] args) {
    try (BufferedReader reader = new BufferedReader(new FileReader("test.txt"))){
        reader
                .lines()
                .limit(2)
                .distinct()
                .sorted()
                .forEach(System.out::println);
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

它同样也支持`mark()`和`reset()`操作：

```java
public static void main(String[] args) {
    try (BufferedReader reader = new BufferedReader(new FileReader("test.txt"))){
        reader.mark(1);
        System.out.println((char) reader.read());
        reader.reset();
        System.out.println((char) reader.read());
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

BufferedReader处理纯文本文件时就更加方便了，BufferedWriter在处理时也同样方便：

```java
public static void main(String[] args) {
    try (BufferedWriter reader = new BufferedWriter(new FileWriter("output.txt"))){
        reader.newLine();   //使用newLine进行换行
        reader.write("汉堡做滴彳亍不彳亍");   //可以直接写入一个字符串
      	reader.flush();   //清空缓冲区
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

***

## 转换流

有时会遇到这样一个很麻烦的问题：我这里读取的是一个字符串或是一个个字符，但是我只能往一个OutputStream里输出，但是OutputStream又只支持byte类型，如果要往里面写入内容，进行数据转换就会很麻烦，那么能否有更加简便的方式来做这样的事情呢？

```java
public static void main(String[] args) {
    try(OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream("test.txt"))){  //虽然给定的是FileOutputStream，但是现在支持以Writer的方式进行写入
        writer.write("lbwnb");   //以操作Writer的样子写入OutputStream
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

同样的，我们现在只拿到了一个InputStream，但是我们希望能够按字符的方式读取，我们就可以使用InputStreamReader来帮助我们实现：

```java
public static void main(String[] args) {
    try(InputStreamReader reader = new InputStreamReader(new FileInputStream("test.txt"))){  //虽然给定的是FileInputStream，但是现在支持以Reader的方式进行读取
        System.out.println((char) reader.read());
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

InputStreamReader和OutputStreamWriter本质也是Reader和Writer，因此可以直接放入BufferedReader来实现更加方便的操作。

***

## 打印流

打印流其实我们从一开始就在使用了，比如`System.out`就是一个PrintStream，PrintStream也继承自FilterOutputStream类因此依然是装饰我们传入的输出流，但是它存在自动刷新机制，例如当向PrintStream流中写入一个字节数组后自动调用`flush()`方法。PrintStream也永远不会抛出异常，而是使用内部检查机制`checkError()`方法进行错误检查。最方便的是，它能够格式化任意的类型，将它们以字符串的形式写入到输出流。

```java
public final static PrintStream out = null;
```

可以看到`System.out`也是PrintStream，不过默认是向控制台打印，我们也可以让它向文件中打印：

```java
public static void main(String[] args) {
    try(PrintStream stream = new PrintStream(new FileOutputStream("test.txt"))){
        stream.println("lbwnb");   //其实System.out就是一个PrintStream
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

我们平时使用的`println`方法就是PrintStream中的方法，它会直接打印基本数据类型或是调用对象的`toString()`方法得到一个字符串，并将字符串转换为字符，放入缓冲区再经过转换流输出到给定的输出流上。

![img](assets/Java SE(二)/70.png)

因此实际上内部还包含这两个内容：

```java
/**
 * Track both the text- and character-output streams, so that their buffers
 * can be flushed without flushing the entire stream.
 */
private BufferedWriter textOut;
private OutputStreamWriter charOut;
```

与此相同的还有一个PrintWriter，不过他们的功能基本一致，PrintWriter的构造方法可以接受一个Writer作为参数，这里就不再做过多阐述了。

***

## 数据流

数据流DataInputStream也是FilterInputStream的子类，同样采用装饰者模式，最大的不同是它支持基本数据类型的直接读取：

```java
public static void main(String[] args) {
    try (DataInputStream dataInputStream = new DataInputStream(new FileInputStream("test.txt"))){
        System.out.println(dataInputStream.readBoolean());   //直接将数据读取为任意基本数据类型
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

用于写入基本数据类型：

```java
public static void main(String[] args) {
    try (DataOutputStream dataOutputStream = new DataOutputStream(new FileOutputStream("output.txt"))){
        dataOutputStream.writeBoolean(false);
    }catch (IOException e) {
        e.printStackTrace();
    }
}
```

注意，写入的是二进制数据，并不是写入的字符串，使用DataInputStream可以读取，一般他们是配合一起使用的。

## 对象流

既然基本数据类型能够读取和写入基本数据类型，那么能否将对象也支持呢？ObjectOutputStream不仅支持基本数据类型，通过对对象的序列化操作，以某种格式保存对象，来支持对象类型的IO，注意：它不是继承自FilterInputStream的。

```java
public static void main(String[] args) {
    try (ObjectOutputStream outputStream = new ObjectOutputStream(new FileOutputStream("output.txt"));
         ObjectInputStream inputStream = new ObjectInputStream(new FileInputStream("output.txt"))){
        People people = new People("lbw");
        outputStream.writeObject(people);
      	outputStream.flush();
        people = (People) inputStream.readObject();
        System.out.println(people.name);
    }catch (IOException | ClassNotFoundException e) {
        e.printStackTrace();
    }
}

static class People implements Serializable{   //必须实现Serializable接口才能被序列化
    String name;

    public People(String name){
        this.name = name;
    }
}
```

在我们后续的操作中，有可能会使得这个类的一些结构发生变化，而原来保存的数据只适用于之前版本的这个类，因此我们需要一种方法来区分类的不同版本：

```java
static class People implements Serializable{
    private static final long serialVersionUID = 123456;   //在序列化时，会被自动添加这个属性，它代表当前类的版本，我们也可以手动指定版本。

    String name;

    public People(String name){
        this.name = name;
    }
}
```

当发生版本不匹配时，会无法反序列化为对象：

```java
java.io.InvalidClassException: com.test.Main$People; local class incompatible: stream classdesc serialVersionUID = 123456, local class serialVersionUID = 1234567
	at java.io.ObjectStreamClass.initNonProxy(ObjectStreamClass.java:699)
	at java.io.ObjectInputStream.readNonProxyDesc(ObjectInputStream.java:2003)
	at java.io.ObjectInputStream.readClassDesc(ObjectInputStream.java:1850)
	at java.io.ObjectInputStream.readOrdinaryObject(ObjectInputStream.java:2160)
	at java.io.ObjectInputStream.readObject0(ObjectInputStream.java:1667)
	at java.io.ObjectInputStream.readObject(ObjectInputStream.java:503)
	at java.io.ObjectInputStream.readObject(ObjectInputStream.java:461)
	at com.test.Main.main(Main.java:27)
```

如果我们不希望某些属性参与到序列化中进行保存，我们可以添加`transient`关键字：

```java
public static void main(String[] args) {
    try (ObjectOutputStream outputStream = new ObjectOutputStream(new FileOutputStream("output.txt"));
         ObjectInputStream inputStream = new ObjectInputStream(new FileInputStream("output.txt"))){
        People people = new People("lbw");
        outputStream.writeObject(people);
        outputStream.flush();
        people = (People) inputStream.readObject();
        System.out.println(people.name);  //虽然能得到对象，但是name属性并没有保存，因此为null
    }catch (IOException | ClassNotFoundException e) {
        e.printStackTrace();
    }
}

static class People implements Serializable{
    private static final long serialVersionUID = 1234567;

    transient String name;

    public People(String name){
        this.name = name;
    }
}
```

其实我们可以看到，在一些JDK内部的源码中，也存在大量的transient关键字，使得某些属性不参与序列化，取消这些不必要保存的属性，可以节省数据空间占用以及减少序列化时间。



## 输入流和输出流的判断

基本每个流都有输入(input)和输出(output)，如果判断什么时候用输入，什么时候用输出

- 输入input：从各种设备，各种操作，各种文件，或者各种代码，`读入内存中`
- 输出output：`从内存读出到`各种设备、文件或各种介质

程序操作的数据都应该是在内存里面，内存是你操作的主对象，把数据从其他资源里面传送到内存里面，就是输入，反之。把数据从内存传送到其他资源就是输出。

# 反射

**注意：**本章节涉及到JVM相关底层原理，难度会有一些大。

反射就是把Java类中的各个成分映射成一个个的Java对象。即在运行状态中，对于任意一个类，都能够知道这个类所有的属性和方法，对于任意一个对象，都能调用它的任意一个方法和属性。这种动态获取信息及动态调用对象方法的功能叫Java的反射机制。

简而言之，我们可以通过反射机制，获取到类的一些属性，包括类里面有哪些字段，有哪些方法，继承自哪个类，甚至还能获取到泛型！它的权限非常高，慎重使用！

## Java类加载机制

在学习Java的反射机制之前，我们需要先了解一下类的加载机制，一个类是如何被加载和使用的：

![img](assets/Java SE(二)/src=http%3A%2F%2Fimg3.itboth.com%2F60%2F50%2FUrUVN3.png&refer=http%3A%2F%2Fimg3.itboth.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg)

在Java程序启动时，JVM会将一部分类（使用到的class文件）先加载（并不是所有的类都会在一开始加载），通过ClassLoader将类加载，在加载过程中，会将类的信息提取出来（存放在元空间中，JDK1.8之前存放在永久代），同时也会生成一个Class对象存放在内存（堆内存，Student.class这种，这是类对象不是实例对象，是和类唯一对应相关的），注意此Class对象只会存在一个，与加载的类唯一对应！

**思考：**既然说和与加载的类唯一对应，那如果我们手动创建一个与JDK包名一样，同时类名也保持一致，那么JVM会加载这个类吗？

```java
package java.lang;

public class String {    //JDK提供的String类也是
    public static void main(String[] args) {
        System.out.println("我姓🐴，我叫🐴nb");
    }
}
```

我们发现，会出现以下报错：

```java
错误: 在类 java.lang.String 中找不到 main 方法, 请将 main 方法定义为:
   public static void main(String[] args)
```

但是我们明明在自己写的String类中定义了main方法啊，为什么会找不到此方法呢？实际上这是ClassLoader的`双亲委派机制`在保护Java程序的正常运行：

![img](assets/Java SE(二)/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NvZGV5YW5iYW8=,size_16,color_FFFFFF,t_70.png)

上图流程：从开始位置，从下往上首先判断是否已经加载过，新启动的应用肯定都没有加载，然后从上往下首先加载BootstarpClassLoader，然后一直往下

实际上我们的类最开始是由BootstarpClassLoader进行加载，BootstarpClassLoader用于加载JDK提供的类，所以首先加载jdk核心的String类，里面没有main方法，而我们自己编写的类实际上是AppClassLoader，只有BootstarpClassLoader都没有加载的类，才会让AppClassLoader来加载，因此我们自己编写的同名包同名类不会被加载，而实际要去启动的是真正的String类，也就自然找不到`main`方法了！

```java
public class Main {
    public static void main(String[] args) {
        System.out.println(Main.class.getClassLoader());   //查看当前类的类加载器
        System.out.println(Main.class.getClassLoader().getParent());  //父加载器
        System.out.println(Main.class.getClassLoader().getParent().getParent());  //null，爷爷加载器
        System.out.println(String.class.getClassLoader());   //null，String类的加载器
    }
}
```

由于BootstarpClassLoader是C++编写的，我们在Java中是获取不到的，显示null。

## Class对象

通过前面，我们了解了类的加载，同时会提取一个类的信息生成Class对象存放在内存中，而反射机制其实就是利用这些存放的类信息，来获取类的信息和操作类。那么如何获取到每个类对应的Class对象呢，我们可以通过以下方式：

```java
public static void main(String[] args) throws ClassNotFoundException {
    Class<String> clazz = String.class;   //使用class关键字，通过类名获取
    Class<?> clazz2 = Class.forName("java.lang.String");   //使用Class类静态方法forName()，通过包名.类名获取，注意返回值是Class<?>
    Class<?> clazz3 = new String("cpdd").getClass();  //通过实例对象获取
}
```

注意Class类也是一个泛型类，只有第一种方法，能够直接获取到对应类型的Class对象，而以下两种方法使用了`?`通配符作为返回值，因为不知道forName里面具体是什么类，但是实际上都和第一个返回的是同一个对象：

```java
Class<String> clazz = String.class;   //使用class关键字，通过类名获取
Class<?> clazz2 = Class.forName("java.lang.String");   //使用Class类静态方法forName()，通过包名.类名获取，注意返回值是Class<?>
Class<?> clazz3 = new String("cpdd").getClass();

System.out.println(clazz == clazz2);
System.out.println(clazz == clazz3);
```

通过比较，验证了我们一开始的结论，在JVM中每个类始终只存在一个Class对象，无论通过什么方法获取，都是一样的。现在我们再来看看这个问题：

```java
public static void main(String[] args) {
    Class<?> clazz = int.class;   //基本数据类型有Class对象吗？
    System.out.println(clazz);
}
```

迷了，不是每个类才有Class对象吗，基本数据类型又不是类，这也行吗？实际上，基本数据类型也有对应的Class对象（反射操作可能需要用到），而且我们不仅可以通过class关键字获取，其实本质上是定义在对应的包装类中的：

```java
/**
 * The {@code Class} instance representing the primitive type
 * {@code int}.
 *
 * @since   JDK1.1
 */
@SuppressWarnings("unchecked")
public static final Class<Integer>  TYPE = (Class<Integer>) Class.getPrimitiveClass("int");

/*
 * Return the Virtual Machine's Class object for the named
 * primitive type
 */
static native Class<?> getPrimitiveClass(String name);   //C++实现，并非Java定义
```

每个包装类中（包括Void），都有一个获取原始类型Class方法，注意，getPrimitiveClass获取的是原始类型，并不是包装类型，只是可以使用包装类来表示。

```java
public static void main(String[] args) {
    Class<?> clazz = int.class;
    System.out.println(Integer.TYPE == int.class); // false
}
```

通过对比，我们发现实际上包装类型都有一个TYPE，其实也就是基本类型的Class，那么包装类的Class和基本类的Class一样吗？

```java
public static void main(String[] args) {
    System.out.println(Integer.TYPE == Integer.class);
}
```

我们发现，包装类型的Class对象并不是基本类型Class对象。数组类型也是一种类型，只是编程不可见，因此我们可以直接获取数组的Class对象：

```java
public static void main(String[] args) {
    Class<String[]> clazz = String[].class;
    System.out.println(clazz.getName());  //获取类名称（得到的是包名+类名的完整名称）
    System.out.println(clazz.getSimpleName());
    System.out.println(clazz.getTypeName());
    System.out.println(clazz.getClassLoader());   //获取它的类加载器
    System.out.println(clazz.cast(new Integer("10")));   //强制类型转换
}
```

### 再谈instanceof

正常情况下，我们使用instanceof进行类型比较：

```java
public static void main(String[] args) {
    String str = "";
    System.out.println(str instanceof String);
}
```

它可以判断一个对象是否为此接口或是类的实现或是子类，而现在我们有了更多的方式去判断类型：

```java
public static void main(String[] args) {
    String str = "";
    System.out.println(str.getClass() == String.class);   //直接判断是否为这个类型
}
```

如果需要判断是否为子类或是接口/抽象类的实现，我们可以使用`asSubClass()`方法：

```java
public static void main(String[] args) {
    Integer i = 10;
    i.getClass().asSubclass(Number.class);   //当Integer不是Number的子类时，会产生异常
}
```

### 获取父类信息

通过`getSuperclass()`方法，我们可以获取到父类的Class对象：

```java
public static void main(String[] args) {
    Integer i = 10;
    System.out.println(i.getClass().getSuperclass());
}
```

也可以通过`getGenericSuperclass()`获取父类的原始类型的Type：

```java
public static void main(String[] args) {
    Integer i = 10;
    Type type = i.getClass().getGenericSuperclass();
    System.out.println(type);
    System.out.println(type instanceof Class);
}
```

我们发现Type实际上是Class类的父接口，但是获取到的Type的实现并不一定是Class。

同理，我们也可以像上面这样获取父接口：

```java
public static void main(String[] args) {
    Integer i = 10;
    for (Class<?> anInterface : i.getClass().getInterfaces()) {
        System.out.println(anInterface.getName());
    }
  
  	for (Type genericInterface : i.getClass().getGenericInterfaces()) {
        System.out.println(genericInterface.getTypeName());
    }
}
```

## 创建类对象

既然我们拿到了类的定义，那么是否可以通过Class对象来创建对象、调用方法、修改变量呢？当然是可以的，那我们首先来探讨一下如何创建一个类的对象：

```java
public static void main(String[] args) throws InstantiationException, IllegalAccessException {
    Class<Student> clazz = Student.class;
    Student student = clazz.newInstance();
    student.test();
}

static class Student{
    public void test(){
        System.out.println("萨日朗");
    }
}
```

通过使用`newInstance()`方法来创建对应类型的实例，返回泛型T，注意它会抛出InstantiationException和IllegalAccessException异常，那么什么情况下会出现异常呢？

```java
public static void main(String[] args) throws InstantiationException, IllegalAccessException {
    Class<Student> clazz = Student.class;
    Student student = clazz.newInstance();
    student.test();
}

static class Student{

    public Student(String text){
        
    }

    public void test(){
        System.out.println("萨日朗");
    }
}
```

当类默认的构造方法被带参构造覆盖时，会出现InstantiationException异常，因为`newInstance()`只适用于默认无参构造。

```java
public static void main(String[] args) throws InstantiationException, IllegalAccessException {
    Class<Student> clazz = Student.class;
    Student student = clazz.newInstance();
    student.test();
}

static class Student{

    private Student(){}

    public void test(){
        System.out.println("萨日朗");
    }
}
```

当默认无参构造的权限不是`public`时，会出现IllegalAccessException异常，表示我们无权去调用默认构造方法。在JDK9之后，不再推荐使用`newInstance()`方法了，而是使用我们接下来要介绍到的，通过获取构造器，来实例化对象：

```java
public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException {
    Class<Student> clazz = Student.class;
    Student student = 
    // 传入了String参数类型  
    clazz.getConstructor(String.class).newInstance("what's up");
    student.test();
}

static class Student{

    public Student(String str){}

    public void test(){
        System.out.println("萨日朗");
    }
}
```

通过获取类的构造方法（构造器）来创建对象实例，会更加合理，我们可以使用`getConstructor()`方法来获取类的构造方法，同时我们需要向其中填入参数，也就是构造方法需要的类型，当然我们这里只演示了。那么，当访问权限不是public的时候呢？

```java
public static void main(String[] args) throws NoSuchMethodException, InvocationTargetException, InstantiationException, IllegalAccessException {
    Class<Student> clazz = Student.class;
    Student student = clazz.getConstructor(String.class).newInstance("what's up");
    student.test();
}

static class Student{

    private Student(String str){}

    public void test(){
        System.out.println("萨日朗");
    }
}
```

我们发现，当访问权限不足时，会无法找到此构造方法，那么如何找到非public的构造方法呢？

```java
Class<Student> clazz = Student.class;
Constructor<Student> constructor = clazz.getDeclaredConstructor(String.class);	// 先找到非public构造
constructor.setAccessible(true);   //修改访问权限
Student student = constructor.newInstance("what's up");
student.test();
```

使用`getDeclaredConstructor()`方法可以找到类中的非public构造方法，但是在使用之前，我们需要先修改访问权限，在修改访问权限之后，就可以使用非public方法了（这意味着，反射可以无视权限修饰符访问类的内容）

## 调用类的方法

我们可以通过反射来调用类的方法（本质上还是类的实例进行调用）只是利用反射机制实现了方法的调用，我们在包下创建一个新的类：

```java
package com.test;

public class Student {
    public void test(String str){
        System.out.println("萨日朗"+str);
    }
}
```

这次我们通过`forName(String)`来找到这个类并创建一个新的对象：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Class<?> clazz = Class.forName("com.test.Student");
    Object instance = clazz.newInstance();   //创建出学生对象
    Method method = clazz.getMethod("test", String.class);   //通过方法名和形参类型获取类中的方法
    
    method.invoke(instance, "what's up");   //通过Method对象的invoke方法来调用方法
}
```

通过调用`getMethod()`方法，我们可以获取到类中所有声明为public的方法，得到一个Method对象，我们可以通过Method对象的`invoke()`方法（返回值就是方法的返回值，因为这里是void，返回值为null）来调用已经获取到的方法，注意传参。

我们发现，`利用反射之后，在一个对象从构造到方法调用，没有任何一处需要引用到对象的实际类型，我们也没有导入Student类，整个过程都是反射在代替进行操作，使得整个过程被模糊了，过多的使用反射，会极大地降低后期维护性。`不需要引用具体类，这就方便了框架来自由的操作类和对象了

同构造方法一样，当出现非public方法时，我们可以通过反射来无视权限修饰符，获取非public方法并调用，现在我们将`test()`方法的权限修饰符改为private：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Class<?> clazz = Class.forName("com.test.Student");
    Object instance = clazz.newInstance();   //创建出学生对象
    Method method = clazz.getDeclaredMethod("test", String.class);   //通过方法名和形参类型获取类中的方法
    method.setAccessible(true);

    method.invoke(instance, "what's up");   //通过Method对象的invoke方法来调用方法
}
```

Method和Constructor都和Class一样，他们存储了方法的信息，包括方法的形式参数列表，返回值，方法的名称等内容，我们可以直接通过Method对象来获取这些信息：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Class<?> clazz = Class.forName("com.test.Student");
    Method method = clazz.getDeclaredMethod("test", String.class);   //通过方法名和形参类型获取类中的方法
    
    System.out.println(method.getName());   //获取方法名称
    System.out.println(method.getReturnType());   //获取返回值类型
}
```

当方法的参数为可变参数时，我们该如何获取方法呢？实际上，我们在之前就已经提到过，可变参数实际上就是一个数组，因此我们可以直接使用数组的class对象表示：

```java
Method method = clazz.getDeclaredMethod("test", String[].class);
```

反射非常强大，尤其是我们提到的越权访问，但是请一定谨慎使用，别人将某个方法设置为private一定有他的理由，如果实在是需要使用别人定义为private的方法，就必须确保这样做是安全的，在没有了解别人代码的整个过程就强行越权访问，可能会出现无法预知的错误。

## 修改类的属性

我们还可以通过反射访问一个类中定义的成员字段也可以修改一个类的对象中的成员字段值，通过`getField()`方法来获取一个类定义的指定字段：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Class<?> clazz = Class.forName("com.test.Student");
    Object instance = clazz.newInstance();

    Field field = clazz.getField("i");   //获取类的成员字段i
    field.set(instance, 100);   //将类实例instance的成员字段i设置为100

    Method method = clazz.getMethod("test");
    method.invoke(instance);
}
```

在得到Field之后，我们就可以直接通过`set()`方法为某个对象，设定此属性的值，比如上面，我们就为instance对象设定值为100，当访问private字段时，同样可以按照上面的操作进行越权访问：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Class<?> clazz = Class.forName("com.test.Student");
    Object instance = clazz.newInstance();

    Field field = clazz.getDeclaredField("i");   //获取类的成员字段i
    field.setAccessible(true);
    field.set(instance, 100);   //将类实例instance的成员字段i设置为100

    Method method = clazz.getMethod("test");
    method.invoke(instance);
}
```

现在我们已经知道，反射几乎可以把一个类的老底都给扒出来，任何属性，任何内容，都可以被反射修改，无论权限修饰符是什么，那么，如果我的字段被标记为final呢？现在在字段`i`前面添加`final`关键字，我们再来看看效果：

```java
private final int i = 10;
```

这时，当字段为final时，就修改失败了！当然，通过反射可以直接将final修饰符直接去除，去除后，就可以随意修改内容了，我们来尝试修改Integer的value值：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    Integer i = 10;

    Field field = Integer.class.getDeclaredField("value");

    Field modifiersField = Field.class.getDeclaredField("modifiers");  //这里要获取Field类的modifiers字段进行修改
    modifiersField.setAccessible(true);
    modifiersField.setInt(field,field.getModifiers()&~Modifier.FINAL);  //去除final标记

    field.setAccessible(true);
    field.set(i, 100);   //强行设置值

    System.out.println(i);
}
```

我们可以发现，反射非常暴力，就连被定义为final字段的值都能强行修改，几乎能够无视一切阻拦。我们来试试看修改一些其他的类型：

```java
public static void main(String[] args) throws ReflectiveOperationException {
    List<String> i = new ArrayList<>();

    Field field = ArrayList.class.getDeclaredField("size");
    field.setAccessible(true);
    field.set(i, 10);

    i.add("测试");   //只添加一个元素
    System.out.println(i.size());  //大小直接变成11
    i.remove(10);   //瞎移除都不带报错的，淦
}
```

实际上，整个ArrayList体系由于我们的反射操作，导致被破坏，因此它已经无法正常工作了！

再次强调，在进行反射操作时，必须注意是否安全，虽然拥有了创世主的能力，但是我们不能滥用，我们只能把它当做一个不得已才去使用的工具！

## 自定义ClassLoader加载类

我们可以自己手动将class文件加载到JVM中吗？先写好我们定义的类：

```java
package com.test;

public class Test {
    public String text;

    public void test(String str){
        System.out.println(text+" > 我是测试方法！"+str);
    }
}
```

通过javac命令，手动编译一个.class文件：

```shell
nagocoler@NagodeMacBook-Pro HelloWorld % javac src/main/java/com/test/Test.java
```

编译后，得到一个class文件，我们把它放到根目录下，然后编写一个我们自己的ClassLoader，因为普通的ClassLoader无法加载二进制文件，因此我们编写一个自己的来让它支持：

```java
//定义一个自己的ClassLoader
static class MyClassLoader extends ClassLoader{
    public Class<?> defineClass(String name, byte[] b){
        return defineClass(name, b, 0, b.length);   //调用protected方法，支持载入外部class文件
    }
}

public static void main(String[] args) throws IOException {
    MyClassLoader classLoader = new MyClassLoader();
    FileInputStream stream = new FileInputStream("Test.class");
    byte[] bytes = new byte[stream.available()];
    stream.read(bytes);
    Class<?> clazz = classLoader.defineClass("com.test.Test", bytes);   //类名必须和我们定义的保持一致
    System.out.println(clazz.getName());   //成功加载外部class文件
}
```

现在，我们就将此class文件读取并解析为Class了，现在我们就可以对此类进行操作了（注意，我们无法在代码中直接使用此类型，因为它是我们直接加载的），我们来试试看创建一个此类的对象并调用其方法：

```java
try {
    Object obj = clazz.newInstance();
    Method method = clazz.getMethod("test", String.class);   //获取我们定义的test(String str)方法
    method.invoke(obj, "哥们这瓜多少钱一斤？");
}catch (Exception e){
    e.printStackTrace();
}
```

我们来试试看修改成员字段之后，再来调用此方法：

```java
try {
    Object obj = clazz.newInstance();
    Field field = clazz.getField("text");   //获取成员变量 String text;
    field.set(obj, "华强");
    Method method = clazz.getMethod("test", String.class);   //获取我们定义的test(String str)方法
    method.invoke(obj, "哥们这瓜多少钱一斤？");
}catch (Exception e){
    e.printStackTrace();
}
```

通过这种方式，我们就可以实现外部加载甚至是网络加载一个类，只需要把类文件传递即可，这样就无需再将代码写在本地，而是动态进行传递，不仅可以一定程度上防止源代码被反编译（只是一定程度上，想破解你代码有的是方法），而且在更多情况下，我们还可以对byte[]进行加密，保证在传输过程中的安全性。

# 注解

其实我们在之前就接触到注解了，比如`@Override`表示重写父类方法（当然不加效果也是一样的，此注解在编译时会被自动丢弃）注解本质上也是一个类，只不过它的用法比较特殊。

注解可以被标注在任意地方，包括方法上、类名上、参数上、成员属性上、注解定义上等，就像注释一样，它相当于我们对某样东西的一个标记。而与注释不同的是，注解可以通过反射在运行时获取，注解也可以选择是否保留到运行时。

## 预设注解

JDK预设了以下注解，作用于代码：

- @Override - 检查（仅仅是检查，不保留到运行时）该方法是否是重写方法。如果发现其父类，或者是引用的接口中并没有该方法时，会报编译错误。
- @Deprecated - 标记过时方法。如果使用该方法，会报编译警告。
- @SuppressWarnings - 指示编译器去忽略注解中声明的警告（仅仅编译器阶段，不保留到运行时）
- @FunctionalInterface - Java 8 开始支持，标识一个匿名函数或函数式接口。
- @SafeVarargs - Java 7 开始支持，忽略任何使用参数为泛型变量的方法或构造函数调用产生的警告。

## 元注解

元注解是作用于注解上的注解，用于我们编写自定义的注解：

- @Retention - 标识这个注解怎么保存，是只在代码中，还是编入class文件中，或者是在运行时可以通过反射访问。
- @Documented - 标记这些注解是否包含在用户文档中。
- @Target - 标记这个注解应该是哪种 Java 成员。
- @Inherited - 标记这个注解是继承于哪个注解类(默认 注解并没有继承于任何子类)
- @Repeatable - Java 8 开始支持，标识某注解可以在同一个声明上使用多次。

### @Retention注解详解

Retention注解有一个属性value，是RetentionPolicy类型的，RetentionPolicy是一个枚举类型，RetentionPolicy有3个值：CLASS RUNTIME  SOURCE
按生命周期来划分可分为3类：

- 1、RetentionPolicy.SOURCE：注解只保留在源文件，当Java文件编译成class文件的时候，注解被遗弃，`Java源文件(.java文件)`
- 2、RetentionPolicy.CLASS：注解被保留到class文件，但jvm加载class文件时候被遗弃，这是默认的生命周期，`.class文件`
- 3、RetentionPolicy.RUNTIME：注解不仅被保存到class文件中，jvm加载class文件之后，仍然存在，`内存中的字节码`


 那怎么来选择合适的注解生命周期呢？
 首先要明确生命周期长度 SOURCE < CLASS < RUNTIME ，所以前者能作用的地方后者一定也能作用。

- 一般如果需要在运行时去动态获取注解信息，那只能用 RUNTIME 注解，比如@Deprecated使用RUNTIME注解
- 如果要在编译时进行一些预处理操作，比如生成一些辅助代码（如 ButterKnife），就用 CLASS注解
- 如果只是做一些检查性的操作，比如 @Override 和 @SuppressWarnings，使用SOURCE 注解。

看了这么多预设的注解，你们肯定眼花缭乱了，那我们来看看`@Override`是如何定义的：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
```

该注解由`@Target`限定为只能作用于方法上，ElementType是一个枚举类型，用于表示此枚举的作用域，一个注解可以有很多个作用域。`@Retention`表示此注解的保留策略，包括三种策略，在上述中有写到，而这里定义为只在代码中。一般情况下，自定义的注解需要定义1个`@Retention`和1-n个`@Target`。

既然了解了元注解的使用和注解的定义方式，我们就来尝试定义一个自己的注解：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
}
```

这里我们定义一个Test注解，并将其保留到运行时，同时此注解可以作用于方法或是类上：

```java
@Test
public class Main {
    @Test
    public static void main(String[] args) {
        
    }
}
```

这样，一个最简单的注解就被我们创建了。

## 注解的使用

我们还可以在注解中定义一些属性，注解的属性也叫做成员变量，注解只有成员变量，没有方法。`注解的成员变量在注解的定义中以“无形参的方法”形式来声明`，其方法名定义了该成员变量的名字，其返回值定义了该成员变量的类型：

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
    String value();	// String是类型，不要当成方法当String为返回值，value()就是成员变量，不是方法
}
```

默认只有一个属性时，我们可以将其名字设定为value，否则，我们需要在使用时手动指定注解的属性名称，使用value则无需填入：

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
    String test();
}
```

```java
public class Main {
    @Test(test = "")	// 成员变量不是value，需要指定成员变量=""这样来赋值
    public static void main(String[] args) {

    }
}
```

我们也可以使用default关键字来为这些属性指定默认值：

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
    String value() default "都看到这里了，给个三连吧！";
}
```

当属性存在默认值时，使用注解的时候可以不用传入属性值。当属性为数组时呢？

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface Test {
    String[] value();
}
```

当属性为数组，我们在使用注解传参时，如果数组里面只有一个内容，我们可以直接传入一个值，而不是创建一个数组：

```java
@Test("关注点了吗")
public static void main(String[] args) {
	
}
```

```java
public class Main {
    @Test({"value1", "value2"})   //多个值时就使用花括号括起来
    public static void main(String[] args) {

    }
}
```

## 反射获取注解

既然我们的注解可以保留到运行时，那么我们来看看，如何获取我们编写的注解，我们需要用到反射机制：

```java
public static void main(String[] args) {
    Class<Student> clazz = Student.class;
    for (Annotation annotation : clazz.getAnnotations()) {
        System.out.println(annotation.annotationType());   //获取类型
        System.out.println(annotation instanceof Test);   //直接判断是否为Test
        Test test = (Test) annotation;
        System.out.println(test.value());   //获取我们在注解中写入的内容
    }
}
```

通过反射机制，我们可以快速获取到我们标记的注解，同时还能获取到注解中填入的值，那么我们来看看，方法上的标记是不是也可以通过这种方式获取注解：

```java
public static void main(String[] args) throws NoSuchMethodException {
    Class<Student> clazz = Student.class;
    for (Annotation annotation : clazz.getMethod("test").getAnnotations()) {
        System.out.println(annotation.annotationType());   //获取类型
        System.out.println(annotation instanceof Test);   //直接判断是否为Test
        Test test = (Test) annotation;
        System.out.println(test.value());   //获取我们在注解中写入的内容
    }
}
```

无论是方法、类、还是字段，都可以使用`getAnnotations()`方法（还有几个同名的）来快速获取我们标记的注解。

所以说呢，这玩意学来有啥用？丝毫get不到这玩意的用处。其实不是，现阶段你们还体会不到注解带来的快乐，在接触到Spring和SpringBoot等大型框架后，就能感受到注解带来的魅力了。

