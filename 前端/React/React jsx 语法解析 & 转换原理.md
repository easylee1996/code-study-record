## jsx介绍 
 
 jsx是一种JavaScript的语法扩展（eXtension），也在很多地方称之为JavaScript XML，因为看起就是一段XML语法，用于描述UI界面，并且可以和JavaScript代码结合使用。

比起vue中的模板语法，更加灵活，且不需要学习模板语法中的特定标签，比如：`v-if`、`v-for`、`v-bind`等，而是直接使用JavaScript语法就可以实现这些标签的功能。

**为何React中编写UI界面需要使用jsx语法呢**？

因为原生html和js两者是密不可分的两个部分，比如操作html元素时：

1. 使用js选中元素，然后修改元素；
2. 元素上绑定有事件时，需要绑定对应的事件函数；
3. js中某些数据发生变化时，需要修改html元素。

索性，React直接将两者组合在一起进行管理。

## jsx语法

### 书写规范

1. 顶层只允许有一个根元素，和vue2类似；
2. 为了方便阅读，通常在外层包裹一个 `()`；
3. 可以使用单标签和双标签，但是单标签一定要包含结束符号，如：`<button/>`。

```js
// 定义App根组件
class App extends React.Component {
  render() {
	{/* 2.return外层，最好包裹一个() */}
	return (
	  {/* 1.顶层只允许有一个根元素 */}
	  <div>
		  {/* 3.支持单标签和双标签 */}
		  <h2>h2</h2>
		  <br/>
		</div>
	  </div>
	)
  }
}
```

### 基本使用

#### 1.添加注释

在jsx中，添加注释使用这样的格式：

`{/* 注释内容 */}`

#### 2.使用变量

1. 当变量是Number、String、Array类型时，可以直接显示
2. 当变量是null、undefined、Boolean类型时，内容显示为空，如果需要显示，需要转换为字符串；
3. Object对象类型不能作为子元素（not valid as a React child）

```js
class App extends React.Component {
	constructor() {
	  super()
	  this.state = {
		// Number/String/Array类型
		name: 'easylee',
		age: 18,
		movies: ['xxx', 'xxx'],
	
		// null/undefined/boolean类型
		varNull: null,
		varUndefined: undefined,
		varBoolean: true,
	
		// Object对象
		friends: { name: 'foo' },
	  }
	}
	
	render() {
	  const { name, age, movies } = this.state
	  const { varNull, varUndefined, varBoolean } = this.state
	  const { friends } = this.state
	
	  return (
		<div>
		  {/* 正常显示 */}
		  <h2>name: {name}</h2>
		  <h2>age: {age}</h2>
		  <h2>movies: {movies}</h2>
	
		  {/* 显示为空 */}
		  <h2>null: {varNull}</h2>
		  <h2>undefined: {varUndefined}</h2>
		  <h2>Boolean: {varBoolean}</h2>
	
		  {/* 显示为字符串 */}
		  <h2>null: {varNull + ''}</h2>
		  <h2>undefined: {String(varUndefined)}</h2>
		  <h2>Boolean: {varBoolean.toString()}</h2>
	
		  {/* 对象不允许直接作为子元素，必须具体到对象的属性 */}
		  {/* <h2>friends: {friends}</h2> */}
		  <h2>friends: {friends.name}</h2>
		</div>
	  )
	}
}
const root = ReactDOM.createRoot(document.querySelector('#root'))
root.render(<App />)
```

#### 3.使用表达式

和vue中使用模板语法一样，只有可以放在 `return` 后的语句，都是表达式，可以直接在jsx中使用。

主要包含：

1. 运算表达式；
2. 三元表达式；
3. 可执行函数。

```js
class App extends React.Component {
	constructor() {
	  super()
	  this.state = {
		firstName: 'easy',
		lastName: 'lee',
		age: 18,
		movies: ['foo', 'bar'],
	  }
	}
	
	getMovies() {
	  return this.state.movies
	}
	
	render() {
	  const { firstName, lastName, age } = this.state
	
	  return (
		<div>
		  {/* 表达式 */}
		  <h2>{1 + 1}</h2>
		  <h2>{firstName + ' ' + lastName}</h2>
		  <h2>{age >= 18 ? '成年' : '未成年'}</h2>
		  <h2>{this.getMovies()}</h2>
		</div>
	  )
	}
}
```

#### 4.绑定属性

给html元素或者组件添加属性，和直接使用变量类似，都使用`{}`包裹即可，绑定 `class`和 `style` 有一点不同：

1. 基本属性，直接绑定即可；
2. class属性，需要使用 `className` 代替 `class` ，因为class在js中也表示类；
3. style属性，需要传递一个对象。

```js
class App extends React.Component {
	constructor() {
	  super()

	  this.state = {
		title: 'title',
		imgUrl: 'http://xxx.xxx.xxx',
		isActive: true,
		objStyle: { color: 'red', fontSize: '20px' },
	  }
	}

	render() {
	  const { title, imgUrl, isActive, objStyle } = this.state
	  const className = `foo ${isActive ? 'active' : ''}`
	  return (
		<div>
		  {/* 基本属性绑定 */}
		  <h2 title={title}>h2</h2>
		  <img src={imgUrl} />

		  {/* 绑定class属性 */}
		  <h2 className='className'>h2</h2>

		  {/* 绑定style属性，objStyle必须是一个对象 */}
		  <h2 style={objStyle}>h2</h2>
		</div>
	  )
	}
}
```

#### 5.绑定事件

React中绑定事件需要使用小驼峰格式。

```js
class App extends React.Component {
	constructor() {
	  super()

	  this.state = {
		name: 'easylee',
	  }
	}
	btnClick() {
	  console.log('btnClick')
	}
	btnClick2() {
	  this.setState({
		name: 'easy',
	  })
	}
	btnClick3(event, name, age) {
	  console.log(event, name, age)
	}
	render() {
	  return (
		<div>
		  {/* 事件绑定基本使用 */}
		  <button onClick={this.btnClick}>按钮</button>
		  <button onClick={() => this.btnClick2()}>按钮</button>
		  <h2>{this.state.name}</h2>

		  {/* 传递参数 */}
		  <button onClick={event => this.btnClick3(event, 'easylee', 18)}>按钮</button>
		</div>
	  )
	}
}
```

上例代码中，当我们绑定的函数体内部使用了`this`，传递给onClick的函数需要绑定指定的this，通常有下面几种方式进行绑定，原因和解决方法具体可以看：[[react 事件函数中 this 绑定问题]]。

同时，给绑定函数传递参数时，onClick会默认给绑定的函数第一个参数传递 `event` 参数。

#### 6.条件渲染

jsx中条件渲染可以使用多种方式：

1. 直接使用JavaScript if进行条件判断；
2. 使用三元运算符；
3. 使用逻辑运算符。

```js
class App extends React.Component {
	constructor() {
	  super()

	  this.state = {
		isOk: true,
		friend: { name: 'foo' },
	  }
	}
	render() {
	  const { isOk, friend } = this.state
	  let showContent = null
	  if (isOk) {
		showContent = <h2>正常</h2>
	  } else {
		showContent = <h2>异常</h2>
	  }

	  return (
		<div>
		  {/* 1.使用if进行判断，注意渲染函数中不能使用if判断，应该写在render()外 */}
		  <h2>{showContent}</h2>

		  {/* 2.三元运算符 */}
		  <h2>{isOk ? <span>正常</span> : <span>异常</span>}</h2>

		  {/* 3.&&逻辑与判断，为空或者undefined时，就会默认不显示 */}
		  <h2>{friend && <span>{friend.name}</span>}</h2>
		</div>
	  )
	}
}
```

#### 7.列表渲染

列表渲染通常使用高阶函数，比如 `map`、`filter`等，通过前面的介绍，我们知道表达式可以直接在 `{}` 中使用，直接使用这些高阶函数即可渲染列表。

```js
class App extends React.Component {
	constructor() {
	  super()

	  this.state = {
		list: [
		  {
			name: 'easylee',
			age: 18,
		  },
		  {
			name: 'foo',
			age: 20,
		  },
		],
	  }
	}
	render() {
	  const { list } = this.state
	  return (
		<ul>
		  {list.map(item => {
			return (
			  <li key={item.name}>
				<h2>name: {item.name}</h2>
				<h2>age: {item.age}</h2>
			  </li>
			)
		  })}
		</ul>
	  )
	}
}
```

上面代码中，`{}` 内通过高阶函数，获取到一个 `li` 元素数组，然后直接渲染这个数组，即完成了列表的渲染。

当然也可以把高阶函数这块代码提取到其它地方或者创建一个函数专门生成 `li` 元素数组。

同时需要注意，和vue一样，列表元素都需要设置一个 `key` ，以提高diff算法时的效率。

## jsx转换原理

jsx通过babel进行转换，仅仅是一个语法糖，本质上，所有的jsx代码最终都将转换为 `React.createElement(type, config, children)`函数，这个函数包含三个参数：

1. type：当前元素的类型，比如div就传div，组件就传组件名；
2. config：当前元素的各种属性，比如class属性，src属性等；
3. children：当前元素的下级元素，比如ul下的li，里面又是一个`React.createElement(type, config, children)`函数，是嵌套的结构。

以这段代码为例：

```js
class App extends React.Component {
	// ...
	render() {
	  return (
		<div>
		  <div className='header'>Header</div>
		  <ul className='Content'>
			<li>列表数据1</li>
			<li>列表数据2</li>
		  </ul>
		</div>
	  )
	}
}
```

render函数渲染中return的部分，最终会转换为`React.createElement`函数，直接放到return中，渲染结果一样：

```js
render() {
  return React.createElement(
	'div',
	null,
	React.createElement(
	  'div',
	  {
		className: 'header',
	  },
	  'Header',
	),
	React.createElement(
	  'ul',
	  {
		className: 'Content',
	  },
	  React.createElement('li', null, '\u5217\u8868\u6570\u636E1'),
	  React.createElement('li', null, '\u5217\u8868\u6570\u636E2'),
	),
  )
}
```

这个代码，可以通过babel在线转换查看：[Babel · The compiler for next generation JavaScript](https://babeljs.io/repl/#?presets=react)

可以直接编写 `React.createElement` 来生成UI界面，从而不使用babel转换。

通过上面的 `React.createElement` 函数，可以创建出一个 `ReactElement`对象，React利用ReactElement对象组成JavaScript的对象树，这个对象树就是**虚拟DOM**。

编写jsx代码，然后调用createElement函数创建ReactElement对象，react再经过一些处理，最终使用JavaScript的createElement方法，再转换为真实DOM。


