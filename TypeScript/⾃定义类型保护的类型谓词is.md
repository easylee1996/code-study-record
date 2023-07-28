类型保护有几种方法：比如`in`、`typeof`和`instanceof`，都可以对变量的类型进行保护，除此之外，还有一种自定义类型保护，使用类型谓词`is`，下面来看一下is的用法：
```typescript
function isString(x: any): x is string {
  return typeof x === 'string'
}

function isString1(x: any): boolean {
  return typeof x === 'string'
}

let foo: unknown
console.log(foo.length) // 报错: 未知类型,需要使用类型保护

if (isString1(foo)) {
  console.log(foo.length) // 报错: foo仍然是未知类型
}
if (isString(foo)) {
  console.log(foo.length) // 不报错，因为检测了foo类型为string
}
```

从上面的使用方式来看，我们可以得知`is`的作用是，让一个函数一个方法获得类型保护的能力，当一个方法使用了类型谓词`x is string`之后，就可以检测变量为`string`了，就等同于拥有了`if(typeof x === 'string')`这样的能力

简单来说，就是让函数拥有类型检测能力，而返回值类型如果只是简单的`boolean`则没有这种能力

换一种说法，is类型谓词也是`boolean`类型，只是在这个类型上添加了类型保护能力

至于函数体里面的`return typeof x === 'string'`用于判断是否是`string`，是否产生类型保护还是依赖于is类型谓词