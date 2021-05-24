#!/bin/bash
# 指定用户名
USER=presto
# 用户密码
PSD=hx
# 用户家目录
USER_DIR=/home/presto
#定义ssh免密登陆的函数
establishSSH ()
{
cat >establishSSH.exp<<EOF
#!/usr/bin/expect
# 使用spawn监控ssh免密登陆过程实现自动输入yes和密码
spawn ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub $SSH_IP
expect {
# 识别到是否接受时，输入yes，继续监控
"*yes/no*" {send "yes\r"; exp_continue}
"*password*" {send "$PSD\r";}
}
# expect结束标志就是expect eof
expect eof
EOF
# 给脚本加可执行权限
chmod 755 establishSSH.exp
./establishSSH.exp > /dev/null
# 执行完删除
/bin/rm -rf establishSSH.exp
}

# 判断是否存在servers.txt文件
if [ -f ./servers.txt ]
then
        :
else
        echo "*************************************"
        echo "************没有集群IP文件***********"
        echo "*************************************"
        exit 0
fi

#定义生成ssh密钥的函数
genSSH ()
{
cat >genSSH.exp<<EOF
#!/usr/bin/expect        
# 使用spawn监控ssh免密登陆过程实现自动输入yes和密码
spawn ssh-keygen
expect {
# 识别到是否接受时，输入yes，继续监控
"*.ssh*" {send "\r"; exp_continue}
"*y/n*" {send "y\r";}
"*passphrase*" {send "\r";}
"*passphrase again*" {send "\r";}
}
# expect结束标志就是expect eof
expect eof
EOF
# 给脚本加可执行权限
chmod 755 genSSH.exp
./genSSH.exp > /dev/null
# 执行完删除
/bin/rm -rf genSSH.exp
}

# 生成本机公钥
if [ -f $USER_DIR/.ssh/id_rsa.pub ]
then
        :
else
        genSSH
fi


# 遍历ip列表执行ssh授权
for SSH_IP in $(<servers.txt)
do
        echo "现在对$SSH_IP配置免密登陆"
	establishSSH
    if [ $? -eq 0 ]
    then
            echo "$SSH_IP OK"
    else
            echo "$SSH_IP failed"
    fi
done
