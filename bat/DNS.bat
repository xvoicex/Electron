@echo off
set tm1=%time:~0,2% 
set tm2=%time:~3,2% 
set tm3=%time:~6,2% 
::����λ�ã��Զ��壬��ɾ��
set rr="HKCU\Console\%%SystemRoot%%_system32_cmd.exe"
reg add %rr% /v "WindowPosition" /t REG_DWORD /d 0x00000000 /f >nul
if not defined ff (set ff=0&start cmd /c %0&exit)
::���ڳ����Զ��壬��ɾ��
mode con lines=20 cols=60
::��ɫ���Զ��壬��ɾ��
color 3f
::���⣨�Զ��壬��ɾ��
title smb����ת��
set "_FilePath=%~f0"
set "_FileDir=%~dp0"
setlocal EnableExtensions EnableDelayedExpansion
fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "!_FilePath!", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    "%temp%\GetAdmin.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    exit
)

netsh interface ip set dns name="WLAN" source=dhcp
ipconfig /flushdns
pause
for /F "tokens=*" %%i in ('"nslookup voicexx.xyz"')  do (set txt=%%i )
cls
for /F "tokens=*" %%j in ('echo %txt:~10,15%')  do (set ip=%%j )
netsh interface ip set dns name="WLAN" source=static addr=%ip% register=primary
