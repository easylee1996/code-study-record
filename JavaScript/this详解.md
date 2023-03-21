# this详解

## this的基本绑定规则

`this`的绑定和函数定义的位置没有关系，和调用的方式和调用位置有关系，`this`是在运行时被绑定的。

> `this`具体绑定的对象是在调用的时候由哪个对象发起，那么`this`就是绑定的哪个对象，即便经过层层嵌套(函数里面有子函数，对象里面有函数属性)，但是最终是直接调用最里面的这个函数，那么`this`也是默认绑定，即没有绑定任何对象，默认为`window`。
>
> `this`无非是函数在调用的时候具体绑定的是哪个对象，`this`就表示哪个对象。

## this的具体绑定规则

### 默认绑定

独立的函数被调用，那么里面的`this`绑定的是`window`，也就是调用时没有被绑定到具体的对象。

比如普通的函数调用：

```javascript
function foo() {
  console.log(this); // window
}
foo();
```

第二种情况是函数调用链：

```javascript
function test1() {
  console.log(this); // window
  test2();
}

function test2() {
  console.log(this); // window
  test3();
}

function test3() {
  console.log(this); // window
}

test1();
```

> 同样的，在调用每一个方法的时候，方法的前面没有绑定对象，并不是`obj.test1()`前面绑定了对象。

第三种情况是函数作为参数：

```javascript
function foo(func) {
  func();
}

function bar() {
  console.log(this);    // window
}

foo(bar);
```

同上，虽然看起来`bar`到了`foo`的上下文中了，但是**只要调用一个函数时，前面没有绑定对象，那么就还是默认绑定。**

可以再看一下上例中的变例：

```javascript
function foo(func) {
  func();
}

var obj = {
  name: "easylee",
  bar: function () {
    console.log(this);  // window
  },
};

foo(obj.bar);
```

> 表面上看，上面的变例，调用的是obj对象的`bar`方法，但是在具体执行的时候，这个方法作为参数传入`foo`，foo里面执行`func()`的时候，执行`func()`并没有绑定任何对象，调用`obj.bar`传入参数的时候，只是调用并没有执行，所以还是window。
>
> 一定要注意，只有在调用执行的时候绑定了对象才算绑定，定义的时候就算它绑定了，只要没**调用并执行**就不算绑定

> 在严格模式下，默认绑定模式，直接调用`this`(也就是表示`window`的时候)会打印`undefined`，在webpack等打包工具中，通常会使用严格模式，来避免一些低级的语法错误。
>
> 所以在直接打印`this`的地方，直接使用`window`来代替

### 隐式绑定

通过一个对象，调用对象里面的函数，也就是通过某个对象发起的函数调用，此时函数的`this`就会绑定为这个对象。

```javascript
function foo() {
  console.log(this);
}

let obj1 = {
  name: "obj1",
  foo: foo
};

let obj2 = {
  name: 'obj2',
  obj1: obj1
}

obj1.foo();  // obj1
obj2.obj1.foo();  // obj1

let bar = obj1.foo;
bar();  // window，还是默认绑定，最终还是window在调用这个函数
```

> 隐式绑定有一个前提是调用的对象内部一定有一个对函数的引用，如上例中的`foo:foo`，对象一定有一个引用函数的属性，通过这个引用，间接的将函数里面的this绑定到这个对象中。

### 显示绑定

如果不希望在对象内部包含**函数引用的属性**，同时又希望`this`绑定到这个对象上，那么可以使用显示绑定，那就不需要在这个对象设置函数引用属性了。

通常使用`call`、`apply`和`bind`来给`this`显示的绑定一个对象。

使用`call`、`apply`均是显示的指定函数执行时，函数中`this`的指向，通过第一个参数传递需要绑定的对象。

> call、apply区别：一个函数调用call或者apply都会立即执行这个函数，第一个参数均是函数内this绑定的对象，第二个均是执行具体函数的参数，只是`call`是函数列表的形式，一个一个参数传递，`apply`是传递一个参数数组。

```javascript
let name = "window";

function foo() {
  console.log(this.name);
}

let obj1 = {
  name: "obj1",
};

foo();  // window 
foo.call(obj1); // obj1
foo.apply(obj1);  // obj1
```

> `bind`的不同之处在于，同样也是给this绑定对象，但是不会立即执行，而是创建一个绑定了具体对象的新函数。`bind`的第二个参数也是参数列表。

```javascript
function foo() {
  console.log(this.name);
}

let obj1 = {
  name: "obj1",
};

let bar = foo.bind(obj1);
bar(); // obj1
```

> 临时绑定对象一般使用call和apply即可，像是很多框架中，使用bind来绑定并创建新的函数，之后均使用新函数即可，这样做的好处是，可以固定的绑定一个对象，因为新函数是绑定后创建的，那么里面的`this`则不会再发生改变。

### new绑定

new绑定则非常简单，就是将构造函数中的`this`绑定到由构造函数创建的实例对象上，创建不同的对象，绑定的就是不同对象，在`new Person()`时进行的绑定操作。

```javascript
function Person() {
  console.log(this);  // {name: "person2"} 和 {name: "person2"}
}

let p = new Person();
p.name = 'person1'

let p2 = new Person();
p2.name = 'person2'
```

### 绑定优先级

new绑定 > 显示绑定 > 隐式绑定 > 默认绑定

## 其它绑定规则

有一些绑定规则不遵循上面的四条绑定规则。

### 显示绑定忽略

如果显示绑定`call`、`apply`、`bind`绑定的对象是`null`或者`undefined`那么显示绑定会被忽略，转变为默认绑定，`this`指向`window`。

### 自执行间接函数引用

如果使用自执行的方式去执行，引用其它对象的函数的这种形式，那么会指向`window`。具体效果查看代码，**这个记住就行，不要去套上面的规则，肯定套不上：**

```javascript
let obj1 = {
  name: 'obj1'
};
let obj2 = {
  name: 'obj2',
  foo: function () {
    console.log(this.name);
  },
};
obj2.foo(); // obj2
obj1.bar = obj2.foo;
obj1.bar();  // obj1
(obj1.foo = obj2.foo)();  // window 不是 obj1 自执行函数前面的语句一定要注意加分号
```

### 内置函数的绑定

`setTimeout`内绑定的是`window`:

```javascript
setTimeout(function () {
  console.log(this); // window
});
```

`forEach`等遍历函数的绑定：

```javascript
["foo", "bar"].forEach(function () {
  console.log(this); // window 默认是window
});
let obj1 = {
  name: "obj1",
};
["foo", "bar"].forEach(function () {
  console.log(this); // obj1，可以传递绑定的对象参数
}, obj1);
```

元素的事件默认绑定的是元素对象，除非使用箭头函数：

```javascript
const box = document.querySelector(".box");
box.onclick = () => {
  console.log(this);  // window
};

box.onclick = function() {
  console.log(this);  // box对象
}
```

### 箭头函数的绑定

箭头函数的`this`不绑定任何对象，而是从上层作用域中找到对应的`this`的绑定对象。

```javascript
let obj1 = {
  name: "obj1",
  foo: () => {
    console.log(this);
  },
  bar: function () {
    console.log(this);
  },
};
obj1.foo(); // window 当前默认是obj1对象中，使用箭头函数所以上一层是window
obj1.bar(); // obj1
```

> 要注意箭头函数不仅默认`this`不绑定对象，而且是无法绑定，就算通过显示绑定，也无法生效。

## 常见题目

### 常见题目1

```javascript
let name = "window";
let person = {
  name: "person",
  sayName: function () {
    console.log(this.name);
  },
};
function sayName() {
  let sss = person.sayName;
  sss();  // window
  person.sayName(); // person
  (person.sayName)(); // person 这里就是单纯的执行一下，和上面没区别
  (b = person.sayName)(); // window 
}
sayName();
```

### 常见题目2

```js
var name = "window";
var person1 = {
  name: "person1",
  foo1: function () {
    console.log(this.name);
  },
  foo2: () => console.log(this.name),
  foo3: function () {
    return function () {
      console.log(this.name);
    };
  },
  foo4: function () {
    return () => {
      console.log(this.name);
    };
  },
};
var person2 = { name: "person2" };

person1.foo1(); // person1
person1.foo1.call(person2); // person2

person1.foo2(); // window
person1.foo2.call(person2); // window

person1.foo3()(); // window
person1.foo3.call(person2)(); // window
person1.foo3().call(person2); // person2

person1.foo4()(); // person1
person1.foo4.call(person2)(); // person2
person1.foo4().call(person2); // person1
```

### 常见题目3

```js
var name = "window";
function Person(name) {
  this.name = name;
  this.foo1 = function () {
    console.log(this.name);
  };
  this.foo2 = () => console.log(this.name);
  this.foo3 = function () {
    return function () {
      console.log(this.name);
    };
  };
  this.foo4 = function () {
    return () => {
      console.log(this.name);
    };
  };
}
var person1 = new Person("person1");
var person2 = new Person("person2");

person1.foo1(); // person1
person1.foo1.call(person2);   // person2

person1.foo2(); // person1
person1.foo2.call(person2); // person1

person1.foo3()(); // window
person1.foo3.call(person2)(); // window
person1.foo3().call(person2); // person2

person1.foo4()(); // person1
person1.foo4.call(person2)(); // person2
person1.foo4().call(person2); // person1
```

### 常见题目4

```js
var name = "window";
function Person(name) {
  this.name = name;
  this.obj = {
    name: "obj",
    foo1: function () {
      return function () {
        console.log(this.name);
      };
    },
    foo2: function () {
      return () => {
        console.log(this.name);
      };
    },
  };
}
var person1 = new Person("person1");
var person2 = new Person("person2");

person1.obj.foo1()(); // window 最终调用函数时，没有任何隐式绑定和显示绑定，就是普通调用
person1.obj.foo1.call(person2)(); // window
person1.obj.foo1().call(person2); // person2

person1.obj.foo2()(); // obj
person1.obj.foo2.call(person2)(); // person2
person1.obj.foo2().call(person2); // obj
```