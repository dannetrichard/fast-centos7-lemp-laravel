#!/bin/bash
yum install bzip2 -y
#将PhantomJS下载在/usr/local/src/目录下
#https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
cd /usr/local/src/
# 下载好后进行解压（由于是bz2格式，要先进行bzip2解压成tar格式，再使用tar解压）
bzip2 -d phantomjs-2.1.1-linux-x86_64.tar.bz2
# 再使用tar进行解压到/usr/local/目录下边
tar xvf phantomjs-2.1.1-linux-x86_64.tar -C /usr/local/
# 安装依赖软件
yum -y install wget fontconfig
# 重命名（方便以后使用phantomjs命令）
mv /usr/local/phantomjs-2.1.1-linux-x86_64/ /usr/local/phantomjs
# 最后一步就是建立软连接了（在/usr/bin/目录下生产一个phantomjs的软连接，/usr/bin/是啥目录应该清楚，不清楚使用 echo $PATH查看）
ln -s /usr/local/phantomjs/bin/phantomjs /usr/bin/


#systemctl start firewalld
#firewall-cmd --zone=public --add-port=5000/tcp --permanent
#firewall-cmd --reload

yum install python-pip python-devel python-distribute libxml2 libxml2-devel python-lxml libxslt libxslt-devel openssl openssl-devel libcurl-devel -y

mkdir -p /data/pyspider_env
cd  /data/pyspider_env

virtualenv -p /usr/bin/python3 --no-site-packages venv
source venv/bin/activate
export PYCURL_SSL_LIBRARY=nss
pip3 install pycurl --no-cache-dir
pip3 install pyspider
killall phantomjs
pyspider
deactivate
 