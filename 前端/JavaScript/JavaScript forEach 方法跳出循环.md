### for循环
JavaScript中，for循环可以使用 `break` 和 `continue` 来跳出：
- continue：跳出本次循环
- break：结束循环
```js
for (let i = 0; i < 10; i++) {
  if (i === 1) {
    // 跳出本次循环，不会打印1
    continue
  }
  if (i === 3) {
    // 结束循环，不会打印3和之后的数字
    break
  }
  // 输出0 2
  console.log(i)
}
```

### forEach循环
除了for循环，常用的forEach如何退出呢？
```js
const numbers = [1, 2, 3, 4, 5]
numbers.forEach(number => {
  if (number === 2) {
    // 跳出整个循环
    break  // SyntaxError: Illegal break statement
  }
    console.log(number)
})
```
可以看到，直接使用break，会报非法中断语句错误

再试试 `continue` ：
```js
numbers.forEach(number => {
  if (number === 2) {
    // 跳出当前循环
    continue  // SyntaxError: Illegal continue statement: no surrounding iteration statement
  }
    console.log(number)
})
```
可以看到同样报错，continue不能在非循环语句中，原因是forEach的参数是一个回调函数，并不是循环语句，所以无法执行continue语句
具体可以参考：[SyntaxError: continue must be inside loop - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Errors/Bad_continue)

里面也提到了解决方法，使用 `return` 退出当前循环，以及使用 `for of`代替forEach
```js
numbers.forEach(number => {
  if (number === 2) {
    // 跳出当前循环
    return 
  }
  console.log(number) // 1 3 4 5
}
```
```js
for (const number of numbers) {
  if (number === 2) {
    continue
  }
  console.log(number) // 1 3 4 5
}
```

但是就想使用 `forEach` 来跳出循环应该如何操作呢，上面文档中没有提到，但可以使用 `try catch`来实现：
```js
try {
  numbers.forEach(number => {
    if (number === 2) {
      throw new Error()
    }
    console.log(number) // 1
  })
} catch (error) {
  console.log('捕获到错误')
}
```

综上，使用forEach时，使用 `return` 跳出当前循环，使用 `try catch` 跳出整个循环。