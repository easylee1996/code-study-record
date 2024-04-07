```python
from loguru import logger

# 配置输出日志文件和以及输出级别,debug < info < warning < error
*logger.add("output.log", level="INFO")*

# 记录不同级别的日志
logger.debug("这是一个 debug 级别的日志")
logger.info("这是一个 info 级别的日志")
logger.warning("这是一个 warning 级别的日志")
logger.error("这是一个 error 级别的日志")

# 使用日志变量
name = "World"
logger.info(f"Hello, {name}!")

# 记录异常信息，将这些异常信息暴露于日志文件中
try:
    1 / 0
except ZeroDivisionError:
    logger.exception("发生了一个异常")

```