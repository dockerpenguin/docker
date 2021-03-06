测试环境：

MacOS Sierra version: 10.12.6


# nginx-sshd

源代码tag：v1.0.0

在nginx:alpine镜像上叠加了openssh、sftp，可以在容器启动时自动创建新用户。主要是为了方便通过ssh自动部署一些静态网站上去方便测试。

安装了supervisor来管理这两个应用，带来的问题是体积从原来的20M多突破到70M以上，后面考虑换一种启动方式，缩小体积。

## 1、参数说明

| 参数名称                                         | 功能                                                         | 默认值            |
| ------------------------------------------------ | ------------------------------------------------------------ | ----------------- |
| APP_USER                                         | 如果需要使用新用户名，容器启动时自动创建以此命名的新用户     |                   |
| APP_PASSWORD                                     | 创建新用户的前提下，设置新用户密码（不安全，docker inspect能查看到） |                   |
| APP_PASSWORD_CRYPT                               | 同上，但是SHA512加密后的密码文，推荐使用的安全配置密码的方法（创建新用户时，密码未指定则自动设置为空） |                   |
| DISABLE_APP_USER_KEYGEN                          | 创建新用户时默认会在新用户/home/${APP_USER}目录下生成ssh证书。不需要此功能则设置true | false             |
| DISABLE_CONFIG_GEN                               | 容器启动时默认会根据环境变量生成sshd_config配置文件。不需要此功能则设置true | false             |
| SSH_PERMIT_ROOT_LOGIN                            | sshd配置：允许root登录的方式                                 | prohibit-password |
| SSH_PASSWORD_AUTH_ALLOWED                        | sshd配置：是否允许使用密码登录                               | no                |
| SSH_USE_PAM_ALLOWED                              | sshd配置：是否开启可插入身份验证模块（与上面密码验证一起开启） | no                |
| SSH_EMPTY_PASSWORD_ALLOWED                       | sshd配置：是否允许空密码用户登录                             | no                |
| 上面是ssh、容器等相关配置，nginx相关配置参考官网 | nginx容器官网：https://hub.docker.com/_/nginx                |                   |

## 2、启动例子

镜像启动为容器的主要参数如下：

> -p 1080:80  nginx的80端口映射到宿主机1080
>
> -p 1022:22  ssh的22端口映射到宿主机1022
>
> YOUR_SITE_DIR 指你需要发布的静态网页目录
>
> YOUR_SSH_HOME 指你提供的ssh证书目录（若自行提供证书，里面要包含.ssh/authorized_keys文件，它包含了你要用的id_rsa.pub的信息。若目录为空，默认会自动生成相关证书。）

1、通过root用户ssh证书登录，提供.ssh证书所在目录/YOUR_SSH_HOME挂载到目标/root目录

```dockerfile
docker run --name nginx_sshd  -p 1080:80 -p 1022:22 \
-v /YOUR_SITE_DIR:/usr/share/nginx/html:ro \
-v /YOUR_SSH_HOME:/root \ 
-d dockerpenguin/nginx-sshd
```

启动后即可通过浏览器访问127.0.0.1:1080查看发布到nginx的网页。

```shell
ssh root@127.0.0.1 -p 1022 -i 你的id_rsa证书文件
```

2、创建新用户foo，并使用密码foo登录

```dockerfile
docker run --name nginx_sshd  -p 1080:80 -p 1022:22 \
-v /YOUR_SITE_DIR:/usr/share/nginx/html:ro \
-e SSH_USE_PAM_ALLOWED=yes \
-e SSH_PASSWORD_AUTH_ALLOWED=yes \
-e APP_USER=foo \
-e APP_PASSWORD=foo \
-d dockerpenguin/nginx-sshd
```

会自动创建一个foo用户，并设定好初始密码。执行下面命令登录时会要求你输入密码验证。

```shell
ssh foo@127.0.0.1 -p 1022 
```

## 3、修改启动方式为shell

源代码tag：v1.0.1

功能不变，镜像的启动方式由原来的supervisor改成shell脚本启动。

变动效果：前者构建的镜像体积近80M，后者构建后镜像的体积30M出头。

