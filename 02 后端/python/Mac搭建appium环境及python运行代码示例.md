Appium主要是通过调用安卓提供的接口来执行命令的，所以需要安装Java和安卓SDK。
### 1.安装Appium服务端
appium的服务端是基于node的，直接使用npm(node包管理器)安装即可，比较简单。
```shell
npm install -g appium
```

### 2.安装Python客户端
```shell
pip install Appium-Python-Client
```

同样直接使用pip安装即可。
### 3.安装Java环境
```shell
brew tap AdoptOpenJDK/openjdk

brew install adoptopenjdk8
```
配置环境变量
```shell
JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
 CLASS_PATH="$JAVA_HOME/lib"
 PATH=".$PATH:$JAVA_HOME/bin"
 export PATH=/usr/local/bin:$PATH
 ```

### 4.安装安卓SDK
```shell
brew install --cask android-platform-tools
```
配置环境变量：
```shell
export ANDROID_HOME=/Users/xxx/Library/Android/sdk
```
其中xxx为用户名。
完成之后，将安卓手机连接到电脑，注意手机的开发者权限之类的全部开启。
然后执行 `adb devices`，可以显示设备，则安装成功。
> 其实通过brew安装的软件默认在命令行是可以直接打开不用配置环境变量的，因为brew设置了软链接，但是appium的服务无法读取到，所以上面还是需要配置一下。

### 5.连接测试
根据上面的配置之后，环境基本安装完毕，下面来测试一下，首先启动appium服务端。
命令行执行：appium，出现欢迎界面则没有问题。
主要是测试一下 Appium Inspector，这个是Appium提供的查看手机app元素以及其它功能的桌面软件，可以大大提升开发效率。
下载打开这个软件，远程主机、端口、路径都使用默认不填即可，主要填一下右下角的 JSON Representation：
```json
'platformName': 'Android', # 被测手机是安卓 
'automationName' : 'UiAutomator2',
'appPackage': 'tv.danmaku.bili', # 启动APP Package名称 
'appActivity': '.ui.splash.SplashActivity', # 启动Activity名称 
'unicodeKeyboard': True, # 使用自带输入法，输入中文时填True 
'resetKeyboard': True, # 执行完程序恢复原来输入法 
'noReset': True, # 不要重置App 'newCommandTimeout': 6000, 
```
填上最前面的platformName和automationName就可以，其它都是选配。
### 6.python代码测试
执行官网的python示例代码：
```python
import unittest

from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy

capabilities = dict(
    platformName="Android",
    automationName="uiautomator2",
    deviceName="Android",
    appPackage="com.android.settings",
    appActivity=".Settings",
)

appium_server_url = "http://localhost:4723"


class TestAppium(unittest.TestCase):
    def setUp(self) -> None:
        self.driver = webdriver.Remote(
            appium_server_url,
            options=UiAutomator2Options().load_capabilities(capabilities),
        )

    def tearDown(self) -> None:
        if self.driver:
            self.driver.quit()

    def test_find_battery(self) -> None:
        el = self.driver.find_element(by=AppiumBy.XPATH, value='//*[@text="电池"]')
        el.click()


if __name__ == "__main__":
    unittest.main()
```
成功则表示正常连接