---
title: 数据库
date: 2022-09-07 12:19:00
description: 一些简单的Sql用法
tags: MySQL
top_img: transparent
---

# 数据库

> create database 库名  （创建数据库）
>
> drop database 库名     （删除数据库）

# 表

## 创建和删除

>create table 表名(字段1名  字段1属性  设置主键或外键,字段2名  字段2属性............)
>
>主键设置 primary key,
>
>外键设置 foreign key(属性名)  references 外键所属的表名(属性名)

> 删除表
>
> drop table 表名

## 修改

>增加外键
>
>alter table 表名 add constraint 外键约束名 foreign key(列名) references 引用外键表(列名)
>
>增加主键
>
>alter table 表名 add primary key(字段1，字段2)  
>
>删除外键
>
>alter table 表名  drop constraint 外键名
>
>增加一列
>
>alter table 表名  add 列名  列属性
>
>删除一列
>
>alter table 表名 drop 列名
>
>更改列名
>
>**exec sp_rename** '表名.列名','新列名','column';
>
>更改列的属性
>
>alter table   表名  alter **column** 列名  新属性

# 增删改查

## 增

> insert into 表名(属性名1,属性名2 .......) values(属性值1,属性值2，属性值3........);

## 删

> 删除记录
>
> delete from 表名 where 条件

## 改

> 更新记录
>
> updata 表名  set  列名 =  值 where  条件

# 单表查询

## 1.查询出生年份

```sql
select sname,2022 - age from stu
```

## 2.指定结果的显示列名

> select 列名1 as 显示名1,列名2 as 显示名2 ...........from   表名
>

```sql
select sname as nn,2022 - age as birth_year from stu
```

## 3.查询去重

> select **distinct**  列名  from  表名
>
> `一定要加列名，如果是` select **distinct**  *  from  表名  `这种写法没办法进行去重，因为没有指定去重目标`

## 4.like

> 如果不使用通配符，like就相当于=

### 4.1通配符%

> %表示任意字符出现任意次数（包含0次）
>
> 搜寻姓刘的学生

```sql
select * from stu where sname like '刘%'；
```

> 查询名字中有康的学生

```sql
select * from stu where sname like '%刘%'
```

### 4.2通配符_

>只适用于匹配单个字符,任意字符出现一次,不包含0；
>
>查找姓名第二个字为述的学生

```
select * from stu  where sname like '_述%'；
```

## 5.查询条件不等于的表示

> 查询时的不等于的表示是a<>b;表示a不等于b
>
> 还可以直接使用！=来表示

## 6.范围查询

> 1.使用不等式的组合来查询；
>
> 2.使用between.... and ....;
>
> 例：查询年龄18 到 20岁的名字

```sql
select sname from stu  where age>=18 and age <=20;
select sname from stu  where age between 18 and 20;
```



## 7.查询在某个集合里的记录（例：查询课程号为1或2的课程）

> 采用or连接条件或者使用in

```sql
select * from sc where cno = 1 or cno = 2;
select * from sc where cno in (1,2);
```

## 8.查询不在集合里的记录

> 使用not in
>
> 例：查询课程号不是1和2的课程

```
select * from sc where sno not in (1,2);
```

## 9.查询空或者非空

> 使用is null 和 is not null

# 聚集函数

## 1.order  by（排序）

> order  by默认是升序
>
> 例：查询学生成绩按升序排列

```sql
select  *  from sc order by  grade
```

> 直接order  by就是升序
>
> 要降序在后面加一个desc即可
>
> 例：查询学生成绩按降序序排列

```sql
select  *  from sc order by  grade desc
```

## 2.COUNT

> count(*)是统计总的记录数
>
> count(列名)统计某一列非空的记录数
>
> 例：统计学生总个数

```sql
select count(*) from stu
```

> 统计选修了课程的学生

```sql
select count(**distinct** sno) from sc
```

> `distinct`用于去除重复

## 3.AVG

> 计算指定列的平均值(必须是数的类型，varchar这种无法使用)
>
> 例：计算选修了20201号课程的学生平均成绩

```sql
select AVG(grade) from sc where cno = 20201
```

## 4.max  min

>计算指定列的最大最小值
>
>例：计算选修了20201号课程的学生最高,最低成绩

```sql
select max(grade) , min(grade)   from sc where cno = 20201
```

## 5.group by

> 以指定的列来进行分组
>
> 例：查询各课程号及其选修人数

```sql
select cno , count(sno)  as num from sc group by cno
```

> `PS:group by 如果要加条件，不能用where 要用HAVING`

## 6.聚集函数不能用在where后

> 在where之后不能使用聚集函数来做条件，如果要是用聚集函数当条件要用HAVING,配合group by一起使用
>
> 例：查询平均成绩大于90的学生学号和平均成绩

```sql
select sno , AVG(grade)  from  sc  group  by  sno  HAVING  AVG(grade) >= 90  
```

# 多表查询

## 1.连接查询

### 1.1等值查询

> 例：查询每个学生的信息和其选修课的信息

```sql
select stu.* , sc.* from stu , sc where stu.sno = sc.sno
```

> 查询选修了20201课程的学生姓名

```sql
select sname from stu , sc where stu.sno = sc.sno and sc.cno = '20201'
```

### 1.2左外连接

> 例：查询所有学生都信息和其选课信息，没有选课的学生也显示出来

```sql
select stu.* , sc.* from stu `left outer join` sc  `on`  stu.sno = sc.sno
```

> 注意是用on不是用where，outer可以省略
>
> 查询每个专业的学生人数，但是有点专业没有人

```sql
select  major.mno , count(sno) from major left join stu  on major.mno = stu.mno group by major.mno
```

> 注意group by的位置，使用分组的时候必须在group by之后，连接时要先连接在分组

## 2.嵌套查询

### 2.1不相关查询（子查询不依赖父查询）

>查询选修了20201课程的学生姓名

```sql
select sname from stu  where sno in (select sno from sc where cno = '20201')
```

>注意用的是in，因为返回结果有多个，要是子查询结果只有一个可以用 = ，但是一般都是用in

### 2.2相关嵌套查询

>查询选修了20201课程的学生姓名

```sql
select sname from stu  where '20201'  in (select cno  from sc where sc.sno = stu.sno)
```

>查询选修了c语言课程的学生学号

```sql
select sno from sc where 'C语言' in (select cname from cou where sc.cno = cou.cno)
```

>查询每个学生超过他平均成绩的课程号

```sql
select sno,cno from sc x where grade > (select AVG(grade) from sc y group by sno  HAVING  x.sno = y.sno)
```

>还可以使用派生表

```sql
select sno , cno from sc,(select sno,AVG(grade)  from sc group by sno ) as avg_sc(avg_sno,avg_grade)

where sc.sno = avg_sc.avg_sno  and  sc.grade > avg_sc.avg_grade
```

## 3.带exists的查询

>查询选修了20201课程的学生姓名

```sql
select sname from stu  where  exists   (select   *  from sc where  sc.sno = stu.sno)
```

>`PS:exists()只会返回true或者false，他会在stu中选一行，进行匹配，匹配成功为true，证明这一行为所要查询的`

## 4.集合查询

### 4.1 并/或（union）

>查询选修了20201 或 20203课程的学号

```sql
select sno from sc  where cno = '20201'  union  select sno from sc  where cno = '20203' 
```

>两条记录进行合并并且会去重

### 4.2交（intersect）

>查询年龄是18且mno为1的学生的学号

```sql
select  sno from stu  where age = 18  **intersect**  select  sno from stu  where mno= 1
```

### 4.3差（except ）

>查询年龄是18且mno为1的学生的学号

```sql
select  sno from stu  where age = 18  except  select  sno from stu  where mno != 1
```

# 视图

## 1.概念

>视图是从一个或几个基本表(或视图)导出的表。不同的是，它是一个虚表，数据库中只存放视图的定义，而不存放视图对应的数据，这些数据仍然存放在原本的基本表中。所以一旦基本表发生变化，从视图中查询的数据也就随之改变。
>
>作用之一:视图更加方便用户的查询.

## 2.创建视图

> creat view 视图名 as 查询语句
>
> 例：建立一个查询学生姓名，学号，年龄的视图

```sql
create view v_stu as select sname , age , sno  from stu
```

> 注意：时如果有列是聚集函数计算出来的，比如sum，avg这些计算出来的，会没有列名，那么定义视图时必须给他们定义一个列名

## 3.利用视图进行查询

> 视图的查询和表的查询是一样的

## 4.修改

> alter   view 视图名 as 查询语句

## 5.删除

> drop view  视图名

# 存储过程

## 1.定义

> 存储过程是事先经过编译并保存在数据库中的一段SQL语句集合，使用时调用即可

## 2.创建存储过程

### 2.1无参

> create proc  名字
>
> as
>
> begin
>
> 想要执行的查询语句
>
> end

### 2.2有参

>create proc  名字  @ 参数1  参数1的类型 ,  @参数2  参数2的类型 , ........
>
>as
>
>begin
>
>想要执行的查询语句
>
>end
>
>例：查询某学生指定课程号的成绩和学分

```sql
create proc  p1  @sno  varchar(13) ,  @cno  varchar(13)  

as

begin

select sc.* , cou.ccredit from sc ,cou  where sc.cno = @cno  and sc.cno = cou.cno  and sno = @sno

end
```



## 3.执行存储过程

> exec  名字
>
> exec 名字  参数1，参数2

## 4.修改

> alter proc 名字 +修改的内容
>
> 无参的可以修改为有参的
>
> 例：

```
alert  proc  p1  @sno  varchar(13) ,  @cno  varchar(13)  

as

begin

select sc.* , cou.ccredit from sc ,cou  where sc.cno = @cno  and sc.cno = cou.cno  and sno = @sno

end
```

## 5.删除

> drop  proc  名字

# 触发器

## 1.概念

>监视某种情况，并触发某种操作，当对一个表格进行增删改就有可能自动激活执行它
>
>一个表可以创建多个 After触发器，但只能创建一个 instead of触发器
>
>after
>  这类触发器是在记录已经被修改完，事务已提交后被触发执行。主要用记录变更后的处理或检查，一旦发现BUG，可以使用ROLLBACK TRANSACTION语句回滚本次操作。
>
>instead of
>  这类触发器不去执行其定义的操作（Insert、update、delete），交给触发器执行，触发器检查操作是否正确，若正确则执行操作。这类触发器用来取代原本的操作，在记录变更之前被触发。

## 2.创建触发器

> create  trigger  触发器名  on  表名
>
> after  /instead of（之前/之后）
>
> update/delete/insert （改/删/增）
>
> as 
> begin
> 	代码段
> end

## 3.例子

> stu学生表人数不能超过17
>
> **写法1：**

```sql
create trigger t1 on stu after insert

as

begin

	if  (select count(*) from stu) > 17

	begin

			print 'error'

			rollback tran

	end

	else

	begin

			print 'right'

	end

end
```

> 正常插入
>
> ![image-20220423100325837](https://cdn.jsdelivr.net/gh/liushuhuang/PicGo@main/img/202209171041291.png)
>
> 
> 
> 超过17
> 
> ![image-20220423100400815](https://cdn.jsdelivr.net/gh/liushuhuang/PicGo@main/img/202209171042622.png)

> **写法2**

```sql
create trigger t1 on stu instead of  insert

as

begin

	if  (select count(*) from stu) > 16

	begin

			print 'error'

			rollback tran

	end

	else

	begin

			print 'right'

			declare @sno varchar(13)

			declare @sname varchar(30)

			declare @age int

			declare @sex bit

			declare @mno int 

			select @sno = sno from inserted

			select @sname = sname from inserted

			select @age = age from inserted

			select @sex = sex from inserted

			select @mno = mno from inserted

			insert into stu values(@sno,@sname,@age,@sex,@mno)

	end

end
```

> **解释**：(1) inserted是一个表，在插入之前数据会保存在这个表李（还有deleted表，是在删除前会存在里面）
>
> ​			(2) 插入的参数也可以不写全，看自己的需求

> 例2：stu表不能少于16人
>
> 写法1：

```sql
create trigger t1 on stu instead of delete

as

begin

if  (select count(*) from stu) < 17

begin

		print 'error'

		rollback tran

end

else

begin

		print 'right'
		declare @sno varchar(13)
		select  @sno = sno from deleted
		delete from stu where sno = @sno

end


end
```

> 写法2

```sql
create trigger t1 on stu after delete

as

begin

	if  (select count(*) from stu) < 17

	begin

			print 'error'

			rollback tran

	end

	else

	begin

			print 'right'

	end

end
```

> 例3：当新增学生分数位55-59，将分数改为60

```sql
create trigger t2 on sc instead of insert
as
begin
	declare @sno varchar(13)
	declare @cno varchar(13)
	declare @grade decimal(5, 2)
	select @sno = sno from inserted
	select @cno = cno from inserted
	select @grade = grade from inserted
	if @grade >= 55 and @grade <=59
		begin
			set @grade = 60
		end
	insert into sc(sno,cno,grade) values(@sno,@cno,@grade)
end
```

# 函数

## 1.概念

> 类似avg，sum这种就是函数，他和存储过程很像，但是会有返回值
>
> 用户可以自定义自己的函数

## 2.定义一个函数

> create function  函数名 （参数1 参数1的类型，参数2  参数2的类型，....）
>
> returns  返回值类型
>
> as
>
> begin
>
> ​		执行语句
>
> ​		return  返回值
>
> end

## 3.执行函数

> select   dbo.函数名（参数1，参数2，...） 

## 4.例子

> 例1：计算某门课的平均分
>
> 创建

```sql
create function fun1 (@cno varchar(13))
returns int
as
begin
	declare @avggrade int
	select @avggrade = avg(grade) from sc where @cno = cno
	return @avggrade
end
```

> 执行

```sql
select dbo.fun1('20202')
```

> 例2：输入专业号，返回该专业学生学号和姓名
>
> 创建

```sql
create function fun2 (@mno varchar(13))
returns @Snosname table(
	sno varchar(13),
	sname varchar(30)
)
as
begin
	insert into @Snosname(sno,sname) select sno,sname from stu where @mno = mno
	return
end
```

> 执行

```sql
select * from fun2(1)
```

> 例3：输入专业号返回这个专业所有学生每个课程对于成绩的一个表
>
> 创建

```sql
create function fun3(@mno varchar(13))
returns @Snograde table(
	sno varchar(13),
	cno varchar(30),
	grade decimal(5, 2)
)
as
begin
	insert into @Snograde(sno,cno,grade) select sno,cno,grade from sc where sno in (select sno from stu where @mno = mno)
	return
end
```

# 索引

## 1.概念

> 概念:索引是对数据库表中的一列或多列值进行排序的一种结构
>
> 目的是为了加快查询到速度，但是会占用一定的存储空间需要更新和维护

## 2.什么时候不创建

>1.频繁更新的字段或者经常增删改的字段，不适合创建索引（频繁变化导致索引也频繁变化，增大数据库工作量，降低效率。）
>
>2.表的记录较少，不适合（不需要）建立索引
>
>3.如果某列的数据重复数据过多，不适合创建索引（例：性别只有男，女之分，这种值不适合建立索引）
>
>4.字段不在where语句出现时不要添加索引，如果where后含IS NULL 或IS NOT NULL或 like ‘%输入符%’等条件，不建议使用索引。只有在where语句出现，mysql才会去使用索引。

## 3.索引失效

>1.有or必须条件全有索引，有一个没有索引，其他的有索引也会失效;
>2.复合索引未用左列字段（复合索引必须要使用最左边的第一列，只有加了这一列，复合索引后面的才会生效）;
>3.like以%开头，索引失效;
>4.需要类型转换，索引失效;
>5.where中索引列有运算，索引失效;
>6.where中索引列使用了函数，索引失效;
>7.如果mysql觉得全表扫描更快时（数据少），会自动进行全表扫描忽略索引，索引失效;

## 4.聚集索引和非聚集索引

## 1.概念

> 聚集索引：数据行的物理顺序和列值（一般是主键那列）的逻辑顺序相同，一个表只能有一个聚集索引
>
> 非聚集索引：数据行的物理顺序和列值的逻辑顺序可能不相同，一个表只能有一个或多个非聚集索引

## 2.创建

> create  index  索引名  on  表名  （列名1  限制1 ，列名2  限制2）

> 例：按学号升序，课程号降序创建唯一索引

```sql
create unique index scno on sc (sno asc,cno desc)
```

## 3.删除

> drop index 索引名 on  表名
>
> 例：

```sql
drop index scno on sc
```

## 4.既然HASH比B+树更快，为什么MYSQL用B+树来存储索引呢？

>MySQL中存储索引用到的数据结构是B+树，B+树的查询时间跟树的高度有关，是log(n)，如果用hash存储，那么查询时间是O(1)。
>
>采用Hash来存储确实要更快，但是采用B+树来存储索引的原因主要有以下两点：
>
>一、从内存角度上说，数据库中的索引一般是在磁盘上，数据量大的情况可能无法一次性装入内存， B+树的设计可以允许数据分批加载。
>
>二、从业务场景上说，如果只选择一个数据那确实是hash更快，但是数据库中经常会选中多条，这时候 由于B+树索引有序，并且又有链表相连，它的查询效率比hash就快很多了

