1.首先要明确，在python中，导入模块时，路径都是相对于启动运行的那个文件，而不是具体编写代码的文件。
2.模块查找路径都是由 `sys.path` 里面决定的。
3.当我们运行一个文件，这个文件所在的目录会自动加入到sys.path中
常见情况：
![[CleanShot 2024-08-03 at 13.48.09@2x.png]]
比如上面的目录，项目根目录包含了前端和后端，后端根目录为backend，utils下存在一个tools.py
1.情况1：运行根目录的index.py，代码里面引入utils下面的tools模块，直接utils.tools相对即可，这个路径是相对于启动文件的路径，正常运行
2.情况2：运行tools.py，代码里面引入了llm.py，代码是 `from llm import xxx` 当直接运行tools.py，正常运行，只是简单的相对路径
但是当我们运行index.py作为运行文件，里面引入了tools.py时，tools.py就会找不到llm，因为从根目录直接找llm是找不到的，路径都是相对于运行文件目录的
3.情况3：将tools.py改写为 `from utils.llm import xxx` 这样运行index.py不会有问题，但是如果直接运行tools.py又会找不打，因为utils目录下没有utils目录
理论上，我们每次启动都启动后端根目录的运行文件index.py，然后书写路径代码都相对于这个文件，就不会有问题，但是如果我们想调试一个内部的子文件，就运行不起来，不方便。
## 最佳实践
1.所有文件的路径，都必须相对于后端根目录下的入口文件来书写，最好不要包括backend这一层根目录目录名(pycharm中可以运行，因为这个目录会被pycharm加入到sys.path中)，因为这个名字很可能随时修改，并且虽然是一个前后端项目，但是用户可能直接打开后端目录作为工作目录，那样就找不到路径了，所以代码一定要相对于后端根目录定位
2.然后每次都通过入口文件进行启动即可
3.下面处理直接运行内部文件的报错，根据上面的sys.path理论，我们需要将backend这个目录添加到sys.path中，这样无论直接运行哪个文件，都不会报错
### vscode
根目录添加 .vscode -> settings.json
```json
{
//linux: terminal.integrated.env.linux，添加到zshrc或者其它终端配置即可
  "terminal.integrated.env.osx": {
    "PYTHONPATH": "${workspaceFolder}/backend"
  }
}
// 如果整个工作目录只有后端代码
{
  "terminal.integrated.env.osx": {
    "PYTHONPATH": "${workspaceFolder}/"
  }
}
```
也可以直接配置到vscode配置文件setting.json中
```json
  "terminal.integrated.env.osx": {
   "PYTHONPATH": "${workspaceFolder}/"
  },
```
因为我们项目是包含前后端的，所以要加/backend，否则直接在根目录下找是找不到utils等文件夹的
### pycharm
默认会添加整个项目根目录到sys.path，同样因为我们的项目包含前后端，直接找不到utils，所以也需要将后端根目录backend添加，python interpreter ->
![[CleanShot 2024-08-03 at 14.06.40@2x.png]]
![[CleanShot 2024-08-03 at 14.07.05@2x.png]]
## 推荐
1.当存在前后端的整体项目时：需要手动设置后端目录为后端代码运行查找目录
2.当只有后端python时：直接使用vscode的统一设置即可
3.明白了上面的路径查找原理之后，虽然可以在配置后直接根目录运行，但仍然推荐切换到前后端项目根目录再运行，这样可以避免绝大多数烦恼(运行的目录不对，很多代码无法正确运行和找到目录)
vscode配置：
右上角配置，在文件的目录运行，而不是根目录，当然可以直接cd，然后命令运行
![[CleanShot 2024-08-03 at 16.05.23@2x.png]]
调试配置，在对应的后端开始运行，cwd参数
```json
{
  // cwd: 开始运行的目录
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python Debugger: FastAPI",
      "type": "debugpy",
      "request": "launch",
      "module": "uvicorn",
      "args": ["index:app", "--reload"],
      "jinja": true,
      "cwd": "${workspaceFolder}/backend"
    }
  ]
}
```