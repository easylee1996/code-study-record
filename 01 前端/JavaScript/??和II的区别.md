??是空值合并运算符，||是逻辑运算符，两者使用方式基本相同，在??出现之前，在进行一些值的判断时，非常麻烦，比如：
```js
let firstName = null
let lastName = null
let nickName = 'Supercoder'

// 显示第一个真值：
console.log(firstName || lastName || nickName || 'Anonymous') // Supercoder
```
上面的代码用于判断其中哪一个有值，使用||返回的答案非常正确，下面来看看另外一段代码：
```js
let height = 0

console.log(height || 100) // 100
console.log(height ?? 100) // 0
```
使用||的结果不正确，不能因为高度为0，就显示默认值。
从上面的示例，可以看出两者的区别是：
- `||` 返回第一个 **真** 值。
- `??` 返回第一个 **已定义的** 值。

也就是说，`||` 无法区分 `false`、`0`、空字符串 `""` 和 `null/undefined`。它们都一样 —— 假值（falsy values）。如果其中任何一个是 `||` 的第一个参数，那么我们将得到第二个参数作为结果。
不过在实际中，我们可能只想在变量的值为 `null/undefined` 时使用默认值。
也就是说，当该值确实未知或未被设置时，才使用默认值，这通常更常用，因为后端返回false、0等值是特别常见的情况。