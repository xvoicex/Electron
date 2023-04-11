@echo off
title 重置当前用户密码

:cx
echo 当前用户名为：%username%

set mm=
set rmm=
echo.
set /p mm="请输入新密码："
echo.
set /p rmm="请再次输入新密码："
echo.
if %mm%==%rmm% goto cz else goto cw


:cw
echo.
echo.
echo 两次输入不一致,请重新输入;请按任意键返回!!!  & pause>nul
cls & goto cx


:cz
net user %username% %mm%
echo.
echo.
echo 密码重置成功,密码为%rmm%请按任意键关闭!!! & pause>nul