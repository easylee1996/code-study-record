---
创建时间: 2023-11-17T16:35
更新时间: 2023-11-24T09:03
---
在vue中，组件如果需要css样式隔离，只需要给组件的style标签上添加 `scoped` 属性，就可以实现样式隔离，否则组件内的样式是添加到全局css里面的。

在添加了样式隔离之后，vue的具体做法如下：

1. 给组件的最顶层元素添加一个完全独立的data属性，然后就可以根据不同组件的不同data来区分样式；
2. 在scoped里面的样式，**所有选择器后面都会添加上这个data属性**，表示这个样式独属于这个组件，其它组件不会引用这些样式；

同时需要注意：

1. 子组件最顶层元素会继承父组件的data，比如父组件设置了scoped，子组件的最顶层元素(vue3中是第一个元素，vue3中可以不设置最外层包裹元素)也会设置相同的data，根据这个，可以直接在父组件设置子组件最顶层div的样式，实现父组件设置子组件样式。
2. 如果子组件也设置了scoped，那么这个子组件就拥有两个data属性，一个父级的，一个自己的。

下面来看一下，在添加了样式隔离之后，有时候会出现无法给指定元素设置样式，比如第三方组件element的弹窗组件：

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

stylus的样式穿透使用`>>>` sass和less的样式穿透使用`/deep/`，以及vue自带的 `:deep(xxx)`

添加穿透代码之后，会将样式变为 `[data-v-xxxx] .el-dialog__body`，前面的data属性是当前组件的，也会是dialog子组件最顶层元素的，然后再找下面的el-dialog__body元素，那就找得到了，而不是像之前直接在当前组件内找。

```xml
<style scoped>
:deep(.el-dialog__body) {
  xxxx
}
</style>
```

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

具体原因再理一下：

添加scoped之后，父组件的所有样式class都会加上[data-v-xxxx]，子组件的顶层元素也会加上相同的[data-v-xxxx]，但是子组件内部的元素不会加，因为比如element类似的子组件，就算element类似的子组件添加了scoped，那么也会是一个新的data，其里面的class会加上这个新的data，所以父组件是无法直接操作子组件的内部其它元素的。

所以要使用样式穿透，穿透之后等于样式变成了 `[data-v-xxxx] .el-dialog__body`，也就是操作子组件下级的样式，而不是父组件里面的样式。

来看一个例子：

```vue
// 父组件
<template>
  <div class="app">
    <show-names></show-names>
  </div>
</template>

<style lang="less">
.show-names {
  background-color: #000;

  .inner-class {
    font-size: 200px;
  }
}
</style>

// 子组件
<template>
  <div class="show-names">
    <div class="inner-class">33333333</div>
  </div>
</template>
<style scoped></style>
```

上面的子组件字体会设置为200px，但是父组件设置了scoped之后，就不会生效了

```
// 父组件
<template>
  <div class="app">
    <show-names></show-names>
  </div>
</template>

<style lang="less" scoped>
.show-names {
  background-color: #000;

  .inner-class {
    font-size: 200px;
  }
}
</style>

// 子组件
<template>
  <div class="show-names">
    <div class="inner-class">33333333</div>
  </div>
</template>
<style scoped></style>
```

上面的代码会在渲染之后添加如下样式：

```vue
// data-v-7a7a37b1是父组件的data，也是子组件顶层元素的data，但是父组件里面可没有.inner-class，所以不生效，除非是.show-names[data-v-7a7a37b1] .inner-class
.show-names .inner-class[data-v-7a7a37b1] {
  font-size: 200px;
}
```

改成样式穿透之后，才可以生效，相当于给子组件里面的样式设置样式，而不是给父组件里面的inner-class设置，父组件根本没有这个元素

```vue
// class变成了.show-names[data-v-7a7a37b1] .inner-class
.show-names {
  :deep(.inner-class) {
    font-size: 200px;
  }
}
```

**核心原因是：在父组件中设置样式，所有class都会添加上父组件的data，父组件又没有这个元素，所以无法识别，子组件有自己的data，子组件内部元素又自己的，所以父级设置的是带父级data的样式，肯定影响不了子级的，样式穿透之后，将子组件内部的class的data去掉了(子组件顶层元素没去)，所以能够生效(父组件设置的任何css都是在父组件文件内)**

同时element还有一些组件会直接放置在index.html里面和#app同级，这种也许要设置样式穿透或者设置为全局css，否则无法生效，原因同样，组件加上data只会给当前组件设置，这些元素都不在组件内，肯定无法给它设置样式。

简单来说：给一个子组件的最顶层元素添加样式，则直接在父组件中给子组件顶层元素的class进行操作即可，因为子组件顶层class会赋值父组件相同的data，而要给子组件的内部其它class设置，则需要使用 `:deep()`,因为子组件也设置了 `scoped` , 子组件里面的class会赋值子组件的data，不用深度css，无法添加到子组件其它class之上