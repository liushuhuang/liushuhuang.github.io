---
title: Amq学习
date: 2022-9-20 15:11:00
description: Amq学习笔记
tags: Amq  mq
top_img: transparent
cover: 
---

# MQ学习前言

[b站学习视频链接](https://www.bilibili.com/video/BV164411G7aB?p=4&spm_id_from=pageDriver&vd_source=a80e07578090034c5f50287c46855074)

## 1.1 消息

​	消息以一种双方约定好的格式作为一种信息的载体媒介，在网络上进行传输，以实现信息同步和资源的交换

## 1.2 中间件

>中间件（英语：Middleware）顾名思义是系统软件和用户应用软件之间连接的软件，以便于软件各部件之间的沟通，特别是应用软件对于系统软件的集中的逻辑，是一种独立的系统软件或服务程序，[分布式](https://so.csdn.net/so/search?q=分布式&spm=1001.2101.3001.7020)应用软件借助这种软件在不同的技术之间共享资源。中间件在客户服务器的操作系统、网络和数据库之上，管理计算资源和网络通信。总的作用是为处于自己上层的应用软件提供运行与开发的环境，帮助用户灵活、高效地开发和集成复杂的应用软件。
>
>也就是说，关于中间件，我们可以理解为：是一类能够为一种或多种应用程序合作互通、资源共享，同时还能够为该应用程序提供相关的服务的软件。中间件是一类软件统称，而非一种软件;中间件不仅仅实现互连，还要实现应用之间的互操作。

## 1.3 什么是MQ

> MQ全称为Message Queue, 消息队列（MQ）是一种应用程序对应用程序的通信方法。应用程序通过读写出入队列的消息（针对应用程序的数据）来通信，而无需专用连接来链接它们。消息传递指的是程序之间通过在消息中发送数据进行通信，而不是通过直接调用彼此来通信，直接调用通常是用于诸如远程过程调用的技术。排队指的是应用程序通过队列来通信。队列的使用除去了接收和发送应用程序同时执行的要求。

>是指利用高效可靠的消息传递机制进行与平台无关的数据交流，并基于数据通信来进行分布式系统的集成。
>通过提供消息传递和消息排队模型在分布式环境下提供应用解耦、弹性伸缩、冗余存储、流量削峰、异步通信、数据同步等功能。
>
>
>
>大致的过程是这样的:
>
>
>
>发送者把消息发送给消息服务器，消息服务器将消息存放在若干**队列/主题**中，在合适的时候，消息服务器会将消息转发给接受者。在这个过程中，发送和接受是异步的，也就是发送无需等待，而且发送者和接受者的生命周期也没有必然关系;
>
>
>
>尤其在发布pub/订阅sub模式下，也可以完成一对多的通信，即让一个消息有多个接受者。

### 1.3.1 

##  1.3 为什么要用MQ

此部分转载于[CSDN博文](https://blog.csdn.net/lisu061714112/article/details/116465216)

### 1. 传统模式有哪些痛点？

#### 1.1 痛点1

> 有些复杂的业务系统，一次用户请求可能会同步调用N个系统的接口，需要等待所有的接口都返回了，才能真正的获取执行结果。

![2 (2)](https://img-blog.csdnimg.cn/2021050622512343.png)

> 这种同步接口调用的方式总耗时比较长，非常影响用户的体验，特别是在网络不稳定的情况下，极容易出现接口超时问题。

#### 1.2 痛点2

> 很多复杂的业务系统，一般都会拆分成多个子系统。我们在这里以用户下单为例，请求会先通过订单系统，然后分别调用：支付系统、库存系统、积分系统 和 物流系统。

![2](https://img-blog.csdnimg.cn/20210506225143161.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

> 系统之间耦合性太高，如果调用的任何一个子系统出现异常，整个请求都会异常，对系统的稳定性非常不利。

#### 1.3 痛点3

> 有时候为了吸引用户，我们会搞一些活动，比如秒杀等。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210506225201511.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

> 如果用户少还好，不会影响系统的稳定性。但如果用户突增，一时间所有的请求都到数据库，可能会导致数据库无法承受这么大的压力，响应变慢或者直接挂掉。

![](https://img-blog.csdnimg.cn/2021050622520953.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

> 对于这种突然出现的请求峰值，无法保证系统的稳定性。

### 2 为什么要用mq？

> 对于上面传统模式的三类问题，我们使用mq就能轻松解决。

#### 2.1 异步

> 对于痛点1：同步接口调用导致响应时间长的问题，使用mq之后，将同步调用改成异步，能够显著减少系统响应时间。

![2.1](https://img-blog.csdnimg.cn/20210506225226300.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

> 系统A作为消息的生产者，在完成本职工作后，就能直接返回结果了。而无需等待消息消费者的返回，它们最终会独立完成所有的业务功能。
>
> 
>
> 这样能避免总耗时比较长，从而影响用户的体验的问题。

#### 2.2 解耦

>对于痛点2：子系统间耦合性太大的问题，使用mq之后，我们只需要依赖于mq，避免了各个子系统间的强依赖问题。

![](https://img-blog.csdnimg.cn/20210506225244715.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>订单系统作为消息生产者，保证它自己没有异常即可，不会受到支付系统等业务子系统的异常影响，并且各个消费者业务子系统之间，也互不影响。
>
>
>
>这样就把之前复杂的业务子系统的依赖关系，转换为只依赖于mq的简单依赖，从而显著的降低了系统间的耦合度。

#### 2.3 消峰

>对于痛点3：由于突然出现的请求峰值，导致系统不稳定的问题。使用mq后，能够起到消峰的作用。

![](https://img-blog.csdnimg.cn/20210506225301831.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

> 订单系统接收到用户请求之后，将请求直接发送到mq，然后订单消费者从mq中消费消息，做写库操作。如果出现请求峰值的情况，由于消费者的消费能力有限，会按照自己的节奏来消费消息，多的请求不处理，保留在mq的队列中，不会对系统的稳定性造成影响。

## 1.4引入mq会多哪些问题？

此部分转载于[CSDN博文](https://blog.csdn.net/lisu061714112/article/details/116465216)



>引入mq后让我们子系统间耦合性降低了，异步处理机制减少了系统的响应时间，同时能够有效的应对请求峰值问题，提升系统的稳定性。
>
>
>
>但是，引入mq同时也会带来一些问题。

### 1. 重复消息问题

> 重复消费问题可以说是mq中普遍存在的问题，不管你用哪种mq都无法避免。
>
> 
>
> 有哪些场景会出现重复的消息呢？
>
> 
>
> 1.消息生产者产生了重复的消息
> 2.kafka和rocketmq的offset被回调了
> 3.消息消费者确认失败
> 4.消息消费者确认时超时了
> 5.业务系统主动发起重试

![](https://img-blog.csdnimg.cn/20210506225342468.png)

>如果重复消息不做正确的处理，会对业务造成很大的影响，产生重复的数据，或者导致数据异常，比如会员系统多开通了一个月的会员。

### 2. 数据一致性问题

> 很多时候，如果mq的消费者业务处理异常的话，就会出现数据一致性问题。比如：一个完整的业务流程是，下单成功之后，送100个积分。下单写库了，但是消息消费者在送积分的时候失败了，就会造成数据不一致的情况，即该业务流程的部分数据写库了，另外一部分没有写库。

![](https://img-blog.csdnimg.cn/20210506225356808.png)

>如果下单和送积分在同一个事务中，要么同时成功，要么同时失败，是不会出现数据一致性问题的。
>
>
>
>但由于跨系统调用，为了性能考虑，一般不会使用强一致性的方案，而改成达成最终一致性即可。

### 3. 消息丢失问题

>同样消息丢失问题，也是mq中普遍存在的问题，不管你用哪种mq都无法避免。
>
>
>
>有哪些场景会出现消息丢失问题呢？
>
>
>
>1.消息生产者发生消息时，由于网络原因，发生到mq失败了。
>2.mq服务器持久化时，磁盘出现异常
>3.kafka和rocketmq的offset被回调时，略过了很多消息。
>4.消息消费者刚读取消息，已经ack确认了，但业务还没处理完，服务就被重启了。
>导致消息丢失问题的原因挺多的，生产者、mq服务器、消费者 都有可能产生问题，我在这里就不一一列举了。最终的结果会导致消费者无法正确的处理消息，而导致数据不一致的情况。

### 4. 消息顺序问题

> 有些业务数据是有状态的，比如订单有：下单、支付、完成、退货等状态，如果订单数据作为消息体，就会涉及顺序问题了。如果消费者收到同一个订单的两条消息，第一条消息的状态是下单，第二条消息的状态是支付，这是没问题的。但如果第一条消息的状态是支付，第二条消息的状态是下单就会有问题了，没有下单就先支付了？

![](https://img-blog.csdnimg.cn/20210506225535443.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>消息顺序问题是一个非常棘手的问题，比如：
>
>- kafka同一个partition中能保证顺序，但是不同的partition无法保证顺序。
>- rabbitmq的同一个queue能够保证顺序，但是如果多个消费者同一个queue也会有顺序问题。如果消费者使用多线程消费消息，也无法保证顺序。
>
>如果消费消息时同一个订单的多条消息中，中间的一条消息出现异常情况，顺序将会被打乱。
>
>
>
>还有如果生产者发送到mq中的路由规则，跟消费者不一样，也无法保证顺序。

### 5. 消息堆积

> 如果消息消费者读取消息的速度，能够跟上消息生产者的节奏，那么整套mq机制就能发挥最大作用。但是很多时候，由于某些批处理，或者其他原因，导致消息消费的速度小于生产的速度。这样会直接导致消息堆积问题，从而影响业务功能。

![](https://img-blog.csdnimg.cn/20210506225558431.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>这里以下单开通会员为例，如果消息出现堆积，会导致用户下单之后，很久之后才能变成会员，这种情况肯定会引起大量用户投诉。

### 6. 系统复杂度提升

>这里说的系统复杂度和系统耦合性是不一样的，比如以前只有：系统A、系统B和系统C 这三个系统，现在引入mq之后，你除了需要关注前面三个系统之外，还需要关注mq服务，需要关注的点越多，系统的复杂度越高。

![](https://img-blog.csdnimg.cn/20210506225613813.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>mq的机制需要：生产者、mq服务器、消费者。
>
>
>
>有一定的学习成本，需要额外部署mq服务器，而且有些mq比如：rocketmq，功能非常强大，用法有点复杂，如果使用不好，会出现很多问题。有些问题，不像接口调用那么容易排查，从而导致系统的复杂度提升了。

## 1.5 如何解决这些问题？

此部分转载于[CSDN博文](https://blog.csdn.net/lisu061714112/article/details/116465216)



>mq是一种趋势，总体来说对我们的系统是利大于弊的难道因为它会出现一些问题，我们就不用它了？
>
>那么我们要如何解决这些问题呢？

### 1. 重复消息问题

>不管是由于生产者产生的重复消息，还是由于消费者导致的重复消息，我们都可以在消费者中这个问题。
>
>
>
>这就要求消费者在做业务处理时，要做幂等设计，如果有不知道如何设计的朋友，可以参考《高并发下如何保证接口的幂等性？》，里面介绍得非常详情。
>
>
>
>在这里我推荐增加一张消费消息表，来解决mq的这类问题。消费消息表中，使用messageId做唯一索引，在处理业务逻辑之前，先根据messageId查询一下该消息有没有处理过，如果已经处理过了则直接返回成功，如果没有处理过，则继续做业务处理。

![](https://img-blog.csdnimg.cn/20210506225639741.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

### 2. 数据一致性问题

>我们都知道数据一致性分为：
>
>- 强一致性
>- 弱一致性
>- 最终一致性
>  而mq为了性能考虑使用的是最终一致性，那么必定会出现数据不一致的问题。这类问题大概率是因为消费者读取消息后，业务逻辑处理失败导致的，这时候可以增加重试机制。
>
>重试分为：同步重试 和 异步重试。
>
>
>
>有些消息量比较小的业务场景，可以采用同步重试，在消费消息时如果处理失败，立刻重试3-5次，如何还是失败，则写入到记录表中。但如果消息量比较大，则不建议使用这种方式，因为如果出现网络异常，可能会导致大量的消息不断重试，影响消息读取速度，造成消息堆积。

![](https://img-blog.csdnimg.cn/20210506225701468.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>而消息量比较大的业务场景，建议采用异步重试，在消费者处理失败之后，立刻写入重试表，有个job专门定时重试。
>
>
>
>还有一种做法是，如果消费失败，自己给同一个topic发一条消息，在后面的某个时间点，自己又会消费到那条消息，起到了重试的效果。如果对消息顺序要求不高的场景，可以使用这种方式。

### 3. 消息丢失问题

>不管你是否承认有时候消息真的会丢，即使这种概率非常小，也会对业务有影响。生产者、mq服务器、消费者都有可能会导致消息丢失的问题。
>
>
>
>为了解决这个问题，我们可以增加一张消息发送表，当生产者发完消息之后，会往该表中写入一条数据，状态status标记为待确认。如果消费者读取消息之后，调用生产者的api更新该消息的status为已确认。有个job，每隔一段时间检查一次消息发送表，如果5分钟（这个时间可以根据实际情况来定）后还有状态是待确认的消息，则认为该消息已经丢失了，重新发条消息。
>

![](https://img-blog.csdnimg.cn/20210506225721333.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>这样不管是由于生产者、mq服务器、还是消费者导致的消息丢失问题，job都会重新发消息。

### 4. 消息顺序问题

>消息顺序问题是我们非常常见的问题，我们以kafka消费订单消息为例。订单有：下单、支付、完成、退货等状态，这些状态是有先后顺序的，如果顺序错了会导致业务异常。
>
>
>
>解决这类问题之前，我们先确认一下，消费者是否真的需要知道中间状态，只知道最终状态行不行？

![](https://img-blog.csdnimg.cn/20210506225733571.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>其实很多时候，我真的需要知道的是最终状态，这时可以把流程优化一下：

![](https://img-blog.csdnimg.cn/20210506225743780.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>这种方式可以解决大部分的消息顺序问题。
>
>
>
>但如果真的有需要保证消息顺序的需求。订单号路由到不同的partition，同一个订单号的消息，每次到发到同一个partition。

### 5. 消息堆积

>如果消费者消费消息的速度小于生产者生产消息的速度，将会出现消息堆积问题。其实这类问题产生的原因很多，如果你想进一步了解，可以看看我的另一篇文章《我用kafka两年踩过的一些非比寻常的坑》。
>
>
>
>那么消息堆积问题该如何解决呢？
>
>
>
>这个要看消息是否需要保证顺序。
>
>
>
>如果不需要保证顺序，可以读取消息之后用多线程处理业务逻辑。

![](https://img-blog.csdnimg.cn/20210506225808736.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)

>这样就能增加业务逻辑处理速度，解决消息堆积问题。但是线程池的核心线程数和最大线程数需要合理配置，不然可能会浪费系统资源。
>
>
>
>如果需要保证顺序，可以读取消息之后，将消息按照一定的规则分发到多个队列中，然后在队列中用单线程处理。

![](https://img-blog.csdnimg.cn/20210506225817897.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpc3UwNjE3MTQxMTI=,size_16,color_FFFFFF,t_70)