echo f | xcopy mode.md  New.md
set /p a=�������ļ���:

ren New.md  %a%.md
set curdir=%~dp0
move %a%.md  %curdir%\source\_posts
start  %curdir%\source\_posts\%a%.md