@echo off
title ���õ�ǰ�û�����

:cx
echo ��ǰ�û���Ϊ��%username%

set mm=
set rmm=
echo.
set /p mm="�����������룺"
echo.
set /p rmm="���ٴ����������룺"
echo.
if %mm%==%rmm% goto cz else goto cw


:cw
echo.
echo.
echo �������벻һ��,����������;�밴���������!!!  & pause>nul
cls & goto cx


:cz
net user %username% %mm%
echo.
echo.
echo �������óɹ�,����Ϊ%rmm%�밴������ر�!!! & pause>nul