### nohup 后台运行某个服务
`nohup python index.py > backend.log 2>&1 & exit`
`2>&1` 表示将标准错误（stderr）重定向到标准输出（stdout），这样所有的输出都会被重定向到同一个文件中，最后的 `& exit` 表示立即进入后台执行，如果不加这个，实际上nohup还是会和前台执行命令的效果差不多，关闭窗口就会停止服务
### 查看服务ss
常用命令：`ss -tulnp` 其中p为pid
通常配置停止服务命令：`kill -9 pid` `-9` 为强制终止