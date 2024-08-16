## 设置镜像
使用 [HF-Mirror](https://hf-mirror.com) 镜像站：
```bash
echo 'export HF_ENDPOINT="https://hf-mirror.com"' >> ~/.zshrc
```
## 常见下载模型和数据集的方式
- `huggingface-cli`：推荐，需要安装huggingface-hub >= 0.17 && python >= 3.8
- `snapshot_download`
- `from_pretrained`：推荐，代码调试
- `hf_hub_download`
- `timm.create_model`

上面设置镜像之后，可以直接支持上面的命令，可以解决命令行下载和代码直接下载，非常方便。
还可以使用git直接把模型拉下来，但是速度很慢，不支持多线程，且会拉取历史版本，占用空间大增。

