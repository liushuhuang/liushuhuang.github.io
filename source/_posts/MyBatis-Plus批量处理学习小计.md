---
title: Mabatis-Plus 批量处理学习
date: 
description: Mabatis-Plus 批量处理学习
tags: Mabatis-Plus
top_img: transparent
cover: 
---



转载说明：参考自CSDN博文，[原文链接](https://blog.csdn.net/qq_37436172/article/details/129519035)

## Mabatis-Plus

[简介](https://baomidou.com/pages/24112f/)

简单来说就是一个对`Mybatis`进行功能加强的工具

## MyBatis-Plus批量处理功能

### 1.功能实现

`MyBatis-Plus`的批量任务是在service层实现的，接口为：`IService`，主要的方法包括`updateBatchById（批量修改）`、`saveOrUpdateBatch（批量新增或修改）` 、`removeBatchByIds（批量删除）`

### 2.实际使用

如果想要使用`MyBatis-Plus`的批量操作功能，最简单的方法就是创建一个`service`类，并继承`ServiceImpl`类，之后直接调用对应的批量操作方法即可

### 3.功能原理分析

以`updateBatchById`方法进行分析，默认`batchSize`为1000

功能代码如下：

```java
   @Transactional(rollbackFor = Exception.class)
    @Override
    public boolean updateBatchById(Collection<T> entityList, int batchSize) {
        String sqlStatement = getSqlStatement(SqlMethod.UPDATE_BY_ID);
        return executeBatch(entityList, batchSize, (sqlSession, entity) -> {
            MapperMethod.ParamMap<T> param = new MapperMethod.ParamMap<>();
            param.put(Constants.ENTITY, entity);
            sqlSession.update(sqlStatement, param);
        });
    }
```

构建了一个回调，进入`executeBatch`方法(这个方法是`SqlHelper`类的)

```java
 /**
     * 执行批量操作
     *
     * @param entityClass 实体类
     * @param log         日志对象
     * @param list        数据集合
     * @param batchSize   批次大小
     * @param consumer    consumer
     * @param <E>         T
     * @return 操作结果
     * @since 3.4.0
     */
    public static <E> boolean executeBatch(Class<?> entityClass, Log log, Collection<E> list, int batchSize, BiConsumer<SqlSession, E> consumer) {
        Assert.isFalse(batchSize < 1, "batchSize must not be less than one");
        return !CollectionUtils.isEmpty(list) && executeBatch(entityClass, log, sqlSession -> {
            int size = list.size();
            int i = 1;
            for (E element : list) {
                consumer.accept(sqlSession, element);
                if ((i % batchSize == 0) || i == size) {
                    sqlSession.flushStatements();
                }
                i++;
            }
        });
    public static <E> boolean executeBatch(Class<?> entityClass, Log log, Collection<E> list, int batchSize, BiConsumer<SqlSession, E> consumer) {
        Assert.isFalse(batchSize < 1, "batchSize must not be less than one", new Object[0]);
        return !CollectionUtils.isEmpty(list) && executeBatch(entityClass, log, (sqlSession) -> {
            int size = list.size();
            int idxLimit = Math.min(batchSize, size);
            int i = 1;

            for(Iterator var7 = list.iterator(); var7.hasNext(); ++i) {
                E element = var7.next();
                consumer.accept(sqlSession, element);
                if (i == idxLimit) {
                    sqlSession.flushStatements();
                    idxLimit = Math.min(idxLimit + batchSize, size);
                }
            }

        });
    }
```

从这个方法可以看出，实际执行过程是每1000次执行一次`flushStatements`，也就是说理论上是积累了1000个更新sql，才进行一次数据库更新。相较于代码中循环调用更新语句，减少了大量IO



而最终更新使用的是BatchExcutor进行批量执行的。

### 4.BatchExcutor

在分析`BatchExecutor`类之前，先了解一下JDBC的批处理相关知识。

### 5.JDBC批处理

批量处理允许将相关的SQL语句分组到批处理中，并通过对数据库的一次调用来提交它们，一次执行完成与数据库之间的交互。需要注意的是：JDBC中的批处理只支持 insert、update 、delete 等类型的SQL语句，不支持select类型的SQL语句。
**一次向数据库发送多个SQL语句时，可以减少通信开销，从而提高性能。**
不需要JDBC驱动程序来支持此功能。应该使用`DatabaseMetaData.supportsBatchUpdates()`方法来确定目标数据库是否支持批量更新处理。如果JDBC驱动程序支持此功能，该方法将返回true。
`Statement`，`PreparedStatement`和`CallableStatement`的`addBatch()`方法用于将单个语句添加到批处理。 `executeBatch()`用于执行组成批量的所有语句。
`executeBatch()`返回一个整数数组，数组的每个元素表示相应更新语句的更新计数。
就像将批处理语句添加到处理中一样，可以使用clearBatch()方法删除它们。此方法将删除所有使用addBatch()方法添加的语句。 但是，无法指定选择某个要删除的语句。

### 使用Statement对象进行批处理的过程

一个 `Statement`可以执行多个sql（前提是sql相同和占位符）
以下是使用`Statement`对象的批处理的典型步骤序列
使用`createStatement()`方法创建`Statement`对象。
使用`setAutoCommit()`将自动提交设置为`false`。
使用`addBatch()`方法在创建的`Statement`对象上添加SQL语句到批处理中。
在创建的`Statement`对象上使用`executeBatch()`方法执行所有SQL语句。
最后，使用`commit()`方法提交所有更改。

### 使用PrepareStatement对象进行批处理

一个 Statement可以执行多个sql（前提是sql相同和占位符）
以下是使用PrepareStatement对象进行批处理的典型步骤顺序 -
使用占位符创建SQL语句。
使用prepareStatement()方法创建PrepareStatement对象。
使用setAutoCommit()将自动提交设置为false。
使用addBatch()方法在创建的Statement对象上添加SQL语句到批处理中。
在创建的Statement对象上使用executeBatch()方法执行所有SQL语句。
最后，使用commit()方法提交所有更改。

### BatchExecutor类

BatchExecutor同样继承了BaseExecutor抽象类，实现了批处理多条 SQL 语句的功能。因为JDBC不支持select类型的SQL语句，只支持insert、update、delete类型的SQL语句，所以在BatchExecutor类中，批处理主要针对的是update()方法。BatchExecutor类实现的整体逻辑：其中的doUpdate()方法，主要是把需要批处理的SQL语句通过 statement.addBatch()方法添加到批处理的Statement或PrepareStatement对象中，然后通过doFlushStatements()方法执行Statement的executeBatch()方法执行批处理，在doQueryCursor()方法和doQuery()方法中，首先会执行flushStatements()方法，flushStatements()方法底层其实就是doFlushStatements()方法，所以相当于先把已经添加到Statement或PrepareStatement对象中的批处理语句执行，然后在执行查询操作。

### doUpdate()方法

该方法主要是把需要批处理的SQL语句通过 statement.addBatch()方法添加到批处理的Statement或PrepareStatement对象中,等待执行批处理。其中主要根据判断当前执行的 SQL 模式与上次执行的SQL模式是否相同且对应的 MappedStatement 对象相同来确定使用已经存在的Statement对象，还是创建新的Statement对象来执行addBatch()操作。

```java
@Override
  public int doUpdate(MappedStatement ms, Object parameterObject) throws SQLException {
    final Configuration configuration = ms.getConfiguration();
    final StatementHandler handler = configuration.newStatementHandler(this, ms, parameterObject, RowBounds.DEFAULT, null, null);
    final BoundSql boundSql = handler.getBoundSql();
    final String sql = boundSql.getSql();
    final Statement stmt;
    if (sql.equals(currentSql) && ms.equals(currentStatement)) {
      int last = statementList.size() - 1;
      stmt = statementList.get(last);
      applyTransactionTimeout(stmt);
      handler.parameterize(stmt);//fix Issues 322
      BatchResult batchResult = batchResultList.get(last);
      batchResult.addParameterObject(parameterObject);
    } else {
      Connection connection = getConnection(ms.getStatementLog());
      stmt = handler.prepare(connection, transaction.getTimeout());
      handler.parameterize(stmt);    //fix Issues 322
      currentSql = sql;
      currentStatement = ms;
      statementList.add(stmt);
      batchResultList.add(new BatchResult(ms, sql, parameterObject));
    }
  // handler.parameterize(stmt);
    handler.batch(stmt);
    return BATCH_UPDATE_RETURN_VALUE;
  }
```

**这里我发现了一个特别的情况**
**这里执行了批量更新，按道理会复用同一个statement，但是由于参数为空**

```java
userService.updateBatchById(Arrays.asList(u, u1, u2, u3));
```

例如xml这么定义的mappStatement，**MybatisPlus的更新方法就是带有if标签判空的**

```xml
<update id="updateByExampleSelective" parameterType="map" >
  update user
  <set >
    <if test="record.age != null" >
      age = #{record.age,jdbcType=int},
    </if>
  </set>
  ············

</update>
```

那么假如u1参数age不为空，u2参数age为空，那么也会导致sql对比不同，不会加入到同一批量中

### doFlushStatements()方法

在doFlushStatements()方法中，底层执行了Statement的executeBatch()方法进行批处理操作的提交。其中BatchResult对象保持了一个Statement.executeBatch()方法的执行结果。和JDBC批处理相比，这里相当于封装了多个executeBatch()方法。

```java
@Override
  public List<BatchResult> doFlushStatements(boolean isRollback) throws SQLException {
    try {
      List<BatchResult> results = new ArrayList<BatchResult>();
      //如果明确指定了要回滚事务，则直接返回空集合，忽略 statementList集合中记录的 SQL语句
      if (isRollback) {
        return Collections.emptyList();
      }
      //遍历statementList集合
      for (int i = 0, n = statementList.size(); i < n; i++) {
        Statement stmt = statementList.get(i);
        applyTransactionTimeout(stmt);
        //获取对应BatchResult对象
        BatchResult batchResult = batchResultList.get(i);
        try {
          //调用 Statement.executeBatch()方法批量执行其中记录的 SQL语句，并使用返回的int数组
          //更新 BatchResult.updateCounts字段，其中每一个元素都表示一条 SQL语句影响的记录条数
          batchResult.setUpdateCounts(stmt.executeBatch());
          MappedStatement ms = batchResult.getMappedStatement();
          List<Object> parameterObjects = batchResult.getParameterObjects();
          //获取配置的KeyGenerator对象
          KeyGenerator keyGenerator = ms.getKeyGenerator();
          if (Jdbc3KeyGenerator.class.equals(keyGenerator.getClass())) {
        	//获取数据库生成的主键，并设置到parameterObjects中
            Jdbc3KeyGenerator jdbc3KeyGenerator = (Jdbc3KeyGenerator) keyGenerator;
            jdbc3KeyGenerator.processBatch(ms, stmt, parameterObjects);
          } else if (!NoKeyGenerator.class.equals(keyGenerator.getClass())) { //issue #141
            for (Object parameter : parameterObjects) {
              //对于其他类型的 keyGenerator，会调用其processAfter()方法
              keyGenerator.processAfter(this, ms, stmt, parameter);
            }
          }
          // Close statement to close cursor #1109
          closeStatement(stmt);
        } catch (BatchUpdateException e) {//异常处理
          StringBuilder message = new StringBuilder();
          message.append(batchResult.getMappedStatement().getId())
              .append(" (batch index #")
              .append(i + 1)
              .append(")")
              .append(" failed.");
          if (i > 0) {
            message.append(" ")
                .append(i)
                .append(" prior sub executor(s) completed successfully, but will be rolled back.");
          }
          throw new BatchExecutorException(message.toString(), e, results, batchResult);
        }
        //添加batchResult到results集合中
        results.add(batchResult);
      }
      return results;
    } finally {//关闭或清空对应对象
      for (Statement stmt : statementList) {
        closeStatement(stmt);
      }
      currentSql = null;
      statementList.clear();
      batchResultList.clear();
    }
  }
```

关键方法是stmt.executeBatch()，可以批量执行当前statement下的所有sql。

### doQuery()方法、doQueryCursor()方法

在doQuery()、doQueryCursor()方法中，和SimpleExecutro类中的类似，唯一区别在于：首先执行了flushStatements()方法，其中flushStatements()方法底层其实就是doFlushStatements()方法，所以相当于先把已经添加到Statement或PrepareStatement对象中的批处理语句执行，然后在执行查询操作

```java
 @Override
  public <E> List<E> doQuery(MappedStatement ms, Object parameterObject, RowBounds rowBounds, ResultHandler resultHandler, BoundSql boundSql)
      throws SQLException {
    Statement stmt = null;
    try {
      flushStatements();
      Configuration configuration = ms.getConfiguration();
      StatementHandler handler = configuration.newStatementHandler(wrapper, ms, parameterObject, rowBounds, resultHandler, boundSql);
      Connection connection = getConnection(ms.getStatementLog());
      stmt = handler.prepare(connection, transaction.getTimeout());
      handler.parameterize(stmt);
      return handler.<E>query(stmt, resultHandler);
    } finally {
      closeStatement(stmt);
    }
  }

  @Override
  protected <E> Cursor<E> doQueryCursor(MappedStatement ms, Object parameter, RowBounds rowBounds, BoundSql boundSql) throws SQLException {
    flushStatements();
    Configuration configuration = ms.getConfiguration();
    StatementHandler handler = configuration.newStatementHandler(wrapper, ms, parameter, rowBounds, null, boundSql);
    Connection connection = getConnection(ms.getStatementLog());
    Statement stmt = handler.prepare(connection, transaction.getTimeout());
    handler.parameterize(stmt);
    return handler.<E>queryCursor(stmt);
  }
```

在doFlushStatements()方法中，底层执行了Statement的executeBatch()方法进行批处理操作的提交。其中BatchResult对象保持了一个Statement.executeBatch()方法的执行结果。和JDBC批处理相比，这里相当于封装了多个executeBatch()方法。

@Override
————————————————
版权声明：本文为CSDN博主「氵奄不死的鱼」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：