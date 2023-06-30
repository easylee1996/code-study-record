#todo
- [x] ChatGPT介绍
- [x] ChatGPT Plugins介绍
- [x] langchain框架介绍
- [x] 本地知识库代码演示
- [x] 完整版本langchain的搜索框演示 "how to use chunksize"
- [x] ChatGPT近期热点

## ChatGPT介绍

![[CleanShot 2023-06-27 at 17.45.08.gif]]

目前广泛使用的模型是gpt-3.5-turbo(优化版)和ChatGPT4.0

使用gpt-3.5-turbo免费，使用ChatGPT4.0则需要开通ChatGPT Plus付费订阅计划，20$/月

同时使用ChatGPT API KEY，价格$0.003/1K tokens，开放gpt-3.5-turbo模型，如果需要gpt-4模型，必须先开通Plus会员，同时还需要加入[Join API waitlist](https://openai.com/waitlist/gpt-4-api)等待。

### 其它大语言模型
- Bard: 谷歌
- Claude: 前OpenAI Cofounded 创建的，用起来不错，而且还推出了Claude-instant-100k版本，支持100k tokens(大约75000字)的上下文，可以实现直接一次输入一篇论文。
- 文心一言
- 通义千问: 阿里云
- ChatGLM-6B: 清华大学KEG实验室和智谱AI联合开源的，支持本地运行，部署非常简单，最低只需6G显存就能跑，上周25号，推出了ChatGLM2-6B第二代，提供了更强大的性能和上下文支持，目前很多框架对ChatGLM提供了支持。[GitHub - THUDM/ChatGLM2-6B: ChatGLM2-6B: An Open Bilingual Chat LLM | 开源双语对话语言模型](https://github.com/THUDM/ChatGLM2-6B)
![[web-demo.gif]]
## ChatGPT Plugins介绍

[ChatGPT plugins](https://openai.com/blog/chatgpt-plugins)

[OpenAI Platform](https://platform.openai.com/docs/plugins/introduction)

ChatGPT Plugins是OpenAI推出的插件服务，目前官方提供语言翻译、句法分析、图像识别等插件，通过API，可以根据自己的需求来进行插件开发。

	API中的几个核心概念

- prompts: 关键词，在大语言模型中，Prompt 可以被理解为一种启动机器学习模型的方式，它是一段文本或语句，用于指导机器学习模型生成特定类型、主题或格式的输出，比如questions。
- Embeddings: 自然语言映射技术，可以将文本中的单词或短语转换为计算机可以理解的向量形式，存储于向量数据库中。狗、烤肠
- Tokens: 将文本拆分为机器可处理的基本单位，比如一个单词、一个符号。

## langchain框架介绍

大语言模型框架，使用大语言模型的一层协议，定义了一系列标准，理论上可以支持任意大语言模型，使得AI开发更简单。

简单看一下langchain带来的一些标准：[Welcome to LangChain | 🦜️🔗 Langchain](https://js.langchain.com/docs)

以本地知识库插件为例，简单介绍一下使用langchain开发问答插件的原理：
![[Pasted image 20230627193155.png]]
## 本地知识库代码演示

ChatGPT帐号
用户名：`rg.a.dgn.03285.3.128@gmail.com`
密码：`$5166AFRe`
OPENAI_API_KEY：`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`

导入本地文档
![[CleanShot 2023-06-28 at 13.37.29@2x.png]]
查看效果
![[CleanShot 2023-06-28 at 13.38.53@2x.png]]
存入向量数据库中
![[CleanShot 2023-06-28 at 14.30.19@2x.png]]
基于本地知识库ChatGPT响应结果
![[CleanShot 2023-06-28 at 15.05.10@2x.png]]
ChatGPT原生结果
![[CleanShot 2023-06-28 at 15.06.17@2x 1.png]]

## ChatGPT近期热点

[https://twitter.com/soumithchintala/status/1671267150101721090](https://twitter.com/soumithchintala/status/1671267150101721090)
深度学习框架 PyTorch 创始人之一 Soumith Chintala
![[CleanShot 2023-06-27 at 19.54.53@2x.png]]

![[CleanShot 2023-06-27 at 19.52.03@2x.png]]