这里的配置是针对后端为Chrome浏览器，使用浏览器运行代码，然后前端使用VSCode Debug进行调试的配置，如果后端是Node之类的，是另外的配置。
创建调试配置文件：
1. 根目录.vscode/launch.json，VSCode可以直接生成基础配置
2. 启动要运行的代码服务，然后启动调试，会打开浏览器来执行后端，也就是JS运行时，启动chrome或者node才拥有这个websocket服务，才可以给前端推送数据，然后在vscode中进行调试

基础配置示例：
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch", // 请求方式
      "type": "chrome", // 启动类型
      "url": "http://localhost:3000", // 启动浏览器打开的项目地址，不是后端ws服务地址
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```
## launch/attach启动方式配置
调试就是浏览器跑起来，访问目标网页，同时启动调试服务，然后前端通过ws客户端连接上这个服务，就可以开始调试。
launch就是打开浏览器，同时启动调试服务，通常使用这个请求方式即可
而attach则是已经手动提前打开了调试服务，连接已有的调试服务进行调试
attach基础配置如下
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "attach",
      "port": 9222, // 调试服务的端口
      "type": "chrome",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```

手动打开调试服务，需要在启动浏览器的同时指定调试端口，然后才可以根据这个端口连接调试服务，直接打开浏览器，默认是没有端口的，因为默认谷歌的调试工具使用的是全局函数进行调试。
```
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --user-data-dir=你自己创建的某个目录
```
## 其它参数配置
上面的命令还包含一个 `userDataDir`参数，表示用户数据目录，不填表示浏览器默认目录
同时，还可以在参数中设置：
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "type": "chrome",
      "userDataDir": true, // 默认true，创建临时目录，false表示使用系统默认目录，还可以直接设置一个指定的目录
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```
为何需要指定这个呢？
用户数据目录里面包含了用户书签，插件等数据，但是一个目录只允许启动一个chrome实例，要启动多个chrome浏览器实例，就必须设置不同的用户目录，但设置了新的用户目录之后，又无法使用默认的书签和插件数据了，无法做到同时正常使用浏览器和打开调试窗口，下面是解决方法。
安装 chrome canary版本，这个是专门用于调试的每日更新版本，添加如下配置即可：
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "runtimeExecutable": "canary", // 配置浏览器
      "type": "chrome",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```

除此之外，下面也是一些常用参数：
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "runtimeArgs": [
        "--auto-open-devtools-for-tabs", // 启动后自动打开浏览器调试工具
        "--incognito" // 启动无痕模式，不加载插件，没有登录状态
      ],
      "type": "chrome",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
```
## sourceMapPathOverrides
浏览器调试模式默认是开启sourceMaps功能的，关闭可以在调试工具配置中进行修改，也可以在vscode配置文件中添加，`"sourceMaps": false`进行关闭
sourceMaps其实就是将打包后的文件和本地文件进行映射，比如打包后的 `/static/bundle.js` 映射到项目目录中的具体文件 `/src/index.js`，这些都是通过sourcemap文件保存的，但是有的文件找不到本地文件目录，无法正确映射，这时候文件在调试中就变为只读了，我们需要自己来进行映射配置：
```json
{
  "configurations": [
    {
      "sourceMapPathOverrides": {
        "meteor://app/*": "${workspaceFolder}/*",
        "webpack:///./~/*": "${workspaceFolder}/node_modules/*",
        "webpack://?:*/*": "${workspaceFolder}*" // ${workspaceFolder} 开头的本地路径映射成了 webpack:// 开头的路径传给浏览器
      }
    }
  ]
}
```
上面配置将webpack的文件和meteor的文件，通过正则匹配到本地的文件上，通常sourceMaps无法生效时可以尝试上面的配置。
## file
有时候想直接调试一个静态文件，可以通过下面的配置
```json
{
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "type": "chrome",
      "file": "${workspaceFolder}/index.html", // 静态文件地址
      "webRoot": "${workspaceFolder}", // 配置 "/" 指向项目跟目录
      "pathMapping": {
        "/static/js/": "${workspaceFolder}/src/"
      } // 配置/static/js下面的文件映射到项目目录下的src，这样实现和上面相同的配置，不使用sourceMapPathOverrides，是因为静态文件是没有sourceMaps的
    }
  ]
}
```