#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install wget apt-transport-https software-properties-common gnupg gnupg2 gnupg1 curl unzip jq

# install grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get -y update \
    && apt-get -y install grafana

# install loki
LOKI_RELEASE=$(curl -sX GET "https://api.github.com/repos/grafana/loki/releases/latest" | jq -r .tag_name)
LOKI_VER=${LOKI_RELEASE#v} \
    && cd /tmp
    && curl -O -L "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/loki-linux-amd64.zip" \
    && curl -O -L "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/promtail-linux-amd64.zip" \
    && unzip "loki-linux-amd64.zip" \
    && chmod a+x "loki-linux-amd64" \
    && mv loki-linux-amd64 /usr/sbin \
    && rm -f loki-linux-amd64.zip \
    && unzip "promtail-linux-amd64.zip" \
    && chmod a+x "promtail-linux-amd64" \
    && mv promtail-linux-amd64 /usr/sbin \
    && rm -f promtail-linux-amd64 \
    && echo "$(date "+%d.%m.%Y %T") Added loki and promtail binary release ${LOKI_RELEASE}" >> /build_date.info

