### apply和call

apply和call非常类似，都是用于改变函数中this的指向，只是传入的参数不同，等于间接调用一个函数，也等于将这个函数绑定要一个指定的对象上

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

### bind

最后来看看 `bind`，和前面两者主要的区别是，通过 bind 绑定的不会直接调用，而是返回一个新函数，然后需要手动调用这个新函数，来实现函数内部 `this` 的绑定

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

总结一下，这三个函数都是用于改变函数内 `this` 对象的指向，只是使用方式有不同，其中 apply 传递多个参数使用数组的形式，call 则直接传递多个参数，而 bind 则可以将绑定时传递的参数保留到调用时直接使用，支持柯里化，同时 bind 不会直接调用，绑定之后返回一个新函数，然后通过调用新函数再执行