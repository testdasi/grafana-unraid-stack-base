#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install wget apt-transport-https software-properties-common gnup gnupg2 gnupg1
