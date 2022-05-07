## Selenium

一个自动化测试工具，通过python，可以自动化的操作浏览器，实现一些如登陆搜索等功能

- 官方文档：[Selenium with Python中文翻译文档 — Selenium-Python中文文档 2 documentation (selenium-python-zh.readthedocs.io)](https://selenium-python-zh.readthedocs.io/en/latest/index.html)

- 浏览器驱动下载：[Microsoft Edge Driver - Microsoft Edge Developer](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/#downloads)

  使用的浏览器版本必须和这个驱动版本匹配



### 基本使用

首先将下载的驱动msedgedriver放到`/usr/local/bin`目录下，就是加入环境变量

```python
# 导入浏览器驱动和服务
from selenium import webdriver

# 生成Edge浏览器
driver = webdriver.Edge()	

# 打开百度
driver.get('https://www.baidu.com/')

# 选择搜索框并点击
driver.find_element('id', 'kw').send_keys('博客园 韩志超')
driver.find_element('id', 'su').click()

driver.quit()
```



### 查找元素

```python
# 类似这样的方法在新版本中都被废除了
driver.find_element_by_class_name

# 应该统一是用find_element
driver.find_element()

# 统一使用By方法来确定查找的类型，比较方便
from selenium.webdriver.common.by import By

driver.find_element(By.XPATH, '//button[text()="Some text"]')
driver.find_elements(By.XPATH, '//button')

# By有八种类型
By.ID = "id"
By.XPATH = "xpath"	# xpath路径在浏览器中复制，元素上右键复制
By.LINK_TEXT = "link text"
By.PARTIAL_LINK_TEXT = "partial link text"
By.NAME = "name" # a标签文本属性定位
By.TAG_NAME = "tag name"
By.CLASS_NAME = "class name" # a标签部分文本属性定位
By.CSS_SELECTOR = "css selector"
```



### 页面等待

等待页面和元素加载后再进行

```python
# 导入需要的模块
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait

# 具体等待的类型结构
from selenium.webdriver.support import expected_conditions as EC

# 支持的结构类型
- title_is - title_contains - presence_of_element_located - visibility_of_element_located - visibility_of - presence_of_all_elements_located - text_to_be_present_in_element - text_to_be_present_in_element_value - frame_to_be_available_and_switch_to_it - invisibility_of_element_located - element_to_be_clickable - 显示并可用. - staleness_of - element_to_be_selected - element_located_to_be_selected - element_selection_state_to_be - element_located_selection_state_to_be - alert_is_present

# 常用结构
presence_of_element_located # 元素加载
element_to_be_clickable # 按钮可点击

# 使用方法
WAIT = WebDriverWait(driver, 10)	# 绑定浏览器，10毫秒判断一次
try:
    WAIT.until(EC.presence_of_element_located((By.CSS_SELECTOR, "#banner_link > div > div > form > input")))
finally:
    driver.quit()
```



### 常用方法

拿到元素后做的一些操作

```python
# input元素搜索 清除
element.send_keys("some text")
element.clear()

# 获取html内容，然后用beautifulsoup等来获取具体的内容
driver.page_source

# 重新刷新当前页面
driver.refresh()

# 点击按钮 提交
element.submit()

# 获取cookies
driver.get_cookies()

# 跳转新窗口后也要加载新窗口

# 跳转到新的窗口
print('跳转到新窗口')
all_h = browser.window_handles
browser.switch_to.window(all_h[1])
get_source()
```



### 更多

如果不想显示浏览器，可以尝试Headless Chrome，在命令行中使用谷歌浏览器进行上面的操作