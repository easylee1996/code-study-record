## 相关概念
### sass
Sass是一种预处理器脚本语言，可以解释或编译成层叠样式表（CSS）。

Sass包含两种语法：较旧的语法使用缩进将代码块和换行符分隔为单独的规则；较新的语法SCSS使用像CSS这样的块格式。它使用大括号来表示代码块和分号来分隔块中的行。

缩进语法和SCSS文件传统上分别给出扩展名.sass和.scss

### node-sass
Node-sass是一个库，它将Node.js绑定到LibSass（流行样式表预处理器Sass的C版本）。它允许用户以令人难以置信的速度将.scss文件本地编译为css，并通过连接中间件自动编译。

### sass-loader
sass-loader 是一个webpack 的loader，用于处理项目中的Sass/SCSS 文件。 它的作用是将Sass/SCSS 代码转换成CSS 代码，并将其注入到应用程序中。

## 兼容问题
在安装node-sass的过程中，经常会出现兼容问题，导致安装失败，通常是由于node版本、node-sass版本、sass-loader版本不对应导致。
下面是一些推荐的版本对应规则：

首先是node和node-sass的版本对应规则：[node-sass - npm](https://www.npmjs.com/package/node-sass)

|NodeJS|Supported node-sass version|Node Module|
|---|---|---|
|Node 20|9.0+|115|
|Node 19|8.0+|111|
|Node 18|8.0+|108|
|Node 17|7.0+, <8.0|102|
|Node 16|6.0+|93|
|Node 15|5.0+, <7.0|88|
|Node 14|4.14+, <9.0|83|
|Node 13|4.13+, <5.0|79|
|Node 12|4.12+, <8.0|72|
|Node 11|4.10+, <5.0|67|
|Node 10|4.9+, <6.0|64|
|Node 8|4.5.3+, <5.0|57|
|Node <8|<5.0|<57|

然后是node-sass和sass-loader的对应规则：

sass-loader 4.1.1，node-sass 4.3.0
sass-loader 7.0.3，node-sass 4.7.2
sass-loader 7.3.1，node-sass 4.7.2
sass-loader 7.3.1，node-sass 4.14.1
sass-loader 10.0.1，node-sass 6.0.1

> 上面是部分对应规则，首先根据node版本确定好node-sass的版本，然后再选择node-sass的版本。
> 同时上面只是一部分sass-loader的版本对应，因为没有提供官方的对应规则，所以上面的版本还是不对的话，确定好node和node-sass版本之后，可以一个一个尝试sass-loader的版本，所有版本：[sass-loader - npm](https://www.npmjs.com/package/sass-loader?activeTab=versions)

## 其它说明
1. 出现兼容问题的主要原因在于，早期开发人员使用比如node12版本，安装node-sass4+版本和sass-loader4+，可以正常运行，但是后期开发人员使用了更新的node，比如16，而16不支持低版本node-sass。
2. 同时即便切换到低版本node12中可以正常运行，但项目中使用了一些node12以上的代码语法，比如node14才支持的可选链语法，然后其它开发人员拉代码之后，就要么高版本node无法拉取node-sass包，要么切换低版本无法运行一些高版本node才支持的语法。
3. 推荐还是使用高版本的node，然后升级node-sass和sass-loader版本。

## 其它方法
直接放弃node-sass，使用dart-sass无缝替换。
node-sass与dart-sass区别：
1. node-sass 是用 node (调用 cpp 编写的 libsass) 来编译 sass。
2. dart-sass 是用 drat VM 来编译 sass。
3. node-sass 是实时自动编译的，dart-sass 需要保存后才会生效。
3. 推荐 dart-sass 性能更好（也是 sass 官方使用的），除了上面的版本对应不上，很多时候node-sass还因为国情问题经常装不上。

下面是切换方法，使用高版本node，然后根据下面操作：
1、卸载 node-sass
```scss
npm uninstall node-sass
```

2、安装 dart sass
```scss
npm install sass sass-loader -D
```

3、将项目中原有的 **/deep/** 替换为::v-deep，也就这一步麻烦一些，具体需要个人评估。