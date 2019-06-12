FROM registry:2
MAINTAINER dockerpenguin

ARG TZ=Asia/Shanghai

ADD root/ /

RUN apk add --no-cache gettext tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo '$TZ' > /etc/timezone \
    && chmod -v +x /*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/etc/docker/registry/config.yml"]
