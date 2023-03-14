### 全局对象global

类似window，不包含Bom相关属性

常用属性：

- __dirname：当前文件所在目录
- __filename：当前文件所在目录+文件名
- globalThis：自动识别是node环境还是浏览器环境，切换为对应的全局对象

### Process进程

一旦使用node开启一个进程就会有这个对象，属于global的属性

常用信息：

- process.dev：表示访问项目目录下，.dev文件的内容
- process.argv：表示获取命令行，node启动时，后面添加的参数，也就是输入参数，如：node xxx.js num1-20
- process.nextTick()：下一次Tick时执行

### Node的输入输出

```bash
# 输入参数
node test.js   num1=20 
# 输出参数
console.log(process.argv) 
```