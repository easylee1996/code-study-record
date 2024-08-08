## 文本拆分Trunk
![[CleanShot 2024-07-23 at 19.09.14.png]]
一般比较常用RecursiveCharacterTextSplitter，将文本递归的分割成较小的文本块，比如以标点符号分割，当然根据语义分割是最佳的，但是效率非常低，因为需要运用到机器学习的语义识别来进行拆分。
常用拆分库
```python
# 中文
%pip install jieba
from langchain.text_splitter import RecursiveCharacterTextSplitter

# 英文
%pip install nltk
from langchain.text_splitter import RecursiveCharacterTextSplitter
```
## Trunk向量化
![[CleanShot 2024-07-23 at 19.41.19.png]]
![[CleanShot 2024-07-23 at 19.44.06.png]]
使用余弦相似度来判断两个向量是否更相近
![[CleanShot 2024-07-23 at 19.48.05.png]]
广泛流行的词嵌入向量化模型是：BERT和Word2Vec
## 向量数据库
更高效的检索保存的向量
![[CleanShot 2024-07-23 at 20.04.18.png]]
如果每次查询一个向量的相似向量都全部对比的话，复杂度太高，所以需要进行索引=>相似度索引