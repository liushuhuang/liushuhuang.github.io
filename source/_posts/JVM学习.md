---
title: JVM学习
date: 2022-11-17
description: JVM学习笔记
tags: JVM
top_img: transparent
cover: 
---



## JVM基础知识

![image-20221117140410429](https://cdn.jsdelivr.net/gh/liushuhuang/PicGo@main/img/image-20221117140410429.png)

![image-20221117140556010](D:\blog\liushuhuang.github.io\source\_posts\image-20221117140556010.png)

![image-20221117140633662](https://cdn.jsdelivr.net/gh/liushuhuang/PicGo@main/img/image-20221117140633662.png)

## GC

![image-20221117140902775](https://cdn.jsdelivr.net/gh/liushuhuang/PicGo@main/img/image-20221117140902775.png)

![image-20221117141604984](D:\blog\liushuhuang.github.io\source\_posts\image-20221117141604984.png)

避免full GC





![image-20221117141643124](D:\blog\liushuhuang.github.io\source\_posts\image-20221117141643124.png)

为什么要有个S区？

加入年轻的只有一个区域，可回收的空间回收之后变成了碎片  内存利用率低  





![image-20221117142129987](D:\blog\liushuhuang.github.io\source\_posts\image-20221117142129987.png)



![image-20221117142824087](D:\blog\liushuhuang.github.io\source\_posts\image-20221117142824087.png)









jps命令查看java进程

jstat -gcutil   进程Id  GC信息显示时间间隔   查看进程GC信息

例：jstat -gcutil  1111  1000  每隔一秒显示一次GC信息

GC信息各字段解释：

![image-20221117144550372](D:\blog\liushuhuang.github.io\source\_posts\image-20221117144550372.png)



YGC：youngGC的次数

YGCT：youngGC占用时间

FGC：FullGC的次数

FGCT：FullGC占用时间





![image-20221117144026347](D:\blog\liushuhuang.github.io\source\_posts\image-20221117144026347.png)





![image-20221117144318498](D:\blog\liushuhuang.github.io\source\_posts\image-20221117144318498.png)







![image-20221117144800517](D:\blog\liushuhuang.github.io\source\_posts\image-20221117144800517.png)

收集器也是面向"代"的







![image-20221117145107289](D:\blog\liushuhuang.github.io\source\_posts\image-20221117145107289.png)







![image-20221117145407696](D:\blog\liushuhuang.github.io\source\_posts\image-20221117145407696.png)

![image-20221117145650974](D:\blog\liushuhuang.github.io\source\_posts\image-20221117145650974.png)

![image-20221117150932698](D:\blog\liushuhuang.github.io\source\_posts\image-20221117150932698.png)

![image-20221117151232037](D:\blog\liushuhuang.github.io\source\_posts\image-20221117151232037.png)

![image-20221117151937066](D:\blog\liushuhuang.github.io\source\_posts\image-20221117151937066.png)

年轻代显示总共只有9M，是因为有1M的S区是不会使用的





![image-20221117154425746](D:\blog\liushuhuang.github.io\source\_posts\image-20221117154425746.png)

![image-20221117154452616](D:\blog\liushuhuang.github.io\source\_posts\image-20221117154452616.png)

![image-20221117154637094](D:\blog\liushuhuang.github.io\source\_posts\image-20221117154637094.png)

![image-20221117154744143](D:\blog\liushuhuang.github.io\source\_posts\image-20221117154744143.png)

![image-20221117155319163](D:\blog\liushuhuang.github.io\source\_posts\image-20221117155319163.png)





ThreadLocal的内存泄露

ThreadLocal是key value的形式存储值的，但是key是弱引用，在GC的时候会被回收，但是value是强引用，无法在GC的时候进行回收，而一旦key被回收了，对应的value就用韵存在那里了，就产生了内存泄漏