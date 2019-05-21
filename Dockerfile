FROM alpine:3.8

RUN export DEBIAN_FRONTEND=noninteractive
RUN apk add tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

ENV LANG=zh_TW.UTF-8
ENV LC_CTYPE="zh_TW.UTF-8"
ENV LC_NUMERIC="zh_TW.UTF-8"
ENV LC_TIME="zh_TW.UTF-8"
ENV NLS_LANG=.AL32UTF8

RUN apk update && \
    apk add bash git openssh rsync augeas shadow && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*
    
RUN apk add openrc
RUN apk add --update openssh
RUN rc-update add sshd
#RUN /etc/init.d/sshd restart


RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key


#EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
