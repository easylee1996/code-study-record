---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
## 基础概念

### 输入和输出

输入流：从文件读取到内存

输出流：从内存输出到文件、数据库、远程主机

以内存为标准，进入内存是输入，走出内存是输出

### 什么是流

数据传输过程类似于水流，数据是通过一个字节一个字节(字符流一个字符一个字符)像水流一样进行传输的，因此称为 IO 流

### Java流分类

输入流：InputStream、Reader两个字节输入、字符输入流基类

输出流：OutputStream、Writer两个字节输出、字符输出流基类

所有流都基于这4个基类产生

### 为什么Java I/O 流操作要分为字节流操作和字符流操作呢？

首先无论文件读写还是网络传输，最小单位都是字节，但是英文好表示，1个字节搞定，但是中文、日文这些通常占用几个字节，如果还是使用字节流一个字节一个字节的读取，中文直接读取就会乱码(几个字节的一个中文拆分成了独立的几个字节读取，肯定乱码)，如果按照编码将几个字节拼接起来，这样效率又低，所以Java使用字符流读取字符，默认使用Unicode每次直接读取两个字节，不需要拼接

字符流用来读取文本，其它类型比如音频、图片等使用字节流

### 常用字符编码所占字节数？

- utf8 :英文占 1 字节，中文占 3 字节

- unicode：字符流默认，任何字符都占 2 个字节

- gbk：英文占 1 字节，中文占 2 字节

要注意只是字符流默认unicode，Java代码默认编码是utf8，如果没有使用流，那么代码使用的是utf8

## 文件流

要学习和使用IO，首先就要从最易于理解的读取文件开始说起。

### 文件路径说明

常见使用绝对路径，直接复制文件的绝对路径即可，或者使用相对路径，注意这个相对是从项目根目录出发的

### 文件字节输入流

首先介绍一下FileInputStream，通过它来获取文件的输入流。

获取文件

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

使用`read`可以直接读取一个字节的数据，注意，流的内容是有限的，读取一个少一个！

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

全部读取

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

### 文件字节输出流

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

追加内容

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

### 文件字符输入流

```java
public static void main(String[] args) {
    try(FileReader reader = new FileReader("test.txt")){
      	reader.skip(1);   //现在跳过的是一个字符，一个字符可能占用多个字节
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

### 文件字符输出流

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
public Writer append(char c) throws IOException {
    write(c);
    return this;
}
```

**append支持像StringBuilder那样的链式调用，返回的是Writer对象本身**

### File类

File表示一个文件或者文件夹，只是表示这个文件，不是文件本身，可以看做一个文件入口，如果要读取文件内容的话还是需要传入流中

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

## 缓冲流

将数据存在缓冲区，多次读取从缓存区读取，写入也是写入缓冲区，缓存区满或者调用flush清空缓存区或者是关闭连接时再写入文件，存入内存速度更快

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

![img](03%20code-study-record/Java/java语言基础/assets/IO/70.png)

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

