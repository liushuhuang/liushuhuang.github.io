---
title: Nginx相关知识
date: 2022-09-19 8:15:00
description: Nginx基础知识
tags: Nginx
top_img: transparent
---

## Nginx是什么

>- Nginx 是高性能的 HTTP 和反向代理的web服务器，处理高并发能力是十分强大的，能经受高负 载的考验,有报告表明能支持高达 50,000 个并发连接数。
>
>
>- 其特点是占有内存少，并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、京东、新浪、网易、腾讯、淘宝等。

## Nginx能干什么

### 正向代理

> 为客户端代理，局域网连接Internet时的代理
>
> - 正向代理，指的是通过`代理服务器` 代理`浏览器/客户端`去重定向请求访问到`目标服务器` 的一种代理服务。
> - 正向代理服务的特点是`代理服务器` 代理的对象是`浏览器/客户端`，也就是对于`目标服务器` 来说`浏览器/客户端`是隐藏的。

### 反向代理

>服务器的代理，对请求进行代理转发
>
>- 反向代理，指的是`浏览器/客户端`并不知道自己要访问具体哪台`目标服务器`，只知道去访问`代理服务器` ，`代理服务器`再通过`反向代理 +负载均衡`实现请求分发到`应用服务器`的一种代理服务。
>- 反向代理服务的特点是`代理服务器` 代理的对象是`应用服务器`，也就是对于`浏览器/客户端` 来说`应用服务器`是隐藏的。

### 负载均衡

>对请求进行分配，减少每一台服务器的压力
>
>- 增加服务器的数量，然后将请求分发到各个服务器上，将原先请求集中到单个服务器上的情况改为将请求分发到多个服务器上，将负载分发到不同的服务器，也就是我们所说的负载均衡
>- 客户端发送多个请求到服务器，服务器处理请求，有一些可能要与数据库进行交互，服务器处理完毕后，再将结果返回给客户端。

## 动静分离

> 为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力。
>
> Nginx的静态处理能力很强，但是动态处理能力不足，因此，在企业中常用动静分离技术。动静分离技术其实是采用代理的方式，在server{}段中加入带正则匹配的location来指定匹配项针对PHP的动静分离：静态页面交给Nginx处理，动态页面交给PHP-FPM模块或Apache处理。在Nginx的配置中，是通过location配置段配合正则匹配实现静态与动态页面的不同处理方式

### 负载均衡常用算法

1. **基于`轮询`的算法**

   > 原理是每一个请求按时间顺序逐一被分发到不同的应用服务器，如果接收请求的应用服务器挂了，并且请求超过最大失败次数`max_fails`（**1次**），则在失效时间`fail_timeout`（**10秒**）内不会再转发请求到该节点
   >
   > ```nginx
   > upstream defaultReverseProxyServer{
   >     server 192.168.0.1:8080; 
   >     server 192.168.0.2:8080; 
   > }
   > 
   > ```

2. **基于`权重`的算法**

   > 原理是每一个请求按权重被分发到不同的应用服务器，同样，如果接收请求的应用服务器挂了，并且请求超过最大失败次数`max_fails`（**默认1次或可设置N次**），则在失效时间`fail_timeout`（**默认10秒，可设置N秒**）内，不会再转发请求到该节点
   >
   > ```nginx
   > upstream weightReverseProxyServer{
   > 	server 192.168.0.1:8080 weight=10 max_fails=2 fail_timeout=5s;
   >     server 192.168.0.2:8080 weight=5 max_fails=2 fail_timeout=5s;
   > }
   > ```

3. **基于`ip_hash`的算法**

   > 原理是每一个请求按用户访问IP的哈希结果分配，如果请求来自同一个用户IP则固定这台IP访问一台应用服务器，该算法可以有效解决动态网页中存在的session共享问题。
   >
   > ```nginx
   > upstream ipHashReverseProxyServer{
   >     ip_hash;
   >     server 192.168.0.1:8080;
   >     server 192.168.0.2:8080;
   > }
   > 
   > ```

## Nginx常用命令

>./nginx  启动
>./nginx -s stop  停止
>./nginx -s quit  安全退出
>./nginx -s reload  重新加载配置文件
>ps aux|grep nginx  查看nginx进程

Nginx连接相关代码

> **开启**
>
> ​	service firewalld start
>
> **重启**
>
> ​	service firewalld restart
>
> **关闭**
>
> ​	service firewalld stop
>
> **查看防火墙规则**
>
> ​	firewall-cmd --list-all
>
> **查询端口是否开放**
>
> ​	firewall-cmd --query-port=8080/tcp
>
> **开放80端口**
>
> ​	firewall-cmd --permanent --add-port=80/tcp
>
> **移除端口**
>
> ​	firewall-cmd --permanent --remove-port=8080/tcp
> **#重启防火墙(修改配置后要重启防火墙)**
> ​	firewall-cmd --reload
>
> **参数解释**
>
> ​	1、firwall-cmd：是Linux提供的操作firewall的一个工具；
> ​	2、--permanent：表示设置为持久；
> ​	3、--add-port：标识添加的端口；

## 配置文件

文件结构

```nginx
Global: nginx 运行相关
Events: 与用户的网络连接相关
http
    http Global: 代理，缓存，日志，以及第三方模块的配置
    server
        server Global: 虚拟主机相关
        location: 地址定向，数据缓存，应答控制，以及第三方模块的配置
```

>Nginx的HTTP配置主要包括三个区块，结构如下：
>
>```nginx
>http { //这个是协议级别
>　　include mime.types;
>　　default_type application/octet-stream;
>　　keepalive_timeout 65;
>　　gzip on;
>　　　　server { //这个是服务器级别
>　　　　　　listen 80;
>　　　　　　server_name localhost;
>　　　　　　　　location / { //这个是请求级别
>　　　　　　　　　　root html;
>　　　　　　　　　　index index.html index.htm;
>　　　　　　　　}
>　　　　　　}
>}
>```

> **查找顺序和优先级
> 1：带有“=“的精确匹配优先
> 2：没有修饰符的精确匹配
> 3：正则表达式按照他们在配置文件中定义的顺序
> 4：带有“^~”修饰符的，开头匹配
> 5：带有“~” 或“~\*” 修饰符的，如果正则表达式与URI匹配
> 6：没有修饰符的，如果指定字符串与URI开头匹配                                                                                                              7：^代表以什么开头，类似~ ^/a 代表以正则表达式匹配，以/a开头，和4一样的作用，但是优先级不一样**
>
> 
>
> 优先级较高的先匹配
>
> 同等优先级，匹配程度较高的先匹配
>
> 优先级和匹配程度都相同，写在前面的先匹配

> 配置反向代理用proxy_pass
>
> 例：
>
> upstream aaa{    #负载均衡
>
> ​	server 1.1.1.1:80 max_fails = 3  fail_timeout = 5s
>
> }
>
> location ~^ /a {
>
> ​	proxy_pass: http://aaa;
>
> }



## 反向代理路径拼接

>1. location / {
>
>   ​		proxy_pass: http://192.168.0.2:80
>
>   }
>
>   代表转到http://192.168.0.2:80/
>
>2. location /a{
>
>   ​		proxy_pass: http://192.168.0.2:80
>
>   }
>
>   代表转到http://192.168.0.2:80/a
>
>3. **location /a {**
>
>   ​		**proxy_pass: http://192.168.0.2:80/**
>
>   **}**
>
>   **代表转到http://192.168.0.2:80/**
>
>   注意第三种



>  /demo4和/demo4/区别是前者能匹配/demo4444这种路径的，后者不能，他们是决定能不能进来下面的逻辑的。一般用后者防止出一些奇葩路径。proxy_pass中有任何/的话，/不一定在最后，不过http协议里那俩除外，有和无是两个计算公式。
>  无：最终url =  proxy_pass的值 + uri。
>   有：最终url = proxy_pass的值 + （uri-location的值）
>  举个例子 location /a proxy_pass http://xx.com/11/22/33; 
>   访问/ab转到http://xx.com/11/22/33b
>  访问/a/b转到http://xx.com/11/22/33/b
> 
>  换个例子，location /a proxy_pass http://xx.com/11/22/33/; 
>  访问/a/b转到http://xx.com/11/22/33//b（//b一般会自动转为/b）
>
>   再举个例子 location /a/ proxy_pass http://xx.com/11/22/33/; 
>  访问/a/b转到 xx.com/11/22/33b
>   全都可以套公式计算出来的
>
> 
>
>  root alias区别是，root找的文件路径=root的值+uri，alias找的文件路径=alias的值+(uri-location)
>  例如都是location /a，并且root和alias都指向html，index都是index.html。
>   root： /a       => html/a => html/a/index.html
>  root:   /a/b.txt=>html/a/b.txt
>   root:   /ab.txt  =>html/ab.txt
>  alias:   /a       =>html=>html/index.html
>   alias:   /a/b.txt=>html/b.txt
>  alias:   /ab.txt=>htmlb.txt (404)
>   为了避免最后这种情况，一般可以将location设置为/结尾比如 location /a/，就不会匹配这个形式防止出错。
>  或者将 alias设置为html/ 后面带个/的。location还是/a就能实现
>   alias:   /ab.txt=>html/b.txt
>   通俗点总结计算文件路径的方式就是：root的文件 = root值+uri+【/index.html】 
>   alias的文件 = alias值 + （uri-location的值）+【/index.html】





