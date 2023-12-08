---
创建时间: 2023-11-17T16:35
更新时间: 2023-11-24T09:03
---
在vue中，组件如果需要css样式隔离，只需要给组件的style标签上添加 `scoped` 属性，就可以实现样式隔离，否则组件内的样式是添加到全局css里面的。

在添加了样式隔离之后，有时候会出现无法给指定元素设置样式，比如第三方组件element的弹窗组件：

```vue
<style scoped>
.el-dialog__body {
  font-size: 200px;
}
</style>
```

比如上面的代码本意是给弹窗的内容添加样式，但是无法生效，原因也很简单，因为加上scoped之后，上面的样式名会变为 `.el-dialog__body[data-v-xxxx]`,表面上看这个代码应该可以生效啊，因为 `.el-dialog__body`就是在这个组件里面，确实是这样，但是不生效的原因很简单，这个 `.el-dialog__body`样式名可不是在当前这个组件内，而是在子组件内，而且也并不是子组件的最顶层元素，而 `.el-dialog__body[data-v-xxxx]`是寻找当前组件上的，所以肯定找不到。

应该怎么解决呢？

通常有下面几种解决方法：

1. 穿透scoped

stylus的样式穿透使用`>>>` sass和less的样式穿透使用`/deep/`，以及vue自带的 `:deep(xxx)`，后面详细来说穿透scope的原理

2. 使用两个style标签

这种做法是将element的css提升到全局作用域了

```xml
<style>
/* 用于修改第三方库的样式 */
</style>
 
<style scoped>
/* 自己的组件内样式 */
</style>
```

3. 添加class

通过在外层dom上添加唯一的class来区分不同组件。注意每个组件的class名一定要区分开，这样相当于手动实现了 `scoped`的效果，当作用于类似element组件的css时，要注意单独写到外面，因为element子组件可没有这个class名，也是将element样式提升到全局了。

```xml
<style>
.my-class {
 color: red;
 /* 所有样式都被包含在my-class中 */
}
// element代码
</style>
<template>
 <div class="my-class">
 <!-- dom结构 -->
 </div>
</template>
```

基于上面几种方法，在父组件需要给子组件设置样式，同时父组件添加了scoped属性时，使用上面的方法即可，通常用第一种。

## ::v-deep()核心原理
1. 打包之后的所有css如果不分包的话，所有css样式会放到一起，也就是写的所有样式都会是全局样式，所以要加上scope来实现独有样式。
2. 添加了scope，每个组件内部，每个元素(包含子组件)会添加data属性，style中的样式比如className,ID添加相同的data，如 `.class-name[data-v-66cbb946]`，最终css打包到一个文件之后，才实现了样式隔离，都拥有一个相同的data。
3. 给子组件添加data，其实也就是子组件的最顶层元素会添加这个父组件的相同data，这个vue scope的一个实现细节，因此，在父组件可以直接操作子组件对顶层元素的样式，比如父组件内直接通过子组件class名对子组件进行样式修改:
```js
// 父组件
<div>
	<child class="child-name"></chid>
<div>

// 子组件
<div>
	<div class="inner">
	</div>
</div>

<style scope>
// 直接修改子组件的样式
.child-name {
	xxx
}
</style>
```
打包之后上面的div和子组件child的最顶层元素(比如child最顶层元素是一个div，则这个div会加上相同data)都会加上一个data，比如data-v-1234，同时 .child-name这个样式也会变为 `.child-name[data-v-1234]`，很显然这个样式可以修改到子组件的顶层元素，因为它也是这个data。
4. 子组件内除了顶部元素之外的其它元素，不会加上父组件的scope，如果子组件内部也有scope，则会生成自己的data，子组件顶层元素会有两个data，如果子组件内部没有scope，则只有最顶层元素拥有父组件的data，其它元素没有data。
5. 因为子组件的其它元素没有父组件的data属性，我们在父组件对子组件其它元素进行修改时，无法生效：
```js
// 父组件内
<style scope>
.child-name .inner {
	xxx // 无法生效
}
</style>
```
上面的父组件样式打包后会变为 `.child-name .inner[data-v-父组件data]`，而子组件的其它元素无论是否添加scope都无法生效：
- 子组件添加scope：子组件元素拥有自己的data，上面的父组件样式因为有父组件data，肯定无法作用到拥有子组件data的元素上
- 子组件未添加scope：子组件虽然没有自己的data，但是上面的父组件样式后面包含了父组件data属性选择器，所以还是无法作用到子组件上
6. 那么当我们想在父组件内修改子组件里的其它元素时，就必须使用样式穿透`:deep()`语法，下面来看看使用了样式穿透语法会发生什么：
```js
// 父组件内
<style scope>
::v-deep(.child-name .inner) {}
</style>
```
上面的代码打包后会变成 `[data-v-父组件data] .child-name .inner`，表示在全局样式中对父组件下级的这个样式进行操作，不加样式穿透是`.child-name .inner[data-v-父组件data]`，不加是对这个样式进行限定，加了是操作这个data的下级元素，两者有明显的区别。
7. 其实就是vue不会给添加深度选择器的class添加限定data，但是仍然还是会有一定的限定，因为最后生成的是 `[data-v-父组件data] .child-name .inner`，而不是 `.child-name .inner`，还是限定了在父组件下的 `.child-name .inner` 才生效，而不是所有的 `.child-name .inner` 都会生效，相当于只是把子组件的这个样式提升了一级，到了父组件可以选择，而不是提到了全局都可以选择。
8. 掌握这个，可以解决的问题是，很多时候我们引入外部子组件，我们不好修改子组件的内部样式，就可以用深度选择器在父组件内操作，即使是自己写的可以操作的子组件，这样写也可以根据不同的父组件，给同一个子组件定制不同的样式。