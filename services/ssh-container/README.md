测试环境：

MacOS Sierra version: 10.12.6

# ssh-container

源代码tag：v1.0.2

利用docker的数据卷创建一个用于ssh证书authorized_keys数据共享的镜像。

环境中存在着多个容器，管理这些容器对外的ssh服务，需要把相应的公钥pub证书拷贝到对应的authorized_keys文件中。用单独一个容器存放authorized_keys证书，再使用数据卷功能共享给其它容器即可。

## 1、原理：

网上看到个例子是采用一个空镜像用来创建数据卷，实际测试发现拷贝公钥到容器的时候，它所属的用户权限组变了，ssh登录时无法被识别导致无法登录。

```shell
$ tar cv --files-from /dev/null | docker import - scratch
```

因此需要一个基础镜像，能够保证.ssh目录相关文件所属的用户和权限组正确，于是基于alpine构建了一个。

```shell
$ docker create -v /root/.ssh --name ssh-container dockerpenguin/ssh-container
$ docker cp id_rsa.pub ssh-container:/root/.ssh/authorized_keys
# copy之后需要start一次容器，执行默认的脚本确保.ssh目录相关文件的用户权限组正确
$ docker start ssh-container
$ docker run --volumes-from ssh-container YOUR_IMAGE 
```

## 2、说明：

1、基于dockerpenguin/ssh-container镜像，使用"/root/.ssh"目录作为数据卷，创建一个名字为ssh-container的容器

2、将待共享的公钥文件拷贝到相应authorized_keys中

3、启动一次ssh-container的容器（**dockerfile里面定义的ENTRYPOINT脚本会把ssh目录及相关文件权限组重新设定一次为root** ）

4、其它容器挂载ssh-container数据卷启动镜像

 