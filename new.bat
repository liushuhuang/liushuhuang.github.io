echo f | xcopy mode.md  New.md
set /p a=�������ļ���:

ren New.md  %a%.md

move %a%.md D:\blog\liushuhuang.github.io\source\_posts
start D:\blog\liushuhuang.github.io\source\_posts\%a%.md