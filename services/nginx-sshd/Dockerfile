FROM nginx:alpine
MAINTAINER dockerpenguin

ADD root/ /

RUN apk add --no-cache openssh openssh-sftp-server  \
    && wget -qO - https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz | tar -zxvf - -C /usr/local/bin \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'root:root' | chpasswd \
    && chmod -v +x /app/*.sh

EXPOSE 22

CMD /app/start.sh
