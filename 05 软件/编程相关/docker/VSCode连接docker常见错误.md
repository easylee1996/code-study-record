1.在配置完docker之后，尝试使用vscode的docker插件连接进容器时，docker插件无法正常显示容器信息，报错Error: permission denied while trying to connect to the Docker daemon socket at unix。这是因为在docker容器内的vscode插件权限不足，可以为docker插件设置权限解决。
```text
sudo chmod 666 /var/run/docker.sock
```