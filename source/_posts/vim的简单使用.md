---
title: vim的简单使用
date: 
description: vim的简单使用
tags: vim linux
top_img: transparent
cove:
---

转载来自:[Linux Vim编辑器的基本使用](hhttps://blog.csdn.net/hsforpyp/article/details/113833465)

### 一、[VIM](https://so.csdn.net/so/search?q=VIM&spm=1001.2101.3001.7020)编辑器

#### 1）vi概述

vi（visual editor）编辑器通常被简称为vi，它是Linux和Unix系统上最基本的文本编辑器，类似于Windows 系统下的notepad（记事本）编辑器。

#### 2）vim编辑器

Vim(Vi improved)是vi编辑器的加强版，比vi更容易使用。vi的命令几乎全部都可以在vim上使用。



#### 3）vim编辑器的安装

##### ☆ 已安装

Linux通常都已经默认安装好了 vi 或 Vim 文本编辑器，我们只需要通过vim命令就可以直接打开vim编辑器了，如下图所示：

![](https://img-blog.csdnimg.cn/20210218231103422.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hzRm9yUHlw,size_16,color_FFFFFF,t_70#pic_center)

##### ☆ 未安装

有些精简版的Linux操作系统，默认并没有安装vim编辑器（可能自带的是vi编辑器）。当我们在终端中输入vim命令时，系统会提示"command not found"。

解决办法：有网的前提下，可以使用yum工具对vim编辑器进行安装

```
# 安装vim且询问是否时自动选择yes

# yum install vim -y
```

#### 4）vim编辑器的四种模式（!）

##### ☆ 命令模式

使用VIM编辑器时，默认处于命令模式。在该模式下可以移动光标位置，可以通过快捷键对文件内容进行复制、粘贴、删除等操作。



##### ☆ 编辑模式或输入模式

在命令模式下输入小写字母a或小写字母i即可进入编辑模式，在该模式下可以对文件的内容进行编辑



##### ☆ 末行模式

在命令模式下输入冒号:即可进入末行模式，可以在末行输入命令来对文件进行查找、替换、保存、退出等操作



##### ☆ 可视化模式

可以做一些列选操作（通过方向键选择某些列的内容,类似于Windows鼠标刷黑）

### 二、VIM四种模式的关系

1）VIM四种模式

- 命令模式
- 编辑模式
- 末行模式
- 可视化模式

2）VIM四种模式的关系

![](https://img-blog.csdnimg.cn/20210217160304749.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hzRm9yUHlw,size_16,color_FFFFFF,t_70#pic_center)

### 三、VIM编辑器的使用

#### 1）使用vim打开文件

基本语法：

```
# vim  文件名称
```

① 如果文件已存在，则直接打开



② 如果文件不存在，则vim编辑器会自动在内存中创建一个新文件

案例：使用vim命令打开readme.txt文件

```
# vim readme.txt
```

#### 2）vim编辑器保存文件

在任何模式下，连续按两次Esc键，即可返回到命令模式。然后按冒号`:`，进入到末行模式，输入`wq`，代表保存并退出。

![](https://img-blog.csdnimg.cn/20210217161813558.png#pic_center)

#### 3）vim编辑器强制退出（不保存）

在任何模式下，连续按两次Esc键，即可返回到命令模式。然后按冒号：，进入到末行模式，输入q!，代表强制退出但是不保存文件。

![](https://img-blog.csdnimg.cn/20210217162129596.png#pic_center)

#### 4）命令模式下的相关操作（!）

##### ☆ 如何进入命令模式

答：在Linux操作系统中，当我们使用vim命令直接打开某个文件时，默认进入的就是命令模式。如果我们处于其他模式（编辑模式、可视化模式以及末行模式）可以连续按两次Esc键也可以返回命令模式

##### ☆ 命令模式下我们能做什么

① 移动光标 ② 复制 粘贴 ③ 剪切 粘贴 删除 ④ 撤销与恢复

##### ☆ 移动光标到首行或末行（!）

移动光标到首行 => gg

移动光标到末行 => G

##### ☆ 翻屏

向上 翻屏，按键：`ctrl + b （before） 或 PgUp`

向下 翻屏，按键：`ctrl + f （after） 或 PgDn`

向上翻半屏，按键：`ctrl + u （up）`

向下翻半屏，按键：`ctrl + d （down）`

##### ☆ 快速定位光标到指定行（!）

行号 + G，如150G代表快速移动光标到第150行。

##### ☆ 复制/粘贴（!）

① 复制当前行（光标所在那一行）

按键：yy

粘贴：在想要粘贴的地方按下p 键【将粘贴在光标所在行的下一行】,如果想粘贴在光标所在行之前，则使用P键



② 从当前行开始复制指定的行数，如复制5行，5yy

粘贴：在想要粘贴的地方按下p 键【将粘贴在光标所在行的下一行】,如果想粘贴在光标所在行之前，则使用P键

##### ☆ 剪切/删除（!）

在VIM编辑器中，剪切与删除都是dd



如果剪切了文件，但是没有使用p进行粘贴，就是删除操作

如果剪切了文件，然后使用p进行粘贴，这就是剪切操作



① 剪切/删除当前光标所在行

按键：dd （删除之后下一行上移）

粘贴：p

注意：dd 严格意义上说是剪切命令，但是如果剪切了不粘贴就是删除的效果。



② 剪切/删除多行（从当前光标所在行开始计算）

按键：数字dd

粘贴：p



③ 剪切/删除光标所在的当前行（光标所在位置）之后的内容，但是删除之后下一行不上移

按键：D （删除之后当前行会变成空白行）

##### 总结

① 怎么进入命令模式（vim 文件名称，在任意模式下，可以连续按两次Esc键即可返回命令模式）

② 命令模式能做什么？移动光标、复制/粘贴、剪切/删除、撤销与恢复

首行 => gg，末行 => G 翻屏（了解） 快速定位 行号G，如150G

yy p 5yy p

dd p 5dd p

u

ctrl + r

#### 5）末行模式下的相关操作（!）

##### ☆ 如何进入末行模式

进入末行模式的方法只有一个，在命令模式下使用冒号：的方式进入。

##### ☆ 末行模式下我们能做什么

文件保存、退出、查找与替换、显示行号、paste模式等等

##### ☆ 保存/退出（!）

:w => 代表对当前文件进行保存操作，但是其保存完成后，并没有退出这个文件

:q => 代表退出当前正在编辑的文件，但是一定要注意，文件必须先保存，然后才能退出

:wq => 代表文件先保存后退出（保存并退出）

如果一个文件在编辑时没有名字，则可以使用:wq 文件名称，代表把当前正在编辑的文件保存到指定的名称中，然后退出

:q! => 代表强制退出但是文件未保存（不建议使用）

##### ☆ 查找/搜索（!）

切换到命令模式，然后输入斜杠/（也是进入末行模式的方式之一）

进入到末行模式后，输入要查找或搜索的关键词，然后回车

如果在一个文件中，存在多个满足条件的结果。在搜索结果中切换上/下一个结果：N/n （大写N代表上一个结果，小写n代表next）

如果需要取消高亮，则需要在末行模式中输入:noh【no highlight】

##### ☆ 文件内容的替换（!）

第一步：首先要进入末行模式（在命令模式下输入冒号:）

第二步：根据需求替换内容

① 只替换光标所在这一行的第一个满足条件的结果（只能替换1次）

```
:s/要替换的关键词/替换后的关键词   +  回车
```

案例：把hello rhel中的 rhel替换为 rhel8

```
切换光标到hello  rhel这一行
:s/rhel/rhel8
```

② 替换光标所在这一行中的所有满足条件的结果（替换多次，只能替换一行）

```
:s/要替换的关键词/替换后的关键词/g		g=global全局替换
```

案例：把hello rhel中的所有rhel都替换为rhel8

```
切换光标到hello rhel这一行
:s/rhel/rhel8/g
```

③ 针对整个文档中的所有行进行替换，只替换每一行中满足条件的第一个结果

```
:%s/要替换的关键词/替换后的关键词
```

案例：把每一行中的第一个hello关键词都替换为hi

```
:%s/hello/hi
```