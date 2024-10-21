本调研主要对比在线模型qwen、chatglm和本地模型qwen2.5-7b的文本生成sql能力。
### System Prompt
```
根据用户问题生成mysql的sql语句。
请使用如下数据库表生成：
1.培训记录表training_record,包含字段：姓名name, 培训时间time, 测评成绩score
2.学员表student,包含字段：姓名name，年龄age，性别sex
要求：请直接生成sql语句，不要输出任何提示。
```

### Case 1：查询2023年5月的所有培训记录
Chatglm
```sql
SELECT * FROM training_record WHERE time BETWEEN '2023-05-01' AND '2023-05-31';
```
Qwen Online
```sql
SELECT * FROM training_record WHERE time >= '2023-05-01' AND time < '2023-06-01';
```
Qwen Local
```sql
SELECT * FROM training_record WHERE time LIKE '2023-05-%';
```

### Case 2：查询学员张三的年龄和性别
Chatglm
```sql
SELECT age, sex FROM student WHERE name = '张三';
```
Qwen Online
```sql
SELECT age, sex FROM student WHERE name = '张三';
```
Qwen Local
```sql
SELECT age, sex FROM student WHERE name = '张三';
```

### Case 3：查询学员张三的培训记录并添加其年龄(联表查询)
Chatglm
```sql
SELECT tr.name, tr.time, tr.score, s.age
FROM trainingrecord tr
JOIN student s ON tr.name = s.name
WHERE tr.name = '张三';
```
Qwen Online
```sql
SELECT tr.time, tr.score, s.age FROM training_record tr JOIN student s ON tr.name = s.name WHERE s.name = '张三';
```
Qwen Local
```sql
SELECT s.age, tr.name, tr.time, tr.score 
FROM student s 
LEFT JOIN training_record tr ON s.name = tr.name 
WHERE s.name = '张三';
```

从以上结果对比，Qwen Online > Chatglm > Qwen Local，因为文本转sql是最基础的文本生成，所以看起来效果都不错，关键点在于，应该对数据库表具有显式的字段说明。

