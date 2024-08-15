## 基础RAG原理
![[CleanShot 2024-08-13 at 11.14.58.png]]
上图中可能出现的问题：
1.数据清洗：解析文档实际上是特别难的，很多文档是不规则的，存在很多表格，方程，图片等，这个部分实际上存在大量的工作
2.chunk算法：根据token数量，overlap，根据章节切分，这个部分还好，但是需要不断尝试
3.Embedding：一般选用主流的向量方法就好，比如OpenAI的Embedding，这里还要考虑index索引的算法，但是一般来讲选择比较少，就选最通用的即可
4.用户的query：不完整、不准确、很复杂，根据这样的问题，retrieved出来的context，是否足够回复问题，是否存在很多多余的
5.组成prompt的问题：如果context太多，无法全部放入prompt，需要对co ntext进行排序，这里存在大量的排序算法
6.Response：在根据LLM拿到response之后，还需要进行一些post-processing，正确性的检验等
## Query优化-生成query优化
### Case1：获取想要的商品
![[CleanShot 2024-08-13 at 11.49.53.png]]
![[CleanShot 2024-08-13 at 11.50.52.png]]
问题分析：数据库中的商品只有名字进行过embedding，如果将query全部embeding，那么其中的black leather、less than 20 dollars等信息无法retrieved有用的信息，name里面并不包含这些信息。
解决思路：LangChain提供的Self-query，将query中的属性先filter出来，剩余部分再进行embedding和retrieved，就是先将query中的属性进行筛选出来，再进行embedding和retrieved，筛选也很简单，首先设置可以筛选的属性类别的关键词，然后交给大模型去筛选出预设的类别相关关键词即可。

### Case2：比较多个种类的商品的所有功能
![[CleanShot 2024-08-13 at 15.46.20.png]]
问题分析：这种问题直接embedding效果肯定也非常不好，因为在向量数据库中分别存在小米、华为、三星的各种特征和功能，我们知道一句话向量化是分词、词嵌入、再聚合(简单相加、平均等方法)，这里面主体有3个，三个主体的向量位置，和其中某一个品牌的向量位置会存在较大误差，会大大影响召回的效果。
解决思路：LangChain的MultiQueryRetriever，也就是将原本的一个query拆分为多个子query，子query通过知识库以及llm获取结果，再将每个query获取到的结果内容聚合在一起，再传给llm来获取结果。在这个示例中，将query拆分为三个品牌的query。除了这个case，当用户的query模糊或者不够完整时，也可以用这个方法对用户的query进行扩充，然后再使用扩充的query进行llm获取response。

### Case3：Step-Back Prompting
![[CleanShot 2024-08-13 at 16.27.08.png]]
问题分析：如上面的第二个案例，Leopold是否在Aug到Now 1954在哪个学校？知识库中只有几段经历，并没有找到1954的相关内容。
解决思路：退一步，先找到leopold的所有学校经历，获取到所有学校经历后再在这些经历里面来判断用户的query，这样问题和retrieve的复杂度大大降低了，这个方法暂时LangChain还未完整实现。

### Case4：Rag如何更好的处理多轮对话？
![[CleanShot 2024-08-13 at 16.41.30.png]]
问题分析：在进行多轮对话之后，用户再进行对话时，会省略前面已经说过的信息，如果使用这种省略的query来进行信息retrieved，那肯定是不完整的。
解决思路：将历史对话和当前query合在一起并询问llm，生成的answer再进行retrieved，这样retrieved的信息完整度就会大大增加了。这里合并之后询问llm是因为使用answer来进行retrieved比使用问题进行retrieved的效果好得多。

### 其它策略
![[CleanShot 2024-08-13 at 16.48.16.png]]
将query先询问llm，生成一个answer，再将answer和query一起作为context，从vector db中retrieve，这么做考虑的是answer包含了很多query想要的answer信息，这样进行retrieve会包含更多的信息，但效果有待验证。
![[CleanShot 2024-08-13 at 16.51.39.png]]
将一个query使用llm生成多个query，再使用多个query进行retrieve，效果同样有待验证。
## Retriever优化-检索过程优化
### Sentence Window Retrieval
![[CleanShot 2024-08-13 at 16.58.43.png]]
同时取出chunk附近的chunk，当然这样取出的内容多了之后，后续要去进行排序。
### Parent-child chunks retrieval
![[CleanShot 2024-08-13 at 17.12.06.png]]
问题解析：最佳的answer在V2的s中，可能是30个token，但是拆分的时候是500个token进行的chunk拆分，此时正确answer只是chunk的一部分，而且是极小极小的一部分，这产生了很大的误差，使得有可能和V2 chunk相邻的V1 chunk反而成为优先匹配的chunk。
解决思路：将一个500token的chunk拆分为多个小的子chunk，并设置好关联关系，将子chunk存入vector db，然后检索到子chunk之后，将父chunk进行返回，这样做的好处在于通过精确的子chunk找到更精确的位置之后再找到具体的父chunk，比起分别在很多很大的chunk内查找，会更准确。
但是通常不会直接拆分为很小的chunk size，size太小，chunk内容含义可能被砍断了，意思不完整，这么做既可以保留完整含义，又能较为准确的查找。
可以使用LangChain的ParentDocumentRetriever。

### Fusion Retrieval
![[CleanShot 2024-08-13 at 18.56.55.png]]
除了向量数据库的形式，还可以使用其它的方法来存储和检索，比如BM25(黑盒)，然后结合多种方法的结果来组成最终的context。
LangChain提供了EnsembleRetriever和BM25Retriever来解决这个问题。
## Ranking优化-对retrieve的结果进行排序
首先要明确retrieve的结果选取top k个结果已经有排序，但是只是粗排(有索引，速度很快)，而ranking是进行精排(无索引，但数量较少，速度也还行)。
使用搜索引擎来举例：同样一个关键词，检索出20个链接，可能都是很相关的，但是显示给用户的排序，还需要结合各种因素，比如网站权重、是否已经显示过、内容是否重叠等因素。
### Ensemble Retriever
![[CleanShot 2024-08-14 at 09.14.51.png]]
主要针对上图的这种情况，如果是其它情况和流程，不适用。
LangChain提供了Ensemble Retrieve，主要原理如下：
![[CleanShot 2024-08-14 at 10.06.50.png]]
检索出最终的chunks列表之后，采用多种rank_model排序算法对每种中的chunk进行排序，并标注每种算法中每个chunk的顺序，然后通过聚合每个chunk在使用不同算法下的得分，得到每个chunk的最终得分，最终根据这个得分进行排序。
在这个求和公式种有一个k，添加这个k是为了避免r(ci)某个算法下的某个chunk为1时，整体为1，这样如果这个chunk在其它算法下距离1很远，那么概率就受到很大的影响，所以设置k为10，可以大大避免一个算法对整体概率造成较大影响。
这里可以采用的算法特别多：比如Cos Similarity、BM25等等，这里暂时不深究，当作黑盒使用即可，要明白的是通常都是将chunk和query进行循环比较
## Rag评估
![[CleanShot 2024-08-14 at 11.16.33.png]]
可以使用框架来完成Rag效果的评估，比如：RAGAS
简单来说就是对query、召回的context、以及最终的answer等多种内容进行评估，影响的因素包含faithfulness回答正确性、回答相关性、context相关性、context召回率等。
### Faithfulness计算
![[CleanShot 2024-08-14 at 11.22.00.png]]
就是将answer让大模型拆分为多个statement观点，然后判断answer中正确statement的数量，从而得出faithfulness正确性。
### Answer Relevance计算
![[CleanShot 2024-08-14 at 11.26.30.png]]
![[CleanShot 2024-08-14 at 11.27.35.png]]
通过答案使用llm拆分为多个question，然后分别和原始query进行相似度对比，最后取平均数得到answer的正确性。
### 其它指标
可以查看官网介绍：[Faithfulness | Ragas](https://docs.ragas.io/en/latest/concepts/metrics/faithfulness.html)












