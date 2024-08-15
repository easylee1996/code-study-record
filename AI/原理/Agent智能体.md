Agent智能体就是llm+tools，就像人一样，当完成各种工作的时候，也需要具体的工具来完成。
这里的工具可以是封装的函数、外部api等。
agent可以根据用户的问题，自己拆分完成的步骤，然后在不同步骤调用不同的工具(提前传入的工具列表)。
agent和chain工作流最大的区别在于，chain是我们提前人为设置好流程的，而agent则是由llm自己来决定完成任务的步骤。
## 常见agent
### ReAct
Reason + Act，拿到结果再进行动作，不断循环，也就是上面简介介绍的方式，这是最常用的。
paper addr：[ReAct: Synergizing Reasoning and Acting in Language Models](https://react-lm.github.io/)
### HuggingGPT
常见的multi-agent
paper addr：[[2303.17580] HuggingGPT: Solving AI Tasks with ChatGPT and its Friends in Hugging Face]( https://arxiv.org/abs/2303.17580 )
### 斯坦福小镇
![[CleanShot 2024-08-15 at 10.11.01.png]]
github：[GitHub - joonspk-research/generative\_agents: Generative Agents: Interactive Simulacra of Human Behavior](https://github.com/joonspk-research/generative_agents)
paper：[[2304.03442] Generative Agents: Interactive Simulacra of Human Behavior](https://arxiv.org/abs/2304.03442)


















