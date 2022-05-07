## requests请求库

在urllib基础上更方便使用一些的request请求库



### 安装

```python
pip install requests
```



### 基本命令

- get请求

```python
r = requests.get('https://api.github.com/events')
```

- post请求

```python
r = requests.post('https://httpbin.org/post', data = {'key':'value'})
```

- 携带参数

```python
payload = {'key1': 'value1', 'key2': 'value2'}

r = requests.get('https://httpbin.org/get', params=payload)
```

- 设置请求头

```python
url = 'https://api.github.com/some/endpoint'

headers = {'user-agent': 'my-app/0.0.1'}

r = requests.get(url, headers=headers)
```



### 获取响应

```python
# 文本响应
r.text

# 字节响应
r.content

# 响应码
r.status_code

# 响应头
r.headers

# json响应
r.json()

# socket流响应
r = requests.get('https://api.github.com/events', stream=True)
r.raw
r.raw.read(10)
```



### 其它命令

```python
# 请求时用json作为参数
r = requests.post(url, json=payload)

# 上传文件
files = {'file': open('report.xls', 'rb')}
r = requests.post(url, files=files)

# 获取cookies信息
r.cookies['example_cookie_name']

# 设置超时
requests.get('https://github.com/', timeout=0.001)
```

