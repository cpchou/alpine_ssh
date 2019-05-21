FROM alpine:3.8

RUN apk -U upgrade
RUN apk add openrc
RUN apk add --update openssh
RUN echo "Port 22" >> /etc/ssh/ssh_config
RUN rc-update add sshd
#RUN /etc/init.d/sshd restart

RUN export DEBIAN_FRONTEND=noninteractive
RUN apk add tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime


ENV LANG=zh_TW.UTF-8
ENV LC_CTYPE="zh_TW.UTF-8"
ENV LC_NUMERIC="zh_TW.UTF-8"
ENV LC_TIME="zh_TW.UTF-8"
ENV NLS_LANG=.AL32UTF8
