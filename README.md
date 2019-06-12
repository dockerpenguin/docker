[TOC]

# 概述：

个人学习使用docker容器的记录。docker hub上提供了很多资源，为了方便自己的使用习惯，尝试在基础镜像上叠加一些自己想要的工具。

# 正文：

## 一、服务器类

会把一些运行环境类的定制镜像放在这个栏目。

### [1、nginx-sshd: 基于nginx镜像增加sshd、sftp服务](services/nginx-sshd/README.md)

### [2、ssh-container: 用数据卷共享功能管理ssh证书](services/ssh-container/README.md)

## 二、应用类

在一些应用软件上加一些功能。

### [1、registry-envsubst: registry配置文件支持模版化生成](applications/registry-envsubst/README.md)