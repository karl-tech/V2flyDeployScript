# V2flyDeployScript


This script can help you install and deploy [V2ray](https://github.com/v2fly/v2ray-core) server with TLS & TCP & Vmess protocol easily.

You can use this script to deploy an V2ray server with TLS + TCP + Vmess protocol.Before use it, you must have a domain for your server.

This script will install the following packages on you server:

- Haproxy - Process tls-in connection.Haproxy will forward tcp traffic to v2ray, and forward http traffic to nginx.

- Certbot - To generate and renew Let's Encript TLS cert.

- Nginx - A fake website server for hiding v2ray server.

- [V2ray](https://github.com/v2fly/v2ray-core)

### Installing

```Bash
$ git clone git@github.com:karl-tech/V2flyDeployScript.git
$ cd V2flyDeployScript
$ sh deploy.sh {your domain} 
```

**Don't forget to add clients to your v2ray config file(path: /usr/local/etc/v2ray/config.json).**


## 中文

这个脚本可以帮助你快速安装和部署TLS+TCP+Vmess协议的[V2ray](https://github.com/v2fly/v2ray-core)服务.

你可以通过脚本部署TLS+TCP+Vmess协议的V2ray服务。在开始部署之前，请确保您已经拥有了一个指向您服务器IP的域名。

这个脚本将在您的服务器中安装如下软件:

- Haproxy - 用于处理TLS入站连接，然后将http协议的连接转发给Nginx，其余连接转发给V2ray。

- Certbot - 用于生成Let's Encript的免费CA证书，以及用于之后的证书更新。

- Nginx - 处理Haproxy转发过来的Http连接，用于防止Http探测，隐藏V2ray服务。

- [V2ray](https://github.com/v2fly/v2ray-core)

### 安装

```Bash
$ git clone git@github.com:karl-tech/V2flyDeployScript.git
$ cd V2flyDeployScript
$ sh deploy.sh {your domain} 
```

**别忘了在V2ray的配置文件中加入client配置(配置文件地址: /usr/local/etc/v2ray/config.json)。**