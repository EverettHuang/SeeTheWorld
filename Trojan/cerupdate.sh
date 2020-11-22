#! /bin/bash
#需使用root权限
#脚本需要参数:域名

set -e

#判断是否有root权限
if [ `id -u` -ne 0 ];then
	echo -e "\033[31m 证书申请失败,当前为非root用户,申请证书需要root权限,脚本已退出 \033[0m"
	exit 1
fi
echo -e "\033[32m 已用root权限执行脚本 \033[0m"

#需要先关闭占用80端口的服务
systemctl stop nginx
echo -e "\033[32m nginx服务已停止 \033[0m"

systemctl stop trojan-go
echo -e "\033[32m trojan服务已停止 \033[0m"

#安装acme.sh脚本
curl  https://get.acme.sh | sh&&echo "acme.sh脚本安装完成"

#申请安装证书 
~/.acme.sh/acme.sh --issue -d ${1} --standalone -k ec-384&&\
~/.acme.sh/acme.sh --installcert -d ${1} --fullchainpath /etc/trojan-go/certificate.crt.b --keypath /etc/trojan-go/private.key.b --ecc
mv -f /etc/trojan-go/certificate.crt.b /etc/trojan-go/cer/certificate.crt
mv -f /etc/trojan-go/private.key.b /etc/trojan-go/cer/private.key
chmod -R 755 /etc/trojan-go/
echo -e "\033[32m 证书已安装至/etc/trojan-go/路径 \033[0m"

#卸载acme.sh脚本并启动80端口服务
~/.acme.sh/acme.sh --uninstall&&rm -rf ~/.acme.sh&&echo -e "\033[32m acme脚本卸载完成 \033[0m"
systemctl restart nginx&&echo -e "\033[32m nginx 服务已启动 \033[0m"
systemctl restart trojan-go&&echo -e "\033[32m trojan-go 服务已启动 \033[0m"

#证书更新完成
echo -e "\033[32m --------------------------- \033[0m"
echo -e "\033[32m 证书更新完毕 \033[0m"
echo -e "\033[32m --------------------------- \033[0m"
