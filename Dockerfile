#ARG FRM='testdasi/debian-slim-base'
ARG FRM='testdasi/ubuntu-base'
ARG TAG='latest'
ARG DEBIAN_FRONTEND='noninteractive'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}:${TAG}" >> /build.info

COPY ./install.sh /
RUN /bin/bash /install.sh \
    && rm -f /install.sh
