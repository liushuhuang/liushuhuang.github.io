echo f | xcopy mode.md  New.md
set /p a=请输入文件名:

ren New.md  %a%.md
set curdir=%~dp0
move %a%.md  %curdir%\source\_posts
start  %curdir%\source\_posts\%a%.md