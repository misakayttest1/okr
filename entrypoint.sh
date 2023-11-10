#!/usr/bin/env bash

# 设置 XrayR 配置文件
PANEL_TYPE='V2board'
NODE_ID=75
API_HOST='https://miku.misaka.now.cc'
API_KEY='tCi8xNAa37LA8erZ'
sed -i "s#PANEL_TYPE#${PANEL_TYPE}#g;s#API_HOST#${API_HOST}#g;s#API_KEY#${API_KEY}#g;s#NODE_ID#${NODE_ID}#g" config.yaml

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

# 伪装 XrayR 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv web ${RELEASE_RANDOMNESS}

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
[ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ] && wget https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -O nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent ${NEZHA_SERVER} ${NEZHA_PORT} ${NEZHA_KEY}

# 启动 nginx 和 XrayR
nginx
./${RELEASE_RANDOMNESS} -config=config.yaml
