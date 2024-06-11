作为一个高级前端开发人员，除了对各种开发技术熟练掌握之外，对代码的健壮性和可用性也有更高的要求，下面从多个方面来提升代码健壮可用性。
## 处理后端接口返回值
作为前端开发，代码通常是需要和后端接口进行交互，一旦代码依赖后台接口返回值，则一定要对接口进行检查，否则极有可能导致页面报错和白屏。下面是一些常见错误的案例：
### 1. 数据是否存在
> 先来了解一个知识点，访问一个对象的属性，如果这个对象存在，而属性不存在，不会报错，只会返回 `undefined` ，但是如果对象都不存在，不管访问这个对象还是这个对象的属性都会报错。常见于下面的情况：
> ```js
> .then(res=>{
> 	if (res && res.data) {	// 通常在这里判断接口返回的准确性，即使不存在data属性，也不会报错，但如果使用res.data.xxx，当data这个对象属性都不存在时，那么就会报错
>     // xxx
>   }
> })
> ```

通常接口返回 `res.data` ，然后使用解构赋值来解析需要的参数，这时如果其中某些参数为 `undefined` 或者 `null`，代码则会报错：
优化前：
```js
const App = (data) => {
  const { name, age } = data
}
```
上述代码当 `data`为 `undefined` 或 `null`时，就会报错，因为无法从 `undefined` 中解析参数。
优化后：
```js
const App = (data) => {
  const { name, age } = data || {};
}
```
设置一个默认，则解析不会报错，当然 `name` 和 `age` 仍然是 `undefined`，但是避免了报错和白屏出现。
还有一种处理方式，通常用于数组中每条对象，需要使用多个对象参数值，如果每个做上面的空值和默认值则过于繁琐，通常使用下面的方式：
优化前：
```js
const App = (props) => {
  const { data } = props || {};
  let infoList = [];
  if (Array.isArray(data)) {
    infoList = data.map(item => `我的名字是${item.name},今年${item.age}岁了`);
  }
}
```
如果 `item` 不存在 `name` 和 `age` 则一定会报错
一次优化：
```js
const App = (props) => {
  const { data } = props || {};
  let infoList = [];
  if (Array.isArray(data)) {
    infoList = data.map(item => `我的名字是${item?.name},今年${item?.age}岁了`);
  }
}
```
加入了可选链操作符，虽然好用，但是 `item?.name`会被编译成 `item === null || item === void 0?void 0 : item.name`，在循环中使用，会导致编译后的代码大大增加，不能滥用。
二次优化：
```js
const App = (props) => {
  const { data } = props || {};
  let infoList = [];
  if (Array.isArray(data)) {
    infoList = data.map(item => {
      const { name, age } = item || {};
      return `我的名字是${name},今年${age}岁了`;
    });
  }
}
```
上面二次优化后，通过数组判断，以及给对象设置默认值，然后结构赋值，如果没有这个参数，那么最后打印的值中 `name` 和 `age` 会是 `undefined` ，但是避免了报错和白屏，而且通过这样的方式，避免了可选链代码的增加，**通常在数组循环中应该使用这样的方式，如果没有循环那么使用可选链影响不大。**
### 2. 不靠谱的默认值
在ES6内部使用严格相等运算符（`===`）判断一个值是否有值，如果一个对象的属性不严格等于 `undefined`，默认值不会生效，比如下面的代码：
```js
const App = (data = {}) => {
  const { name, age } = data ;
}
```
以为给 `data` 设置了默认值，则可以解决问题，但是一旦 `data` 的值为 `null` 则默认值不会生效，仍然会报错，所以不要太相信默认值。
### 3.数组方法一定要用数组调用
如果一个数组不是数组，则一定不要使用数组方法，通常发生在后台返回的数据列表，一旦不存在，则会报错。
优化前：
```js
const App = (props) => {
  const { data } = props || {};
  const nameList = (data || []).map(item => item.name);
}
```
上面的代码虽然给数据设置了空值判断和默认值设置，但是如果数组为数字或者其它类型，仍然会出现报错，最合理的方法还是进行数组判断：
优化后：
```js
const App = (props) => {
  const { data } = props || {};
  let nameList = [];
  if (Array.isArray(data)) {
    nameList = data.map(item => item.name);
  }
}
```
通常使用 `Array.isArray` 对数据进行数组判断。
### 4. async/await 错误捕获
当使用 `async/await` 时，如果 `await` 方法内部报错，则外部方法会一直堵塞，应该避免这种情况。
优化前：
```js
import React, { useState } from 'react';

const App = () => {
  const [loading, setLoading] = useState(false);
  const getData = async () => {
    setLoading(true);
    const res = await queryData();
    setLoading(false);
  }
}
```
一次优化：
```js
import React, { useState } from 'react';

const App = () => {
  const [loading, setLoading] = useState(false);
  const getData = async () => {
    setLoading(true);
    try {
      const res = await queryData();
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  }
}
```
增加了 `try catch` 但是不够优雅
二次优化：
```js
import React, { useState } from 'react';
import to from 'await-to-js';

const App = () => {
  const [loading, setLoading] = useState(false);
  const getData = async () => {
    setLoading(true);
    const [err, res] = await to(queryData());
    setLoading(false);
  }
}
```
使用 `await-to-js` 插件，可以方便的识别 `await` 代码后的错误
### 5. 不要过度防御
```js
const App = (props) => {
  const { data } = props || {};
  let infoList = [];
  if (Array.isArray(data)) {
    infoList = data.map(item => {
      const { name, age } = item || {};
      return `我的名字是${name},今年${age}岁了`;
    });
  }
  const info = infoList?.join('，');
}
```
数组的 `map` 方法返回的一定是一个数组，没有必要添加可选链再次防御