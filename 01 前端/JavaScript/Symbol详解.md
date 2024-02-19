Symbol是es6出的一种类型，他也是属于原始类型的范畴(string, number, boolean, null, undefined, symbol)，不是类。

主要作用可以用于避免属性重复和创建私有属性(不能完全实现)。

### 避免属性重复

```javascript
const obj = {
    name: 'easylee',
}
obj['name'] = '123'
// 如果obj属性特别多，或者来源于其它文件，本身我们是想增加一个name属性，但却修改了原来的属性值
obj['name'] = '456'
// 此时使用symbol创建，是绝对不会和原有属性重复的，可以放心的使用
let name = Symbol('name')
obj[name] = '123'
console.log(obj)
```

### 私有属性

```javascript
let uid = Symbol('uid')
let obj = {
    name: 'easylee',
    [uid]: 'uid',
}
// 使用symbol创建的属性，默认是无法通过循环和下面的两个方法获取到的，必须使用Object.getOwnPropertySymbols
console.log(Object.keys(obj)) // []
console.log(Object.getOwnPropertyNames(obj)) // []
console.log(Object.getOwnPropertySymbols(obj)) // [Symbol(uid)]
```

### 全局共享

```js
const name = Symbol('name')
// 全局拿到共享的属性，方便在多个模块中使用相同的属性名
console.log(Symbol.for('name'))
```

