## 基本用法

监听一个属性的变化，基本用法如下：

```javascript
// 不需要属性，直接使用方法的形式使用即可，如下监听cameraPosition属性
cameraPosition(newVal, oldVal) {
  this.changeLine(newVal);
},
```

当需要去对监听的数据是否立即变化、是否深度监听做判断时，需要添加下面的属性：

```javascript
recordInfo: {
  handler(newVal, oldVal) {	// 监听到变化之后执行的函数体
    this.trainNumber = this.recordInfo.carriagesNumber.length;
    this.trainOneLength = 99 / this.trainNumber;
  },
  deep: true,	// 是否监听对象的属性值变化
  immediate: true,	// 是否立即执行watch
},
```

`immediate: true`表示第一次就执行handler里面的代码，否则只会在值发生变化的时候执行，也就是第一次原值获取到的时候不执行，变化才执行。

默认为false，像是异步监听的值，都是获取完数据之后才行，所以设置为false，改变的时候才执行。

## 高级用法

### flush:"post"

vue3更新队列分为了`pre`、`queue`、`post`三种，`render`渲染函数渲染页面是在`queue`队列中，而`watch`函数的`handler`回调默认是在`pre`队列中，也就是在渲染之前执行回调。

如果在`watch`的回调方法中，使用`dom`元素等信息，就是更新之前的，很可能不对，这时候就需要设置这个属性，来设置渲染之后执行回调函数。

### 执行多个方法

监听一个值之后，可以执行多个`handler`方法，是以一个数组的形式传入：

```javascript
watch {
  msg5: [
    "methodchain1",	// 调用methods的函数
    function methodchain2(oldVal,newVal) {	// 直接写入函数
      console.log("second method");
    },
    {	// 要设置其它属性的话，那么以对象的形式写就行了
      handler(newVal, oldVal) {
        console.log("third method")
      },
      deep:true
    }
  ]
},

methods: {
  methodchain1(newVal, oldVal) {
    console.log("first method");
  }
}
```

### 使用$watch

可以直接调用`this.$watch`来进行数据的监听，使用格式如下：

```javascript
created() {
  this.$watch('message', (newVal, oldVal) = {
    console.log(newVal, oldVal);
  }, {deep: true, imediate: true});	// 两个参数，一个回调函数，一个参数配置
}
```