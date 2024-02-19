在使用类方式创建组件时，类中定义一个函数，并且绑定到元素的点击事件上，此时这个函数中this指向并不是当前这个组件。

组件代码如下：
```js
class App extends React.Component {
        // 组件数据
        constructor() {
          super()
          this.state = {
            message: 'hello world',
          }
        }
        // 点击函数
        btnClick() {
          this.setState({
            message: 'hello react',
          })
        }
		// 渲染函数
        render() {
          return (
            <div>
              <h2>{this.state.message}</h2>
              <button onClick={this.btnClick}>
	              修改文本
              </button>
            </div>
          )
        }
      }
```

如上代码中，点击修改文本按钮，会发生如下报错

`Uncaught TypeError: Cannot read properties of undefined (reading 'setState')`

提示 `undefined` 找不到 `setState` 方法。

主要原因如下：

1. 默认情况下`btnClick`内的`this`是绑定的是`undefined`，熟悉this绑定的应该知道，this是绑定运行时调用这个函数的对象，this绑定详解可以查看：[[JavaScript this 绑定详解]]；
2. 在正常的DOM操作中，监听点击，调用监听函数的其实是节点对象，比如上面的按钮对象；
3. 在React中，并不是直接渲染真实的DOM，render渲染函数中所编写的button只是一个语法糖，最终会编译成 `React.createElement("button", {onClick: this.btnClick})`；
4. 同时会将 `btnClick` 函数暴露出来，以 `const click = onClick(伪代码)` 的形式；
5. 当点击事件触发时，react执行上面的 `click` 函数，默认里面`this`就是绑定的`undefined`，相当于window中调用函数(严格模式下为 `undefined`)；

解决方法：
知道了问题在于 `this` 的绑定不对，有三种方式解决：

1.给点击函数显式绑定 `this`

```js
class App extends React.Component {
        constructor() {
          super()
          this.state = {
            message: 'hello world',
          }
          // 位置1.在此处重新给点击函数绑定this为组件对象
          this.btnClick = this.btnClick.bind(this)
        }
        btnClick() {
          this.setState({
            message: 'hello react',
          })
        }
        render() {
          return (
            <div>
              <h2>{this.state.message}</h2>
              {/* 位置2.直接在渲染函数中重新绑定this */}
              <button onClick={this.btnClick.bind(this)}>
	              修改文本
              </button>
            </div>
          )
        }
      }
```

在上面两个位置任选一个重新绑定 `this` 为组件对象即可。

2.使用 ES6 class field

```js
class App extends React.Component {
        constructor() {
          super()
          this.state = {
            message: 'hello world',
          }
        }
        // class field
        btnClick = () => {
          this.setState({
            message: 'hello react',
          })
        }
        render() {
          return (
            <div>
              <h2>{this.state.message}</h2>
              <button onClick={this.btnClick}>修改文本</button>
            </div>
          )
        }
      }
```

上面使用 `class field`的方式，给 `btnClick` 赋值一个箭头函数，箭头函数默认绑定当前环境的 `this`。

3.直接在按钮上使用箭头函数(推荐)

```js
class App extends React.Component {
        constructor() {
          super()
          this.state = {
            message: 'hello world',
          }
        }
        btnClick() {
          this.setState({
            message: 'hello react',
          })
        }
        render() {
          return (
            <div>
              <h2>{this.state.message}</h2>
              {/* 直接绑定箭头函数 */}
              <button onClick={() => this.btnClick()}>修改文本</button>
            </div>
          )
        }
      }
```

再看一下此时执行的流程：
1.  `onClick` 绑定的是一个箭头函数，箭头函数的 `this` 绑定的是App组件对象；
2. 前面的两个例子中是将这个函数引用赋值给 `onClick`，等待按钮事件点击，然后再触发这个引用的函数，`onClick={this.btnClick}`；
3. 而上面的代码中，是 `onClick={() => this.btnClick()}`，是将 `() => this.btnClick()` 这个箭头函数赋值给 `onClick`，按钮点击触发这个箭头函数，而箭头函数内部是一个已经调用过的 `btnClick()` 函数，包含 `()` ，调用时在箭头函数内部，所有 `this` 绑定的是 `App` 组件对象。