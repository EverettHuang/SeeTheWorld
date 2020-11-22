#! /bin/bash
#需使用root权限
#脚本默认安装trojan-go版本
ver=0.8.2
mkdir -R /etc/trojan-go/cer/
mkdir /etc/trojan-go/example/
mkdir trojaninstall
cd trojaninstall
apt install socat wget curl nginx

set -e

#判断是否有root权限
if [ `id -u` -ne 0 ];then
	echo -e "\033[31m trojan-go安装失败,当前为非root用户,请使用root权限执行脚本,脚本已退出 \033[0m"
	exit 1
fi
echo -e "\033[32m 已用root权限执行脚本 \033[0m"

if [ -z "$1" ];then
    echo -e "\033[32m 安装默认版本${ver} \033[0m"
else
    ver=${1}
	echo -e "\033[32m 安装版本为${ver} \033[0m"
fi

curl https://github.com/p4gefau1t/trojan-go/releases/download/v${ver}/trojan-go-linux-amd64.zip\
&&unzip -o trojan-go-linux-amd64.zip&&rm -rf trojan-go-linux-amd64.zip

mv example/trojan-go.service /etc/systemd/system/
mv example/trojan-go@.service /etc/systemd/system/

mv trojan-go /usr/bin/

mv example/* /etc/trojan-go/example/
mv geoip.dat /etc/trojan-go/
mv geosite.dat /etc/trojan-go/

cp /etc/trojan-go/example/server.json /etc/trojan-go/config.json

##申请证书的脚本路径
wget xxxxxxxx/cerupdate.sh

read -p "please input your domain:" -t 30 domain

bash cerupdate.sh ${domain}

read -p "please input your password:" -t 30 passwd

nginx config > nginx.conf

vi /etc/trojan-go/config.json

chmod -R 755 /etc/trojan-go/

systemctl start trojan-go
