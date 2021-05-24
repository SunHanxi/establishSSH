# establishSSH
ssh批量免登陆配置脚本

1. 本机安装expect
```bash
sudo apt update && sudo apt install expect
```
2. 新建一个名为servers.txt的文件，存放集群内所有机器的IP
```
192.168.84.133
192.168.84.132
```
3. 给establishSSH.sh加可执行权限并执行。
```bash
chmod +x establishSSH.sh && ./establishSSH.sh
```

