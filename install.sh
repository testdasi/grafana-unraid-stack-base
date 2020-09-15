#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install wget apt-transport-https software-properties-common gnupg gnupg2 gnupg1

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get -y update \
    && apt-get -y install grafana
