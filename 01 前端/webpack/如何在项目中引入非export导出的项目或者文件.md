---
创建时间: 2023-12-05T08:55
更新时间: 2023-12-05T08:57
---
Vue引入非npm的js库
Vue项目有时候需要一些没有export的js库，不能通过import引入，那么使用方法如下

1.可以在index.html页面使用script标签引入，当然也可以使用cdn的地址。

```html
  <!DOCTYPE html>
  <html>
    <head>
      <title>Map</title>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width,initial-scale=1.0">
      <link rel="shortcut icon" type="image/x-icon" href="./static/img/favicon.ico"/>
      <script src='./static/libs/three/three.min.js'></script>
      <script src="./static/libs/three/GLTFLoader.js"></script>
   </head>
   <body>
     <div id="app"></div>
     <!-- built files will be auto injected -->
   </body>
 </html>
```

2.在main.js中使用window.moduleName 使用
也可以放入Vue.prototype中，这样组件内都可以使用。
```js
 var THREE = window.THREE
 var GLTFLoader = THREE.GLTFLoader
 Vue.prototype.THREE = THREE
```