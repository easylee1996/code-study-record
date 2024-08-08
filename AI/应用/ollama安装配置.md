## 自动安装
```shell
curl -fsSL https://ollama.com/install.sh | sh
```
通常如果网络不行，安装不了，所以推荐手动安装
## 手动安装
1.下载应用文件
```shell
sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama
sudo chmod +x /usr/bin/ollama
```
2.创建服务
`vim /etc/systemd/system/ollama.service`
```yaml
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/project/ruanjian/ollama serve
User=ruanjian
Group=ruanjian
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_ORIGINS=*"
Environment="OLLAMA_MODELS=/project/ruanjian/.ollama"

[Install]
WantedBy=default.target
```
请注意修改里面的：
- ExecStart应用地址
- User和Group用户组
- 三个环境变量：分别是局域网访问、跨域限制和模型下载位置

3.启动服务
```shell
# 重载配置文件
sudo systemctl daemon-reload
# 开机启动
sudo systemctl enable ollama
# 启动服务
sudo systemctl start ollama
```

4.如果不想使用服务的形式，也可以每次直接启动
```shell

# 启动前手动配置本次启动需要的环境变量
export OLLAMA_HOST=0.0.0.0
export OLLAMA_ORIGINS=*
export OLLAMA_MODELS=/project/ruanjian/.ollama

# 启动服务
./ollama serve
```

## 默认模型下载位置
如果上面没有配置模型下载位置，那么就是在下面的默认位置
```shell
# ubuntu 模型位置
~/.ollama/models

# mac位置和ubuntu一样
~/.ollama/models

# 其它linux
/usr/share/ollama/.ollama/models
```