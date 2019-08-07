ARG         ALPINE_VERSION=${ALPINE_VERSION:-3.9}
FROM        alpine:${ALPINE_VERSION}


ARG         OPENSSH_VERSION=${OPENSSH_VERSION:-7.9_p1-r5}
ENV         OPENSSH_VERSION=${OPENSSH_VERSION} \
            ROOT_PASSWORD=root \
            KEYPAIR_LOGIN=false \
	    TZ=Asia/Taipei

COPY        entrypoint.sh /
RUN         apk add --upgrade --no-cache openssh=${OPENSSH_VERSION} \
            && chmod +x /entrypoint.sh \
	    && mkdir -p /root/.ssh \
	    && rm -rf /var/cache/apk/* /tmp/*

RUN echo -e "Port 22\n" >> /etc/ssh/sshd_config
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key		

RUN apk add tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

EXPOSE      22
VOLUME      ["/etc/ssh"]
ENTRYPOINT  ["/entrypoint.sh"]
