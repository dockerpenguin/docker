FROM jenkins/jenkins:lts
MAINTAINER dockerpenguin

ARG TZ=Asia/Shanghai

USER root

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo '$TZ' > /etc/timezone \
    && echo 'root:root' | chpasswd

USER jenkins

# Install plugins
RUN /usr/local/bin/install-plugins.sh \
  analysis-core \
  checkstyle \
  email-ext \
  emailext-template \
  email-ext-recipients-column \
  findbugs \
  gerrit-trigger \
  git \
  maven-plugin \
  pmd \
  ssh \
  violations

# Add groovy setup config
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Generate jenkins ssh key.
COPY generate_key.sh /usr/local/bin/generate_key.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
