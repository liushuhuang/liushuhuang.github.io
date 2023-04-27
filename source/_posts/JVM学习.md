---
title: JVM学习
date: 2022-11-17
description: JVM学习笔记
tags: JVM
top_img: transparent
cover: 
---



## JVM基础知识

![image-20221117140556010](https://s2.loli.net/2023/04/27/x1mh2PCgZK7M6e9.png)

![image-20221117140633662](https://s2.loli.net/2023/04/27/cx8AL9rM71oYvpg.png)

## GC

![image-20221117140902775](https://s2.loli.net/2023/04/27/qdy3AzHhiWOZpg1.png)

![image-20221117141604984](https://s2.loli.net/2023/04/27/bDtalV8jhTikLur.png)

避免full GC





![image-20221117141643124](https://s2.loli.net/2023/04/27/x5VTljHLCafRh4I.png)

为什么要有个S区？

加入年轻的只有一个区域，可回收的空间回收之后变成了碎片  内存利用率低  





![image-20221117142129987](https://s2.loli.net/2023/04/27/8JpBi5h6VmeQDjR.png)



![image-20221117142824087](https://s2.loli.net/2023/04/27/cpV82qvsizk76RG.png)









jps命令查看java进程

jstat -gcutil   进程Id  GC信息显示时间间隔   查看进程GC信息

例：jstat -gcutil  1111  1000  每隔一秒显示一次GC信息

GC信息各字段解释：

![image-20221117144550372](https://s2.loli.net/2023/04/27/oF3fyzQrUPMAH4k.png)



YGC：youngGC的次数

YGCT：youngGC占用时间

FGC：FullGC的次数

FGCT：FullGC占用时间





![image-20221117144026347](https://s2.loli.net/2023/04/27/Xz2CAVE1PMTItbw.png)





![image-20221117144318498](https://s2.loli.net/2023/04/27/sMdXIzc8Guwvi6p.png)







![image-20221117144800517](https://s2.loli.net/2023/04/27/m1iNpwJlCfqQeGy.png)

收集器也是面向"代"的







![image-20221117145107289](https://s2.loli.net/2023/04/27/s4YoFRLqKbxAdwO.png)







![image-20221117145407696](https://s2.loli.net/2023/04/27/qnoZFUSxtplRyGh.png)

![image-20221117145650974](https://s2.loli.net/2023/04/27/gO3AtENycKDIVYd.png)

![image-20221117150932698](https://s2.loli.net/2023/04/27/c8HGVxY9IAbTBuE.png)

![image-20221117151232037](https://s2.loli.net/2023/04/27/xJP3BR2a7S6cjLA.png)

![image-20221117151937066](https://s2.loli.net/2023/04/27/ZnzvKYUTcNdpPmq.png)

年轻代显示总共只有9M，是因为有1M的S区是不会使用的





![image-20221117154425746](https://s2.loli.net/2023/04/27/73EpVJ8roRkNCg1.png)

![image-20221117154452616](https://s2.loli.net/2023/04/27/LXTVdlNPnFJujr5.png)

![image-20221117154637094](https://s2.loli.net/2023/04/27/XK7PZMGHnlzo5sQ.png)

![image-20221117154744143](https://s2.loli.net/2023/04/27/pGai8Z64QvLP7hy.png)

![image-20221117155319163](https://s2.loli.net/2023/04/27/xP5rXaqni1SzC8R.png)





ThreadLocal的内存泄露

ThreadLocal是key value的形式存储值的，但是key是弱引用，在GC的时候会被回收，但是value是强引用，无法在GC的时候进行回收，而一旦key被回收了，对应的value就用韵存在那里了，就产生了内存泄漏