JavaScript 提供了 automatic semicolon insertion (ASI)自动插入分号规则，在不加分号的情况下，会自动补充分号来分隔不同语句。

导致在继左大括号换行、tab 和 space 圣战后，前端又出现了一场战争。

并且随着那个男人加入这场讨论之后，关于是否应该加分号的讨论更是激烈了。
![[CleanShot 2024-01-18 at 11.18.05@2x.png]]
## ASI 自动插入分号规则
在决定是否添加分号之前，我们先来了解一下编译器到底在哪些情况下会自动插入分号，哪些情况必须手动添加分号。
### 会自动添加分号的情况
1.遇到换行符，但是两句代码连接是无效代码
```js
// 代码
42
'hello'

// `42 'hello'`连接在一起是无效语句，所以会自动在之间插入分号
42;'hello'

// 直接明确的写法
42;"hello"
```
```js
// 代码
let a = 10, b = 5
a
-
b

// a - b 为有效代码，所以三者之间不会自动加分号
a = 1; b = 2;

// 直接明确的写法
a - b
```

2.遇到换行符，但是两句代码之间不允许有换行符
```js
// 代码
foo
++
bar
++
baz

// foo 和 ++ 符合规则1，但是不符合 no LineTerminator here规则，所以会添加分号
foo; 
++bar; 
++baz;
```
在 JS 标准中，有个 no LineTerminator here 的规则，规定哪些语法不能加入换行符，如果开发者加了换行符，则 JS 编译器会无法识别并加入分号。
1. 带标签的`continue`语句，不能`continue`后插入换行；
2. 带标签的`break`语句，不能在`break`后面插入换行；
3. `return`后面不能插入换行；
4. 后自增、后自减运算符前不能插入换行；
5. `throw`和`Exception`之间不能插入换行；
6. `async`关键字，后面不能插入换行；
7. 箭头函数的箭头前，不能插入换行；
8. `yield`之后，不能插入换行。

3.Restricted productions 
如果这些标签后，空一行书写其它语句，则会自动在这些标签后添加分号：
-  `++` or `--`
- `return`
- `break`
- `continue`
- ES6 `yield` 、`async` 等
- 反引号\`

```js
// return 后空一行再书写语句，则会自动在 return 后加分号
return
{
  a: 1
}

// 这是正确写法
return {
  a: 1
}
```

其它标签类似。

如果手动在这些标签后加上分号，同样也是错误的，比如：
```js
// 空一行再写 a，会自动在 ++ 后添加分号
++
a

// 就算手动添加，和上面结果一样是错误的
++;
a;
```

所以针对 Restricted productions ，无论让编译器自动添加分号，还是自己手动加上分号，都是错误的，都应该去避免去换行，避免写这种写法。
### 必须手动加分号的情况
以下面这些标签开头的命令，必须在前面加分号，和前面一个语句分隔：
- `+` 和 `-`：语句以 + 或者 - 开头
- `/`:  语句以正则表达式开头
- `(` :  语句以自执行函数开头
- `[`: 语句以数组开头


举例说明：
```js
// 错误
a = b
+a
// 正确
a = b
;+a


// 错误
a = b
/something/.test(a)
// 正确
a = b
;/something/.test(a)

// 错误
a = b
(function () {})()
// 正确
a = b
;(function() {})()

// 错误
a = b
[1, 2, 3].forEach()
// 正确
a = b
;[1, 2, 3].forEach()
```

上面的情况，如果第二行代码不手动添加分号的话，两行代码会合并在一起导致结果错误或者报错。

上面几种情况中，只有自执行函数和数组开头会在极少情况下遇到，记住这两个前面要手动加上分号即可。

就算是习惯加分号的朋友，但仍然要注意下面的情况：
```js
// 不需要结尾添加分号
if () {
} 

// 不需要结尾添加分号
for () {
} 

// 不需要结尾添加分号
while () {
} 

// 需要在结尾添加分号
var a = function () {
}; 

// 需要在结尾添加分号
var a = {
  prop: value
}; 

// 报错
[1, 2, 3].forEach();
```

即便习惯写分号的朋友，也很少有人在 `if` 、`for`、`while` 等语句 `}` 后写分号，但是如果使用赋值的形式传递，则一定要注意在 `}` 把分号添加上，以避免后面语句出现自执行和数组开头的语句。

推荐遇到自执行和数组开头的，直接前面加上分号就完事了。
## 总结
是否添加和是否手动加是两回事，我们可以用 eslint、Prettier 等工具自动生成或者删除分号，是否手动加可以看个人喜好，最终代码内可以根据项目要求用工具生成。

但都要注意必须添加分号的几种情况。
## 参考文章
- [Hacking Semicolons](https://slides.com/evanyou/semicolons#/12/0/3)
- [What are the rules for JavaScript's automatic semicolon insertion (ASI)? - Stack Overflow](https://stackoverflow.com/questions/2846283/what-are-the-rules-for-javascripts-automatic-semicolon-insertion-asi)
