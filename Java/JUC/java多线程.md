---
创建时间: 2023-03-14T18:15
更新时间: 2023-11-23T11:47
---
# Java多线程

## 线程状态的5种状态

![线程状态转换](7e76cc17-0ad5-3ff3-954e-1f83463519d1.jpg)

1. 新建(NEW)：新创建了一个线程对象
2. 可运行(RUNNABLE)：创建后调用start()，存放在可运行线程池中，等待CPU调度运行
3. 运行(RUNNING)：可运行状态(runnable)的线程获得了cpu 时间片 ，执行程序代码
4. 阻塞(BLOCKED)：阻塞状态是指线程因为某种原因放弃了cpu 使用权，也即让出了cpu时间片，暂时停止运行。直到线程进入可运行(runnable)状态，才有机会再次获得cpu时间片转到运行(running)状态。阻塞的情况分三种： 
   1. 等待阻塞：运行(running)的线程执行o.wait()方法，JVM会把该线程放入等待队列中。
   2. 同步阻塞：运行(running)的线程在获取对象的同步锁时，若该同步锁被别的线程占用，则JVM会把该线程放入锁池中。
   3. 其他阻塞：运行(running)的线程执行Thread.sleep或t.join()方法，或者发出了I/O请求时，JVM会把该线程置为阻塞状态。当sleep()状态超时、join()等待线程终止或者超时、或者I/O处理完毕时，线程重新转入可运行(runnable)状态。

5. 死亡(DEAD)：线程run()、main() 方法执行结束，或者因异常退出了run()方法，则该线程结束生命周期。死亡的线程不可再次复生。

> 总结：
>
> 首先新建状态，调用start之后可运行状态，获得CPU进入运行状态，线程run方法体或者异常则线程进入死亡状态
>
> 阻塞状态则是分为三种：要注意运行状态的线程才可以进入阻塞状态，还没有运行根本不知道会阻塞
>
> 1. 第一种是自己调用wait，进入等待线程池
>
> 2. 第二种是同步锁被其它线程占用，进入锁池
>
> 3. 第三种是执行sleep、join方法或调用了IO请求，会在sleep结束或者IO处理完毕进入可运行状态

### 线程的优先级

根据重要程度不同，处理时间不同设置线程设置了优先级，但只是优先级更高，并不代表一定先执行

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

## 线程锁和线程同步

每个线程有自己的工作内存，但是处理共享变量不能保证原子性，所以主内存里面有一份副本，而处理的方法就是加锁进行线程同步

### 线程锁

`synchronized`给类或者对象加锁，针对对象一定要注意是同一个对象

添加锁的位置一般是加在方法上，表示这个方法是同步方法，或者直接synchronized(对象或者类.class)

**注意没有添加锁的方法，不受影响**，如果全是同步方法，成为同步对象

**如果是静态方法，就是使用的类锁，而如果是普通成员方法，就是使用的对象锁**

### 死锁

o1锁里面的内容想去锁o2，而o2一开始就被线程2锁住了，所以o1锁无法执行完成，也就无法释放，o2也一样，都无法释放，那么两个锁都无法执行完成，形成死锁,**互相锁住对方**

```java
public class Test {
    public static void main(String[] args) throws InterruptedException {
        Test test1 = new Test();
        Test test2 = new Test();
        new Thread(()->{
            // 首先给test1锁定
            synchronized (test1) {
                try {
                    Thread.sleep(1000);
                    // 想去锁定test2，但是test2已经被下面的另一个线程锁定，并且没有释放
                    // 那么这个线程1一直在尝试锁定test2，也无法完成内容执行，也会一直没有释放
                    synchronized (test2) {
                        System.out.println("线程1");
                    }
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();
        new Thread(()->{
            // 和上面的线程刚好相反，一直没有释放，形成死锁
            synchronized (test2) {
                try {
                    Thread.sleep(1000);
                    synchronized (test1) {
                        System.out.println("线程2");
                    }
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }
}
```

可以利用`jstack`命令来检测死锁，首先利用jps找到我们的java进程

**不推荐使用 suspend() 去挂起线程**

suspend挂起线程但是不释放锁，需要执行resume方法来解除阻塞

如果resume方法在suspend之前就被执行过了，没有其它地方继续调用resume了，那么就会永久锁住，形成死锁，所有最好就根本别用suspend方法

### wait和notify方法

- `wait()`：线程进入等待池中，不会唤醒等待池中对象

- `notify()`：随机唤醒一个等待池中线程，进入锁池

- `notifyAll()`：唤醒所有线程，进入锁池，竞争获取锁对象，优先级高的更容易，当然只有一个会得到锁对象

### lock同步对象

synchronized自动释放锁，是一个关键字

lock需要手动调用`unlock`才能释放锁，是一个接口，常用`ReentrantLock`实现类来同步

```java
public class Test {
    public static void main(String[] args) throws InterruptedException {
        Cat cat = new Cat();
        // 创建线程并给线程添加名字
        new Thread(cat, "小猫").start();
        new Thread(cat, "小狗").start();
    }
}
class Cat implements Runnable {
    // 在需要创建Lock锁的对象中创建lock成员属性，才可以使用lock锁
    private Lock lock = new ReentrantLock();

    @Override
    public void run() {
        try {
            // 将当前对象锁住，注意lock不能在这里声明，必须是成员属性
            lock.lock();
            for (int i = 0; i < 10; i++) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName());
            }
        } finally {
            lock.unlock();
        }
    }
}
```

同时lock还提供了一个trylock方法，在指定时间范围内`试图占用`，占用不到就拉倒

>  只要这个对象被其它线程占用，没有释放，那么就占用不到

```java
locked = lock.tryLock(1,TimeUnit.SECONDS);	// 1秒，可以不传参
```

# ThreadLocal

创建保存线程工作内存，线程之间独立，只能保存一个变量，因为线程默认是要同步到主内存的

如果使用框架最好使用框架的ThreadLocal支持，比如Spring的RequestContextHolder，避免忘记remove内存泄露

## ThreadLocal两大应用场景

### 每个线程需要一个独享的对象

通常是工具类，典型的有`SimpleDateFormat`和`Random`类，也就是每个线程需要一个**独享**的工具类

如果多个线程同时使用一个工具类，会导致线程不安全，这个工具类返回的值很可能出错，简单来讲就是这个线程让工具类处理我这个线程的数据还没处理完另外一个线程又传入一个数据来处理，处理的可能是之前的线程数据然后返回给我。

可以使用加锁的方式来解决线程安全问题，但是加锁会导致效率降低，因为加锁实际上在工具类的调用上效果和单线程效率一样。

下面以`SimpleDateFormat`工具类来示例：

首先当我们有两个线程需要使用这个工具类来返回具体的时间字符串时：

```java
public class ThreadLocal01 {
    public static void main(String[] args) {
        new Thread(()->{
            System.out.println(new ThreadLocal01().date(10));
        }).start();
        new Thread(()->{
            System.out.println(new ThreadLocal01().date(20));
        }).start();
    }
    public String date (int seconds) {
        Date date = new Date(1000 * seconds);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        return dateFormat.format(date);
    }
}
```

上面的代码仅仅是两个线程，问题不大，那么现在我们有30个线程需要使用SimpleDateFormat类呢，还是直接创建30个线程明显是不可取的，这时候需要使用到**线程池**了：

```java
public class ThreadLocal01 {
    // 创建10个线程的固定线程池
    public static ExecutorService threadPool = Executors.newFixedThreadPool(10);
    public static void main(String[] args) {
        for (int i = 0; i < 30; i++) {
            int finalI = i;
            threadPool.submit(()->{
                System.out.println(new ThreadLocal01().date(finalI));
            });
        }
        threadPool.shutdown();
    }
}
```

这时候新的问题又出现了，我们30个线程，创建了30次`SimpleDateFormat`对象，创建30个对象是极大的资源浪费，既然这个对象只是传值给它然后返回具体的时间字符串，做的工作都是一样的，为何不只创建一次，然后传不同的值呢：

```java
public class ThreadLocal01 {
    // 创建10个线程的固定线程池
    public static ExecutorService threadPool = Executors.newFixedThreadPool(10);
    public static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
    public static void main(String[] args) throws InterruptedException {
        for (int i = 0; i < 30; i++) {
            int finalI = i;
            threadPool.submit(()->{
                System.out.println(new ThreadLocal01().date(finalI));
            });
        }
        threadPool.shutdown();
    }
}
```

上面使用了一个static对象来保证只创建一次，但是新的问题出现了，会发现输出时间时，有一些重复的，这是因为线程不安全，执行出错了，下面要进行下一步更改：

要解决这个问题也非常简单，无非就是加一把锁就行了：

```java
public String date (int seconds) {
    Date date = new Date(1000 * seconds);
    // 将dateFormat对象锁住，同一时间只允许一个对象使用
    // 当然dateFormat是ThreadLocal01的成员，锁住ThreadLocal01和锁住dateFormat是一样的
    synchronized (ThreadLocal01.class) {
       return dateFormat.format(date);
    }
}
```

但是这样会导致执行效率大大降低，看来这种场景最好的方案还是使用ThreadLocal：

```java
public class ThreadLocal01 {
    // 创建10个线程的固定线程池
    public static ExecutorService threadPool = Executors.newFixedThreadPool(10);
    public static void main(String[] args) throws InterruptedException {
        for (int i = 0; i < 1000; i++) {
            int finalI = i;
            threadPool.submit(()->{
                System.out.println(new ThreadLocal01().date(finalI));
            });
        }
        threadPool.shutdown();
    }
    public String date (int seconds) {
        Date date = new Date(1000 * seconds);
        return ThreadSafeFormatter.dateFormatThreadlocal.get().format(date);

    }
}
class ThreadSafeFormatter {
    // 每个线程创建一个独立的SimpleDateFormat，但是因为线程池只有10个线程
    // 那么只会创建10个SimpleDateFormat
    public static ThreadLocal<SimpleDateFormat> dateFormatThreadlocal =
           ThreadLocal.withInitial(()->{
               return new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
           });
}
```

### 每个线程内需要保存全局对象

多个对象传递全局对象不方便，用于保存全局变量

每个线程都有自己的全局对象，然后在多个service类中反复调用这个全局对象，如果使用传递的方式的话，那么调用每个service类的方式时，都要传递这个参数(函数式编程)，十分不方便，这种时候可以使用ThreadLocal的线程内全局对象，每个service类中的方法想使用的时候，直接调用这个即可。

```java
public class ThreadLocal02 {
    public static void main(String[] args) {
        new Service1().process();
    }
}
// 这里创建了3个业务类，每个类中的process方法都要使用user信息
// 当我们在第一个类中设置user信息到ThreadLocal中，后面就可以直接用
class Service1 {
    public void process() {
        User user = new User("超哥");
        UserContextHolder.holder.set(user);
        // 这里就不需要传入这个user参数了，也可以传递user参数，通过ThreadLocal
        new Service2().process();
    }
}
class Service2 {
    public void process() {
        User user = UserContextHolder.holder.get();
        System.out.println(user.name);
        // 这里就不需要传入这个user参数了，也可以传递user参数，通过ThreadLocal
        new Service3().process();
    }
}
class Service3 {
    public void process() {
        User user = UserContextHolder.holder.get();
        System.out.println(user.name);
    }
}
class UserContextHolder {
    public static ThreadLocal<User> holder = new ThreadLocal<>();
}
class User {
    String name;
    User(String name) {
        this.name = name;
    }
}
```

可以发现使用了ThreadLocal之后，会将user信息保存在Thread线程中，只要在当前线程中，都可以使用这个共享变量，而且线程之间是隔离的，不会出现线程安全问题。

## ThreadLocal带来的好处

- 达到线程安全
- 不需要加锁，提高执行效率
- 更高效的利用内存、节省开销，不需要大量创建对象
- 利用了ThreadLocal线程内全局变量共享的原理，免去了反复传参的繁琐，同时使得代码耦合度更低

## ThreadLocal原理

实际上`ThreadLocal`是保存在`ThreadLocalMap`这个Map中的，然后ThreadLocalMap保存在Thread中，所以这些东西都是线程的成员，每个Thread都持有一个ThreadLocalMap成员变量。

## ThreadLocal常用变量

### initialValue

设置ThreadLocal当前线程的初始值，只是一个**延迟加载**的方法，只有在调用`get`的时候，才会触发

当线程第一次使用get方法访问变量时，将调用此方法，只有线程先前调用了`set`方法，不会为线程调用initialValue方法，也就是没有设置值就会调用设置初始值方法，如果没有设置初始值，则返回null

通常每个方法最多只可以调用一次设置初始值，除非调用`remove`方法，则可以再次调用

### set

为这个线程设置一个新值

### get

得到这个线程对应的value，要注意get不需要参数，因为一个ThreadLocal只可以保存一个值，所以不需要传参

### remove

删除这个线程对应的值

## ThreadLocal的继承InheritableThreadLocal

我们发现在线程中创建的子线程，无法获得父线程工作内存中的变量：

```java
public static void main(String[] args) {
    ThreadLocal<String> local = new ThreadLocal<>();
    Thread t = new Thread(() -> {
       local.set("lbwnb");
        new Thread(() -> {
            System.out.println(local.get());	// null
        }).start();
    });
    t.start();
}
```

使用`InheritableThreadLocal`可以让子线程获取到父线程的变量值：

```java
public static void main(String[] args) {
    ThreadLocal<String> local = new InheritableThreadLocal<>();
    Thread t = new Thread(() -> {
       local.set("lbwnb");
        new Thread(() -> {
            System.out.println(local.get());	// lbwnb
        }).start();
    });
    t.start();
}
```

在InheritableThreadLocal存放的内容，会自动向子线程传递。

## ThreadLocal注意点

### 内存泄露

某个对象不再有用，但是占用的内存却不能被回收，也就是不能使用这个内存，这就导致了这个内存用不了了，当出现很多这样的内存，最终可能就会导致OOM内存泄露。

引发内存泄露的原因：

ThreadLocal的变量是保存在`Thread->ThreadLocalMap->key(entry)->value`中，也就是要使用value必须找到key(entry，这个key就是ThreadLocal对象名)，但是java中，这个key是弱引用，如果在线程池中一段时间不使用，会被GC垃圾回收掉，但是value是强引用，不会被回收，这样会导致key没了只剩下value，也就找不到这个value了，这个value就泄露了

其实java在设计时已经考虑到这个问题，但我们调用set、remove、rehash等方法的时候，会自动扫描key为null的Entry，如果有就会把对应的value也设置为null，这样value可以会回收

但是实际使用过程中可能我们一段时间不用线程池，也就不会去调用这些方法，那么也会内存泄露。

所以根据阿里规约，我们在使用完ThreadLocal变量之后一定要调用`remove()`方法

### 空指针异常

就是get的时候要注意，返回值Long和long的区别，如果返回long的话，当值为null，返回会报空指针异常，因为null，无法返回为long，只能装箱成为Long包装类型

### 共享对象

如果在每个线程中ThreadLocal.set()进去的东西本来就是多个线程共享的同一对象，比如static对象，那么多个线程调用ThreadLocal.get()获取的内容还是同一个对象，还是会发生线程安全问题。

# java定时器

## 自定义定时器

使用`Thread.sleep()`来实现定时几秒后执行任务：

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

现在来设计一个计时器，每隔多久执行一次：

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

## java定时任务

Java为我们提供了一套自己的框架用于处理定时任务：

```java
public static void main(String[] args) {
    Timer timer = new Timer(); //创建定时器对象
    timer.schedule(new TimerTask() { //抽象类，不是接口，无法使用lambda表达式
        @Override
        // 注意会自动去调用Task里面的run方法
        public void run() {
            System.out.println(Thread.currentThread().getName());
        }
    }, 1000);    //执行一个延时任务
}
```

同时可以执行循环定时任务：

```java
public class TimerTest {
    public static void main(String[] args) {
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName());
            }
        },1000,1000);	// 1秒钟后第一次执行，然后每秒钟执行一次
    }
}
```

我们发现，虽然任务执行完成了，但是我们的程序并没有停止，这是因为Timer内存维护了一个任务队列和一个工作线程：

```java
public class Timer {
    private final TaskQueue queue = new TaskQueue();
    private final TimerThread thread = new TimerThread(queue);
}
```

TimerThread继承自Thread，是一个新创建的线程，在构造时调用构造函数自动启动：

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

# 线程池

当需要创建大量的线程进行业务时，重复的创建销毁会浪费大量的开销，所以需要创建一个线程池，然后业务来时直接使用线程池中已经创建好的线程，重复使用，不创建和关闭线程，来提高效率。

## 线程池工作原理白话版介绍

### 线程池

**「小田螺」** 勤勤恳恳，任劳任怨，夜以继日地工作着。终于有一天，他晋升为公司的主管，负责公司日常业务。

风轻云淡的一天，老板找到了小田螺，“我们公司员工越来越多了，我想搞个**「员工管理系统」**，你那边安排一下哈，要在一个月后完成。” 小田螺拍拍胸口，没问题！

因为当前公司还没有程序员，所以小田螺快马加鞭打开**「猪八戒网」**，提交员工管理系统需求，等待不久，**「开发者（名字，线程A）」** 接单，谈好合同，开始开发，系统交付...一系列流程下来，并且一个月过后，一个五脏俱全的员工管理系统终于完成了...老板对此大加赞赏~

过了不久，老板再次发话，“公司越来越多人迟到了，我们再搞个**「考勤系统」**吧!" 小田螺接到任务，马上又开始上猪八戒网，提需求找人开发，这次来了**「线程B接单」**......

逝者如斯，月底了，老板又提出开发个薪酬系统需求...小田螺听了头皮发麻，one day day的，重复去网上找人开发！“为了节省成本，不如我们雇佣几个程序员(线程a,b,c)，成立自己的IT技术部门吧！我们就管IT部门叫**「线程池」**吧!”老板听了，一拍即合!!!

> 线程池就是管理线程的池子，当有任务要处理时，不用频繁创建新线程，而是从池子拿个线程出来处理。当任务执行完，线程并不会被销毁，而是在等待下一个任务。因此可以节省资源，提高响应速度。

### 核心线程

**「线程池」**IT部门成立后，雇佣了几个与公司有正式合同关系的员工a，b，c，**「小田螺」**管他们几个正式员工做**「核心线程」**。当老板提一个需求过来，小田螺就把需求分配给**「手上没活干」**的线程处理...

### 阻塞队列

一天早上，老板睡眼惺忪。来到公司后，一口气提了**「四个需求」**，a，b,c 按顺领完任务后，发现还剩余一个需求任务。这个怎么安排呢？难道又去**「猪八戒兼职网」**找人嘛？成立了**「线程池IT部门」**，还去找人（找线程干活），会被人笑落大牙的！

聪明的小田螺想到一个好办法，我们可以搞个DPMS需求池，把还没分配的需求，放进待完成的DPMS需求池里面吧，等到a，b，c谁先干完活，再把这个任务领走。这个DPMS需求池，我们给它取名**「阻塞队列」**，英文名叫**「WorkQueue」**吧！

### 非核心线程

又在一个晴空万里的午后，老板喝了一杯咖啡，闲来没事，就跑去**「阻塞队列」**（DPMS需求池）看看，一看就傻帽了！！需求池堆积了几十个需求，排期都是满满的了。老板马上叫**「小田螺进来办公室」**，以商量如何处理这些需求任务。

“要不，我们雇佣多几个员工（搞多几个**「核心线程」**）？” “不行不行，公司财务**「开销」**有点大！”

“要不然，我们要求业务提少点任务需求？（**「请求少点」**）” “你是不是傻，请求少点，不是自断财路嘛？你回家想想办法先吧！！”老板放大了他的嗓门~

小田螺回家闭目让神，每天早早就睡觉，两耳不闻窗外事...终于有一天，在一个梦香里，他想到了一个好办法。

“老板，我们可以去别的公司（**「外包公司」**）雇佣几个员工（假设名字为d,e,f,g）一段时间，让它们来做**「DPMS需求池（阻塞队列）」** 里面的需求。等到做完需求，再派他们回去就好啦。” 老板一听就乐了，这个方案好，心里美滋滋：**「需求的活有人干了，公司财务又省钱，两全其美呀」**~ 这几个派遣来的外包员工（d,e,f,g），我们就把它叫做**「非核心线程」**吧。

### 空闲时间

自从来了d,e,f,g外包员工（**「非核心线程」**），老板长舒一口气，这么多活，终于有人干了。

但是呢，又有一天，到了7点所谓的下班时间，老板走出办公室，发现**「线程池」**IT部门的员工，都走得七七八八了。心里一怒：**「这帮粉肠，怎么一到下班时间就跑，工作这么不饱和了」**？他随手点进DPMS需求池，才发现，原来需求都被做完了。。。还有一堆外包同事（非核心线程）要发工资呢，这波亏大了~

第二天，小田螺被**「秘密」**叫进了老板办公室，既然DPMS需求池都已经没需求了。我们准备派外包同事（非核心线程）回去吧？但是呢一般，需求一没有，就马上让他们回去（**「线程回收」**），如果需求一下子又来，就有点hold不住了...

“要不酱紫，我们等需求池空的时候，隔个15天还是10天，再让外包同事（**「非核心线程」**）回去吧？” 这个定义的15天或者10天，就是**「线程空闲存活时间」**啦

### 饱和策略

在临近双11的时候，不仅老板提了良多需求，新来的运营小姐姐们，也提了好多好多的需求。新需求如源头活水，滚滚的来~

首先呢，**「线程池」**IT部门a，b，c三个正式员工（核心线程）都忙于处理需求（**「请求」**），接着，DPMS需求池（**「阻塞队列」**）也被挤满了，最后呢，连d,e,f,g外包同事（**「非核心线程」**）也忙得不可开交。

这时候，需求还是做不完，怎么办呢？双11赶着上线呢？小田螺愁眉苦脸，从**「潮起愁到潮落」**...

没办法了，只能动用**「饱和策略」**啦。比如**「丢弃需求任务」**？**「抛异常，告诉老板别加需求了」**？**「丢弃需求池最老的需求任务」**？还是**「交给提需求的人自己处理」**？

最后老板决定，**「拒绝再提新的需求」**，于是**「线程池」**IT部门还是正常运行~

> 线城池的饱和策略事件，主要有四种类型

- AbortPolicy(抛出一个异常，默认的)
- DiscardPolicy(新提交的任务直接被抛弃)
- DiscardOldestPolicy（丢弃队列里最老的任务，将当前这个任务继续提交给线程池）
- CallerRunsPolicy（交给线程池调用所在的线程进行处理，即将某些任务回退到调用者)

### 线程池工作原理流程图 & 源码概览

```java
  if (command == null)
            throw new NullPointerException();
        int c = ctl.get();
        //判断当前活跃线程数是否小于corePoolSize
        if (workerCountOf(c) < corePoolSize) {
            //如果小于，则调用addWorker创建线程执行任务
            if (addWorker(command, true))
                return;
            c = ctl.get();
        }
        //如果大于等于corePoolSize，则将任务添加到workQueue队列。
        if (isRunning(c) && workQueue.offer(command)) {
            int recheck = ctl.get();
            if (! isRunning(recheck) && remove(command))
                reject(command);
            else if (workerCountOf(recheck) == 0)
                addWorker(null, false);
        }
        //如果放入workQueue队列失败，则创建非核心线程执行任务    
        else if (!addWorker(command, false))
            //（如果这时创建线程失败(当前线程数大于等于maximumPoolSize时))
            调用reject拒绝接受任务
            reject(command);
```

## 线程池工作原理

### 线程池

一个拥有一定数量已经创建好的线程的池子，有任务需要使用线程时，直接从这个池子里取出，不需要反复创建销毁，一直存在，减少内存消耗。

同时线程池能够加快响应速度，合理利用cpu和内存资源，而且方便线程的统一管理。

### 线程池适合场景

- 服务器接受大量请求时，可以大大减少线程的创建和销毁次数，提高服务器工作效率
- 如果需要创建5个以上的线程，推荐使用线程池管理

### 线程池构造方法的参数

| 参数名        | 类型                     | 含义                             |
| ------------- | ------------------------ | -------------------------------- |
| corePoolSize  | int                      | 核心线程数                       |
| maxPoolSize   | int                      | 最大线程数                       |
| keepAliveTime | long                     | 保持存活时间                     |
| workQueue     | BlockingQueue            | 任务存储队列                     |
| threadFactory | ThreadFactory            | 创建线程的工厂                   |
| Handle        | RejectedExecutionHandler | 无法接收提交的新任务时的拒绝策略 |

- `corePoolSize`：是指核心常备的线程数，这个线程数量不是一开始就创建好这么多，而是使用的时候需要才一个个创建，直到达到这个数量，不再创建
- `maxPoolSize`：最大的线程数，在核心线程数的基础上，最大能够创建的线程数，线程池的线程数量不能超过这个数值
- `keepAliveTime`：超过核心线程数之后的线程的存活时间，注意核心线程数是一直存在的
- `workQueue`：任务队列，当线程超过核心线程池数量之后，开始放入这个任务队列中，等待执行
- `threadFactory`：默认使用Executors.defaultThreadFactory()，默认创建出来的线程都是在同一个线程组中，如果自己指定，则可以改变线程名、线程组、优先级、是否守护线程
- `Handle`：比如超过最大线程数时如何处理的策略

### 添加线程规则

当来了一个新任务，添加线程的规则如下：

1. 如果线程数小于corePoolSize，即使其他工作线程处于空闲状态，也会创建一个新线程来运行新任务。

2. 如果线程数等于（或大于）corePoolSize但少于maxPoolSize，则将任务放入队列。

3. 如果队列已满，并且线程数小于maxPoolSize，则创建一个新线程来运行任务。

4. 如果队列已满，并且线程数大于或等于maxPoolSize，则拒绝该任务。

### 饱和策略(拒绝策略)

- AbortPolicy(抛出一个异常，默认的)
- DiscardPolicy(新提交的任务直接被抛弃)
- DiscardOldestPolicy（丢弃队列里最老的任务，将当前这个任务继续提交给线程池）
- CallerRunsPolicy（交给线程池调用所在的线程进行处理，即将某些任务回退到调用者)

### 工作队列workQueue

有三种最常用的队列类型：

- `SynchronousQueue`:直接交接，也就是这个队列不存任务，有任务直接要么创建新线程要么就拒绝
- `LinkedBlockingQueue`:无界队列，无上限，一直可以存入任务
- `ArrayBlockingQueue`：有界队列

## java自带常见线程池

### newFixedThreadPool

使用`LinkedBlockingQueue`无界队列，超过核心线程池直接放入队列中，不会再创建新线程，容易造成大量内存占用，可能会导致OOM(内存耗尽)

```java
public class PoolTest {
    public static void main(String[] args) {
      	// 创建4个核心线程
        ExecutorService executorService = Executors.newFixedThreadPool(4);
        for (int i = 0; i < 100; i++) {
            executorService.execute(new Task());
        }
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
    }
}
```

### newSingleThreadExecutor

使用`LinkedBlockingQueue`无界队列，永远都只有一个线程，单线程，全部加入队列中，当请求堆积的时候，可能会占用大量的内存

```java
public class PoolTest {
    public static void main(String[] args) {
        ExecutorService executorService = Executors.newSingleThreadExecutor();
        for (int i = 0; i < 100; i++) {
            executorService.execute(new Task());
        }
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
    }
}
```

### newCachedThreadPool

可缓存线程池，可以自动回收多余线程

使用`SynchronousQueue`直接交接队列，不需要队列来存储任务，不需要队列中转，maxPoolSize为Integer.MAX_VALUE，会创建非常多的线程，同样可能导致OOM

```java
public class PoolTest {
    public static void main(String[] args) {
        ExecutorService executorService = Executors.newCachedThreadPool();
        for (int i = 0; i < 1000; i++) {
            executorService.execute(new Task());
        }
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
    }
}
```

### ScheduledThreadPool

使用`DelayedWorkQueue`延迟队列，延迟一定时间才开始将任务加入线程池，支持定时及周期性任务执行的线程池

```java
public class PoolTest {
    public static void main(String[] args) {
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);
        // 延迟5秒执行
        scheduledExecutorService.schedule(new Task(),5, TimeUnit.SECONDS);
        // 第一次1秒执行，然后每隔3秒执行一次
        scheduledExecutorService.scheduleAtFixedRate(new Task(),1,3,TimeUnit.SECONDS);
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
    }
```

### workStealingPool

当任务产生子任务时，使用这种线程池比较合适，比如树的相关问题，左右两边又要分左右，也就是有子任务，这种使用`workStealingPool`是比较合适的，暂时不研究

### 创建线程池

线程池最好是自己手动创建，明确线程池类型，工作队列类型，核心线程数，最大线程数等配置，创建最符合当前业务要求的线程池。

线程数量创建规则：

- CPU密集型(加密、计算hash等)：最佳线程数为CPU核心数的1-2倍左右
- 耗时IO型(读写数据库、文件、网络读写等)：最佳线程数一般会大于CPU核心数很多倍，因为主要用到的是磁盘或者网络来处理

上面的规则适合一般的线程池业务，最严谨的是做压力测试测出来，也可以按照下面的公式简单计算。

> 线程数 = CPU核心数 * (1 + 平均等待时间 / 平均工作时间)

## 线程池常用方法

### shutdown

停止线程池，但是不是立即停止，而是将线程池中存在的任务和队列中存在任务执行完成之后再停止，同时不在接收新任务。

```java
public class PoolTest {
    public static void main(String[] args) throws InterruptedException {
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        for (int i = 0; i < 1000; i++) {
            executorService.execute(new Task());
        }
        // 两秒后停止线程池
        Thread.sleep(2000);
        executorService.shutdown();
        System.out.println("shutdown"); // 可以发现其实已经加入了非常多的任务到队列中
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
    }
}
```

使用`isShutdown`方法判断shutdown方法是否执行成功，不表示是否完成终止任务：

```java
System.out.println(executorService.isShutdown());
```

使用`executorService.isTerminated()`true表示线程池和队列中的任务都已经全部完成

`awaitTermination`，表示等待一段时间，如果这段时间内执行完了则返回true，线程池和队列没执行完返回false

```java
System.out.println(executorService.awaitTermination(1,TimeUnit.SECONDS));
```

使用`shutdownNow`立即终端线程池，会将线程池里面的线程全部中断，然后将队列里面的线程返回，可以将这些保存起来，比如保存到日志，后期继续使用。

```java
public class PoolTest {
    public static void main(String[] args) throws InterruptedException {
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        for (int i = 0; i < 1000; i++) {
            executorService.execute(new Task());
        }
        // 两秒后停止线程池
        Thread.sleep(2000);
        List<Runnable> runnables = executorService.shutdownNow();
    }
}

class Task implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(500);
            System.out.println(Thread.currentThread().getName());
        } catch (InterruptedException e) {
            System.out.println(Thread.currentThread().getName() + "被中断了");
        }
    }
}
```

## 任务拒绝策略

### 拒绝时机

- 当Executor被shutdown关闭之后，再提交任务会被拒绝
- 当达到最大线程且队列达到设计的workQueue容量时(比如`ArrayBlockingQueue`有界队列)

### 拒绝策略

- `AbortPolicy`：直接抛出异常
- `DiscardPolicy`：直接丢弃这个任务
- `DiscardOldestPolicy`：丢弃最老的任务
- `CallerRunsPolicy`：调用者运行此任务，谁(哪个线程)提交的这个任务，谁来执行这个任务，这样做不会有业务损失，比如主线程提交的任务，当使用此策略之后，主线程用来执行这个任务了，也就不能继续提交其它任务了

## 钩子方法

后面再研究

## 线程池的状态

| 状态       | 含义                                                         |
| ---------- | ------------------------------------------------------------ |
| RUNNING    | 接受新任务并处理排队任务                                     |
| SHUTDOWN   | 不接收新任务，但处理排队任务 `shutdown`                      |
| STOP       | 不接收新任务，不处理排队任务，中断正在进行的任务 `shutdownnow` |
| TIDYING    | 所有任务已经终止，workerCount为零时，线程会转换为此状态，会运行钩子方法 |
| TERMINATED | 运行完成 `isTerminated=true`所有任务都已经完成               |



## 自定义一个线程池

### 设计原理

准备一个任务容器

一次性启动10个消费者线程

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

## java自带线程池

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

 