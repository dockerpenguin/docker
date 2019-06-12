FROM hyper/docker-registry-web:latest
MAINTAINER dockerpenguin

ARG TZ=Asia/Shanghai

ADD root/ /

RUN apt-get update && apt-get install -y gettext tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo '$TZ' > /etc/timezone \
    && chmod -v +x /*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start.sh"]
