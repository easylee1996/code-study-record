## Beautiful解析器

就是标签和css选择器，可以更方便的提取html



### 安装

```python
# 安装beautifulsoup4
pip install beautifulsoup4

# 安装常用的lxml html解析方式
pip install lxml
```



### 元素获取内容

```python
import requests
from bs4 import BeautifulSoup

# 先获取网页内容
respond = requests.get('https://www.baidu.com')
# 如果文字乱码，设置编码
res.encoding = 'utf-8'
# 使用lxml方式解析网页文档树
soup = BeautifulSoup(res.text, 'lxml')

# 获取标题，不加string就是包含<title>标签
print(soup.title.string)

# 获取p标签
print(soup.p.string)

# 获取title的父标签
print(soup.title.parent.name)

# 获取超链接
print(soup.a)

# 获取所有超链接
print(soup.find_all('a'))

# 获取id为link2的元素
print(soup.find(id="link2"))

# 获取网页中所有的内容
print(soup.get_text())
```

`常用方法`

```python
# 元素和class同时匹配，注意此时的bar是模糊匹配的，class是关键字后面要加_
soup.find('tr',class_='bar')

# 不能使用select + find_all
soup.select('xxx').find_all('li')

# 只能是find + find_all连用,所以才有了find class_的用法
soup.find(class_='bar').find_all('li')
```



### css获取内容

使用 select 方法

```python
soup = BeautifulSoup(html_doc,'lxml')
print(soup.select("title"))
print(soup.select("body a"))
print(soup.select("p > #link1"))
```

`常用方法`

```python
# 元素和class同时匹配，此时bar是精确匹配的
soup.select('td[class="bar"]')
```



### 获取标签属性内容

```python
# 先获取到标签，然后用get获取属性名
item_img = item.find('a').find('img').get('src')
```



### 进一步了解，可以查看文档

https://www.crummy.com/software/BeautifulSoup/bs4/doc/