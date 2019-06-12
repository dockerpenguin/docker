测试环境：

MacOS Sierra version: 10.12.6


# registry-envsubst

源代码tag：v1.0.3

在registry:2镜像上增加envsubst、时区信息。

registry配置文件通过模版自动生成。主要是为了简化配置，通过envsubst命令，将配置模版里面预先定义的值根据环境变量替换后生成最终的"/etc/docker/registry/config.yml"配置文件。

**模版自由定义，文件名需要以".tmp"结尾，作为cmd参数传入即可。**


## 1、docker run启动例子

"./conf/config.yml.tmp"文件为自定义的模版文件，挂载到"/etc/docker/registry"目录，里面使用了NGINX_DOMAIN_URL变量，启动时根据-e参数自动替换进去。
```
docker run \
  -p 5000:5000 \
  --name registry \
  -v "$(pwd)"/conf:/etc/docker/registry \
  -e NGINX_DOMAIN_URL=registry.example.com:10043 \
  -d dockerpenguin/registry-envsubst /etc/docker/registry/config.yml.tmp
```

## 2、docker-compose启动例子

```
version: '3'
services:
  registry:
    image: dockerpenguin/registry-envsubst 
    ports:
      - 127.0.0.1:5000:5000
    volumes:
      - ./conf:/etc/docker/registry
      - ./registry:/var/lib/registry
    environment:
      - TZ='Asia/Shanghai'
      - NGINX_DOMAIN_URL=registry.example.com:10043
    command: /etc/docker/registry/config.yml.tmp

```




