#!/bin/bash

## Fix locales and tzdata to prevent tzdata stopping installation ##
apt-get -y update
apt -y install locales tzdata
locale-gen 'en_GB.UTF-8' \
    && dpkg-reconfigure --frontend=noninteractive locales
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo 'Europe/London' > /etc/timezone \
    && dpkg-reconfigure --frontend=noninteractive tzdata

# install more packages
apt-get -y update \
    && apt-get -y install wget apt-transport-https software-properties-common gnupg gnupg2 gnupg1 lm-sensors smartmontools ipmitool curl unzip jq

# add grafana repo
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
# add telegraf repo
wget -qO- https://repos.influxdata.com/influxdb.key | apt-key add -
echo "deb https://repos.influxdata.com/debian buster stable" | tee /etc/apt/sources.list.d/influxdb.list

## Fix locales and tzdata to prevent tzdata stopping installation ##
apt -y install locales tzdata
locale-gen 'en_GB.UTF-8' \
    && dpkg-reconfigure --frontend=noninteractive locales
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo 'Europe/London' > /etc/timezone \
    && dpkg-reconfigure --frontend=noninteractive tzdata

# install grafana telegraf influxdb hddtemp
apt-get -y update \
    && apt-get -y install grafana telegraf influxdb hddtemp

# install loki and promtail
LOKI_RELEASE=$(curl -sX GET "https://api.github.com/repos/grafana/loki/releases/latest" | jq -r .tag_name)
LOKI_VER=${LOKI_RELEASE#v} \
    && cd /tmp \
    && curl -O -L "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/loki-linux-amd64.zip" \
    && curl -O -L "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/promtail-linux-amd64.zip" \
    && unzip "loki-linux-amd64.zip" \
    && chmod a+x "loki-linux-amd64" \
    && mv loki-linux-amd64 /usr/sbin/loki \
    && rm -f loki-linux-amd64.zip \
    && unzip "promtail-linux-amd64.zip" \
    && chmod a+x "promtail-linux-amd64" \
    && mv promtail-linux-amd64 /usr/sbin/promtail \
    && rm -f promtail-linux-amd64 \
    && echo "$(date "+%d.%m.%Y %T") Added loki and promtail binary release ${LOKI_RELEASE}" >> /build_date.info

# clean config
rm -f /etc/default/grafana-server \
    && touch /etc/default/grafana-server
rm -f /etc/hddtemp.db
rm -rf /etc/telegraf
rm -rf /etc/influxdb
rm -rf /etc/grafana

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*
