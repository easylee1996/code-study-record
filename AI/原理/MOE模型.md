![[CleanShot 2024-08-16 at 11.39.54.png]]
### MOE
创建多个领域的专家模型，针对不同的问题，由Router模型来选择更适合的experts，这些experts model包含共享公用的部分和自己擅长的特有部分参数。
比如Mistral 8x7B，就是8个7B的exports model，理论上一改是56B，但实际没有这么大，因为有共享的参数。
sparse MOE：会并行询问多个exports model，返回最佳答案，资源耗费会很大，是一种方式，比如上面Router模型，可以设置选择Top k个model，超过1个，那就是采用了sparse稀疏的方式。
![[CleanShot 2024-08-16 at 11.48.11.png]]
>据传言：GPT4也是采用MOE的架构。


