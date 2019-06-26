#jenkins预安装gerrit集成插件

测试环境：

MacOS Sierra version: 10.12.6


# jenkins-gerrit

源代码tag：v1.0.5

基于官方jenkins/jenkins:lts镜像，预安装一些插件，方便与gerrit集成。

安装以下插件：

* analysis-core
* checkstyle
* email-ext
* emailext-template
* email-ext-recipients-column
* findbugs
* gerrit-trigger
* git
* maven-plugin
* pmd
* ssh
* violations



## 启动Jenkins容器

###docker run启动

  ```shell
docker run \
        -e TZ=Asia/Shanghai \
        -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Xmx800m" \
        -e JENKINS_OPTS=--prefix=/jenkins \
        -e ROOT_URL=http://your.jenkins.example.com/jenkins/ \
        -v "$(pwd)"/jenkins_home:/var/jenkins_home \
        -p 8080:8080 \
        -p 50000:50000 \
        -d dockerpenguin/jenkins-gerrit
  ```

###docker-compose启动

```shell
version: '3'
services:
  jenkins:
    image: dockerpenguin/jenkins-gerrit
    environment:
      - TZ=Asia/Shanghai
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=false -Xmx800m
      - JENKINS_OPTS=--prefix=/jenkins
      - ROOT_URL=http://jenkins.example.com/jenkins/
      - GERRIT_HOST_NAME=gerrit.example.com
      - GERRIT_FRONT_END_URL=http://gerrit.example.com
    volumes:
      - ./jenkins_home:/var/jenkins_home
    ports:
      - "8080:8080"
      - "50000:50000"
```

## Jenkins集成Gerrit的环境变量

| 变量名称 | 用途 |
| ---- | ---- |
| GERRIT_HOST_NAME | Gerrit服务器主机名 |
| GERRIT_FRONT_END_URL | Gerrit服务器http访问地址 |
| GERRIT_SSH_PORT | Gerrits服务器ssh端口（可选，默认29418） |
| GERRIT_USERNAME | Gerrit用户名（可选，默认jenkins） |
| GERRIT_EMAIL | Gerrit用户邮箱地址（可选，默认空） |
| GERRIT_SSH_KEY_FILE | Gerrit的rsa证书地址（可选，默认/var/jenkins_home/.ssh/id_rsa） |
| GERRIT_SSH_KEY_PASSWORD | Gerrit的rsa证书密码（可选，默认null） |
