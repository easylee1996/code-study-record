## 注意事项
1.安装时，oneapi使用0.6.6版本，否则不支持stream=true，等待更新吧
2.oneapi配置新增模型时，连接本地ollama，应该使用 http://host.docker.internal:11434 ，容器内的oneapi才可以连接，当然如果是外部的服务器就无所谓了
3.如果存在多个相同的模型，比如家里公司有多个qwen2:7b，则需要进行重定向配置
![[CleanShot 2024-07-14 at 13.03.12@2x.png]]
其中，在fastgpt的config.json中配置的model应该为这里的模型名称，而不是名称：
![[CleanShot 2024-07-14 at 13.05.30@2x.png]]
4.如果不进行重定向，当fastgpt直接配置qwen2:7b，然后oneapi里面有多个渠道里面都有qwen2:7b，那么会根据外部的渠道优先级或者随机访问（待验证）
5.每次修改配置尽量重启服务，要不然很多东西没生效
6.如果使用sealos在线部署时，请注意fastgpt填写oneapi的地址时要加上 `v1`
7.不熟m3e向量模型时，密钥是`sk-aaabbbcccdddeeefffggghhhiiijjjkkk`