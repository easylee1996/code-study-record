软件下载：云盘-软件-appium
环境配置：
```py
JAVA_HOME   d:\tools\java\jdk1.8.0_211
```

环境变量 `ANDROID_HOME` ，设置值为 sdk 包解压目录，比如 `d:\tools\androidsdk`

还推荐大家配置环境变量 PATH ，加入 adb 所在目录， `d:\tools\androidsdk\platform-tools\`

查看连接设备：
`adb devices -l`

查找应用信息：
```py
adb shell dumpsys activity recents | find "intent= {"
```
cmp 后面是应用信息
```bash
cmp=tv.danmaku.bili/.ui.splash.SplashActivity
```
打开要查看的应用，再执行，就会排前面

如果只是一个 apk 文件还没安装：
```
d:\tools\androidsdk\build-tools\29.0.3\aapt.exe dump badging d:\tools\apk\bili.apk | find "package: name="
```

### ui 查看工具
最常用的就是 Android SDK 中的工具 `uiautomateviewer` ，它在 SDK 目录目录的 tools\bin 目录中

Appium Inspector 参数设置

```json
{
  "platformName": "Android",
  "platformVersion": "12",
  "deviceName": "XXX",
  "appPackage": "com.taobao.mobile.dipei",
  "appActivity": "com.koubei.kbc.app.ui.activity.LaunchRiverActivity",
  "unicodeKeyboard": true,
  "resetKeyboard": true,
  "noReset": true,
  "newCommandTimeout": 6000,
  "automationName": "UiAutomator2"
}
```

Python 示例代码
```python
from appium import webdriver 
from selenium.webdriver.common.by import By 
from appium.webdriver.extensions.android.nativekey import AndroidKey 
desired_caps = { 
				'platformName': 'Android', # 被测手机是安卓 
				'platformVersion': '8', # 手机安卓版本 
				'deviceName': 'xxx', # 设备名，安卓手机可以随意填写 
				'appPackage': 'tv.danmaku.bili', # 启动APP Package名称 
				'appActivity': '.ui.splash.SplashActivity', # 启动Activity名称 
				'unicodeKeyboard': True, # 使用自带输入法，输入中文时填True 
				'resetKeyboard': True, # 执行完程序恢复原来输入法 
				'noReset': True, # 不要重置App 
				'newCommandTimeout': 6000, 'automationName' : 'UiAutomator2' 
				#'app': r'd:\apk\bili.apk', 
} 
# 连接Appium Server，初始化自动化环境 
driver = webdriver.Remote('http://localhost:4723/wd/hub', desired_caps) 
# 设置缺省等待时间 
driver.implicitly_wait(5) 
# 如果有`青少年保护`界面，点击`我知道了` 
iknow = driver.find_elements(By.ID, "text3") if iknow: iknow.click() 
# 根据id定位搜索位置框，点击 
driver.find_element(By.ID, 'expand_search').click() # 根据id定位搜索输入框，点击 
sbox = driver.find_element(By.ID, 'search_src_text') sbox.send_keys('白月黑羽') 
# 输入回车键，确定搜索 
driver.press_keycode(AndroidKey.ENTER) 
# 选择（定位）所有视频标题 
eles = driver.find_elements(By.ID, 'title') 
for ele in eles: 
# 打印标题 
print(ele.text) input('**** Press to quit..') driver.quit()
```