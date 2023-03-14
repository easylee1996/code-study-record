## 基本使用

`Object.defineProperty`用于给一个对象定义属性以及这个属性的一些特性。

使用格式如下：

```javascript
let person = {};

// 基本描述属性
Object.defineProperty(person,'name',{
    configurable: true, // 是否可以删除这个属性或者修改这个属性
    enumerable: true,   // 是否可以枚举到这个属性
    value: 'hello', // 属性默认值，可以修改
    writable: true, // 是否可重写
})
```

同时还拥有两个触发的函数，分别是`get()`和`set()`：

```javascript
Object.defineProperty(person,'name',{
    get() {
        console.log('获取到值')
    },
    set(val) {
        console.log('设置了值')
    }
})
```

> 1. get和set和value以及writable不可以是互斥的，因为已经使用了get和set，那么value和writable肯定是需要有的。
> 2. get无法获取到对象属性的值，要获取还是使用obj.name就可以，不要在get里面获取obj.name，那样会造成死循环获取name值，因为每次调用obj.name都会触发get
> 3. set当设置obj.name=new value时，会触发，vue2就是根据此原理在此时更新模板

## 缺陷

`vue3`弃用这种方式来劫持数据的原因在于，只有当属性值变化或者获取属性值才可以监听劫持到，而**属性值新增或者属性值删除时无法监听**，vue2是添加了`$set`或`$delete`之类的钩子函数来进行监听这些行为的，`vue3`使用`proxy`进行监听劫持，就不需要这些api，减少学习和开发的成本。

