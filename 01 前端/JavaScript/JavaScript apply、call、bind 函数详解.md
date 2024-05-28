## apply和call
apply和call非常类似，都是用于改变函数中this的指向，只是传入的参数不同，等于间接调用一个函数，也等于将这个函数绑定到一个指定的对象上：
```js
let name = 'window'

function getName(param1, param2) {
  console.log(this.name)
  console.log(param1, param2)
}
let obj = {
  name: 'easylee',
}
getName.call(obj, 123, 23)
getName.apply(obj, [123, 23])
```
如上面的例子，如果直接调用 `getName` 那么返回的是 `window` ，但是通过 `call` 方法，将函数绑定到了 `obj` 上，成为obj的一个函数，同时里面的 `this` 也指向了`obj`
两者主要的区别在于，当函数有多个参数时，`call` 是直接传入多个参数，而 `apply` 将多个参数组合成一个数组传输参数
### 手写call
原理：
1. 首先，通过 `Function.prototype.myCall` 将自定义的 `myCall` 方法添加到所有函数的原型对象上，使得所有函数实例都可以调用该方法。
2. 在 `myCall` 方法内部，首先通过 `typeof this !== "function"` 判断调用 `myCall` 的对象是否为函数。如果不是函数，则抛出一个类型错误。
3. 然后，判断是否传入了上下文对象 `context`。如果没有传入，则将 `context` 赋值为全局对象。这里使用了一种判断全局对象的方法，先判断是否存在 `global` 对象，如果存在则使用 `global`，否则判断是否存在 `window` 对象，如果存在则使用 `window`，如果都不存在则将 `context` 赋值为 `undefined`。
4. 接下来，使用 `Symbol` 创建一个唯一的键 `fn`，用于将调用 `myCall` 的函数绑定到上下文对象的新属性上。
5. 将调用 `myCall` 的函数赋值给上下文对象的 `fn` 属性，实现了将函数绑定到上下文对象上的效果。
6. 调用绑定在上下文对象上的函数，并传入 `myCall` 方法的其他参数 `args`。
7. 将绑定在上下文对象上的函数删除，以避免对上下文对象造成影响。
8. 返回函数调用的结果。

```js
Function.prototype.myCall = function (context, ...args) {
  // 判断调用myCall的是否为函数
  if (typeof this !== 'function') {
    throw new TypeError('Function.prototype.myCall - 被调用的对象必须是函数')
  }
  // 判断是否传入上下文对象,不传入则指定默认全局对象
  context = context || (typeof global !== 'undefined' ? gloabl : typeof window !== 'undefined' ? window : undefined)

  // 在上下文对象上绑定当前调用的函数,作为属性方法
  // 不能直接调用this方法函数,原因在于如果不将这个方法绑定到上下文对象上
  // 直接执行this函数,this函数里面的this上下文对象无法识别为绑定的对象
  let fn = Symbol('key')
  context[fn] = this
  const result = context[fn](...args)
  // 删除这个函数,避免对上下文对象造成影响
  delete context[fn]
  return result
}
const test = {
  name: 'xxx',
  hello: function () {
    console.log(`hello,${this.name}!`)
  },
  add: function (a, b) {
    return a + b
  },
}
const obj = { name: 'world' }
test.hello.myCall(obj) //hello,world!
test.hello.call(obj) //hello,world!
console.log(test.add.myCall(null, 1, 2)) //3
console.log(test.add.call(null, 1, 2)) //3
```
### 手写apply
```js
Function.prototype.myApply = function (context, argsArr) {
  // 判断调用myApply的是否为函数
  if (typeof this !== "function") {
    throw new TypeError("Function.prototype.myApply - 被调用的对象必须是函数");
  }

  // 判断传入的参数是否为数组
  if (argsArr && !Array.isArray(argsArr)) {
    throw new TypeError("Function.prototype.myApply - 第二个参数必须是数组");
  }

  // 如果没有传入上下文对象，则默认为全局对象
  //global:nodejs的全局对象
  //window:浏览器的全局对象
  context =
    context ||
    (typeof global !== "undefined"
      ? global
      : typeof window !== "undefined"
      ? window
      : undefined);

  // 用Symbol来创建唯一的fn，防止名字冲突
  let fn = Symbol("key");

  // this是调用myApply的函数，将函数绑定到上下文对象的新属性上
  context[fn] = this;

  // 传入myApply的多个参数
  const result = Array.isArray(argsArr)
    ? context[fn](...argsArr)
    : context[fn]();

  // 将增加的fn方法删除
  delete context[fn];

  return result;
};

// 测试一下
const test = {
  name: "xxx",
  hello: function () {
    console.log(`hello,${this.name}!`);
  },
};
const obj = { name: "world" };
test.hello.myApply(obj); //hello,world!
test.hello.apply(obj); //hello,world!
const arr = [2,3,6,5,1,7,9,5,0]
console.log(Math.max.myApply(null,arr));//9
console.log(Math.max.apply(null,arr));//9
```
## bind
最后来看看 `bind`，和前面两者主要的区别是，通过 bind 绑定的不会立即调用，而是返回一个新函数，然后需要手动调用这个新函数，来实现函数内部 `this` 的绑定
```js
let name = 'window'
function getName(param1, param2) {
  console.log(this.name)
  console.log(param1)
  console.log(param2)
}
let obj = {
  name: 'easylee',
}

let fn = getName.bind(obj, 123, 234)	// 通过绑定创建一个新函数，然后再调用新函数
fn()
```
除此之外, `bind` 还支持柯里化，也就是绑定时传入的参数将保留到调用时直接使用
```js
let sum = (x, y) => x + y
let succ = sum.bind(null, 1) // 绑定时没有指定对象,但是给函数的第一个参数指定为1
succ(2) // 3, 调用时只传递了一个参数2,会直接对应到y,因为前面的1已经绑定到x上了
```
### 手写bind
原理：
1. 首先，通过 `Function.prototype.myBind` 将自定义的 `myBind` 方法添加到所有函数的原型对象上，使得所有函数实例都可以调用该方法。
2. 在 `myBind` 方法内部，首先通过 `typeof this !== "function"` 判断调用 `myBind` 的对象是否为函数。如果不是函数，则抛出一个类型错误。
3. 然后，判断是否传入了上下文对象 `context`。如果没有传入，则将 `context` 赋值为全局对象。这里使用了一种判断全局对象的方法，先判断是否存在 `global` 对象，如果存在则使用 `global`，否则判断是否存在 `window` 对象，如果存在则使用 `window`，如果都不存在则将 `context` 赋值为 `undefined`。
4. 保存原始函数的引用，使用 `_this` 变量来表示。
5. 返回一个新的闭包函数 `fn` 作为绑定函数。这个函数接受任意数量的参数 `innerArgs`。（关于闭包的介绍可以看这篇文章->[闭包的应用场景](https://juejin.cn/post/7264183910597279799)）
6. 在返回的函数 `fn` 中，首先判断是否通过 `new` 关键字调用了函数。这里需要注意一点，如果返回出去的函数被当作构造函数使用，即使用 `new` 关键字调用时，`this` 的值会指向新创建的实例对象。通过检查 `this instanceof fn`，可以判断返回出去的函数是否被作为构造函数调用。这里使用 `new _this(...args, ...innerArgs)` 来创建新对象。
7. 如果不是通过 `new` 调用的，就使用 `apply` 方法将原始函数 `_this` 绑定到指定的上下文对象 `context` 上。这里使用 `apply` 方法的目的是将参数数组 `args.concat(innerArgs)` 作为参数传递给原始函数。

```js
Function.prototype.myBind = function (context, ...args) {
  // 判断调用myBind的是否为函数
  if (typeof this !== "function") {
    throw new TypeError("Function.prototype.myBind - 被调用的对象必须是函数");
  }

  // 如果没有传入上下文对象，则默认为全局对象
  //global:nodejs的全局对象
  //window:浏览器的全局对象
 context =
    context || (typeof global !== "undefined"
      ? global
      : typeof window !== "undefined"
      ? window
      : undefined);

  // 保存原始函数的引用，this就是要绑定的函数
  const _this = this;

  // 返回一个新的函数作为绑定函数
  return function fn(...innerArgs) {
    // 判断返回出去的函数有没有被new
    if (this instanceof fn) {
      return new _this(...args, ...innerArgs);
    }
    // 使用apply方法将原函数绑定到指定的上下文对象上
    return _this.apply(context,args.concat(innerArgs));
  };
};

// 测试
const test = {
  name: "xxx",
  hello: function (a,b,c) {
    console.log(`hello,${this.name}!`,a+b+c);
  },
};
const obj = { name: "world" };
let hello1 = test.hello.myBind(obj,1);
let hello2 = test.hello.bind(obj,1); 
hello1(2,3)//hello,world! 6
hello2(2,3)//hello,world! 6
console.log(new hello1(2,3));
//hello,undefined! 6
// hello {}
console.log(new hello2(2,3));
//hello,undefined! 6
// hello {}
```
总结一下，这三个函数都是用于改变函数内 `this` 对象的指向，只是使用方式有不同，其中 apply 传递多个参数使用数组的形式，call 则直接传递多个参数，而 bind 则可以将绑定时传递的参数保留到调用时直接使用，支持柯里化，同时 bind 不会直接调用，绑定之后返回一个新函数，然后通过调用新函数再执行。