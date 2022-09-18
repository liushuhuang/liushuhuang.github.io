---
title: linux命令
date: 2022-09-07 12:19:00
description: 一些基础的linux命令
tags: linux
top_img: transparent
---

# 进程相关

通过进程名找到进程：

> ps aux | grep 进程名

杀死进程：

> Kill -9 进程PID

# 查看文件：

> More （只能往后看）

> Less （可以往前也可以往后）

> （more空格翻页，空格下一行；less用方向键上下行；空格键 滚动一行回车键 滚动一页） 

> tail -f 文件名 （实时动态实时显示当前的日志）

> tail -f -n 100 文件名 查看最后（最近）100行

> hand -f -n 100 查看前100行

> （tail 和hand不能翻页，more和less可以） 

# 端口

> 查看端口是否被占用

> netstat  -anp | grep  端口号

> 结果中有Listen表示被占用

> （Ps：**LISTENING并不表示被占用**）

 

> 查看当前所有已经使用的端口情况

> netstat  -nultp（此处不用加端口号）