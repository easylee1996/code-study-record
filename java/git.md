# git工具

## github配置

连接github有https和ssh两种连接方式

### https连接

从GitHub更新验证机制后，需要生成token来登陆，所以首先需要在setting中生成Personal access tokens，一次性，然后在登陆的时候密码输入这个tokens即可

```
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
```

### 设置git https代理

```shell
// 配置之后再git config文件里面可以看到这个配置
git config --global http.proxy http://127.0.0.1:4780
git config --global https.proxy http://127.0.0.1:4780

// 扩展信息-取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

其中4780是代理服务器的代理端口，不同代理不一样

### ssh

首先需要生成ssh key

```shell
ssh-keygen -t rsa -C "xxx@xxx.com"
//"xxx@xxx.com"可以是自己的邮箱账号，这个其实就是给公钥取个名字的意思
```

生成之后在~/.ssh/id_rsa.pub中有key公钥信息，保存到github的setting的ssh配置中

```shell
vim ~/.ssh/id_rsa.pub
```

注意：ssh要设置代理比较麻烦，后面再研究

注意如果使用ssh，sourcetree软件的话，第一次要先git clone一下项目，认证通过再使用sourcetree，因为sourcetree不会弹出这个认证