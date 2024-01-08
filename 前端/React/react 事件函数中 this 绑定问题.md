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
1. 默认情况下`btnClick`内的`this`是绑定的是`undefined`，熟悉this绑定的应该知道，this是绑定运行时调用这个函数的对象，并且在严格模式下，window对象直接调用的函数，this绑定的是 `undefined`；
2. 在正常的DOM操作中，监听点击，调用监听函数其实是节点对象（比如上面是button对象）；
3. 并且React并不是直接渲染成真实的DOM，我们在render渲染函数中所编写的button只是一个语法糖，它的本质React的Element对象，这个对象里面的this绑定的是`undefined`；
4. 那么在这里发生监听的时候，react在执行`btnClick`函数时，默认里面`this`就是绑定的`undefined`；

解决方法：
知道了问题在于 `this` 的绑定不对，那么使用 `bind` 来重新绑定就可以解决了，有两种方式：

```js
class App extends React.Component {
        constructor() {
          super()
          this.state = {
            message: 'hello world',
          }
          // 方式1.在此处重新给点击函数绑定this为组件对象
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
              {/* 方式2.直接在渲染函数中重新绑定this */}
              <button onClick={this.btnClick.bind(this)}>
	              修改文本
              </button>
            </div>
          )
        }
      }
```

在上面两个位置任选一个重新绑定 `this` 为组件对象即可，推荐方式1，统一在这里给所有需要重新绑定的 `this` 的函数进行绑定。