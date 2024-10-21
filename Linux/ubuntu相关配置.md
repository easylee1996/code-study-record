### 配置bash
默认ubuntu使用的是dash来加快速度，但是通常我们使用bash来配置环境变量之类的，就很不方便，所以还是配置默认为bash
`sudo dpkg-reconfigure dash` 弹窗选择 `No`
同时注意不要保留 `~/.bash_profile` 文件，如果有把它删掉，就在 `~/.bashrc` 配置环境变量就行，否则就不会执行bashrc了
