---
title: SpringSecurity
date: 2022-11-23
description: SpringSecurity
tags: SpringSecurity
top_img: transparent
cover: 
---

# Web应用的安全性

- 用户认证（Authentication）
  - 用户认证指的是验证某个用户是否为系统中的合法主体，也就是说用户能否访问该系统。用户认证一般要求用户提供用户名和密码。系统通过校验用户名和密码来完成认证过程。
  - 支持的认证方式
    - HTTP 基本认证
    - HTTP 表单验证
    - HTTP 摘要认证
    - OpenID
    - LDAP 等
- 用户授权（Authorization）
  - 用户授权指的是验证某个用户是否有权限执行某个操作。在一个系统中，不同用户所具有的权限是不同的。比如对一个文件来说，有的用户只能进行读取，而有的用户可以进行修改。一般来说，系统会为不同的用户分配不同的角色，而每个角色则对应一系列的权限。
  - 授权方式
    - 基于角色的访问控制
    - 访问控制列表（Access Control List，ACL）

# SpringSecurity简介

- Spring Security 是针对Spring项目的安全框架，也是Spring Boot底层安全模块默认的技术选型，他可以实现强大的Web安全控制，对于安全控制，我们仅需要引入 spring-boot-starter-security 模块，进行少量的配置，即可实现强大的安全管理！
- 常用的类
  - WebSecurityConfigurerAdapter：自定义Security策略
  - AuthenticationManagerBuilder：自定义认证策略
  - @EnableWebSecurity：开启WebSecurity模式

# 认证和授权

- 引入 Spring Security 模块

  ```xml
  <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-security</artifactId>
  </dependency>
  ```

- config

  - 授权

    ```java
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // 定制请求的授权规则
        // 首页所有人可以访问
        http.authorizeRequests().antMatchers("/").permitAll()
                .antMatchers("/level1/**").hasRole("vip2")
                .antMatchers("/level2/**").hasRole("vip2")
                .antMatchers("/level3/**").hasRole("vip3");
    
        // 开启自动配置的登录功能
        // /login 请求来到登录页
        // /login?error 重定向到这里表示登录失败
        http.formLogin();
    }
    ```

    - antMatchers

      - 注意注意!!!antMatchers()里面的参数是拦截的访问地址,不是你的文件地址
      - 只需要保护一条URL路径，使用antMatcher，保护多条使用antMatchers

    - permitAll()

      - 无条件允许访问

  - 认证

    ```java
    //定义认证规则
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        //在内存中定义，也可以在jdbc中去拿....
        auth.inMemoryAuthentication()
        		.withUser("zhou").password("123456").roles("vip2","vip3")
                .and()
                .withUser("root").password("123456").roles("vip1","vip2","vip3")
                .and()
                .withUser("guest").password("123456").roles("vip1","vip2");
    }
    ```

    - 但是会报错，由于使用的密码，没有加密，框架认为不安全，因此需要加密

      ```java
       //定义认证规则
          @Override
          protected void configure(AuthenticationManagerBuilder auth) throws Exception {
              //在内存中定义，也可以在jdbc中去拿....
              //Spring security 5.0中新增了多种加密方式，也改变了密码的格式。
              //要想我们的项目还能够正常登陆，需要修改一下configure中的代码。我们要将前端传过来的密码进行某种方式加密
              //spring security 官方推荐的是使用bcrypt加密方式。
              auth.inMemoryAuthentication().passwordEncoder(new BCryptPasswordEncoder())
                      .withUser("zhou").password(new BCryptPasswordEncoder().encode("123456")).roles("vip2","vip3")
                      .and()
                      .withUser("root").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2","vip3")
                      .and()
                      .withUser("guest").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2");
          }
      }
      ```

# 权限控制和注销

- 注销

  ```java
  //定制请求的授权规则
  @Override
  protected void configure(HttpSecurity http) throws Exception {
     //....
     //开启自动配置的注销的功能
        // /logout 注销请求
     http.logout();
  }
  ```

  - 如果希望注销跳到首页

    ```java
    http.logout().logoutSuccessUrl("/");
    ```

    - 后面跟的是URL路径

- 在网页中判断

  - sec：authorize="isAuthenticated()"
    - 判断是否认证登录！来显示不同的页面
  - sec:authorize="hasRole('vip2')"
    - 判断是否有权限

# Remember me

```scss
http.rememberMe();
```

- 登录成功后，将cookie发送给浏览器保存，以后登录带上这个cookie，只要通过检查就可以免登录了。如果点击注销，则会删除这个cookie

# 定制登录页

```java
http.formLogin().loginPage("/toLogin");
```

- 在loginPage里面写登录的URL路径

- 接受登录的用户名和密码

  ```java
  http.formLogin()
    .usernameParameter("username")
    .passwordParameter("password")
    .loginPage("/toLogin")
    .loginProcessingUrl("/login"); // 登陆表单提交请求
  ```

- 接受rembermer参数

  ```java
  http.rememberMe().rememberMeParameter("remember");
  ```

  