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
set port=7890
netsh interface ip set dns name="WLAN" source=dhcp
ipconfig /flushdns
pause
for /F "tokens=*" %%i in ('"nslookup voicex.top"')  do (set txt=%%i )
cls
for /F "tokens=*" %%j in ('echo %txt:~10,15%')  do (set ip=%%j )
set "ip=%ip: =%"
set port=%ip%:7890

echo %port%


for /f "tokens=1,2,* " %%i in ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable ^| find /i "ProxyEnable"') do (set /A ProxyEnableValue=%%k)

if %ProxyEnableValue% equ 0 (
    echo ϵͳ����Ŀǰ���ڹر�״̬�����ڿ����������Ժ�...
    echo=
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "%ip%:7890" /f >nul 2>nul
    echo ϵͳ�����ѿ������밴������رձ�����...
) else if %ProxyEnableValue% equ 1 (
    echo ϵͳ����Ŀǰ���ڿ���״̬�����ڹرմ������Ժ�...
    echo=
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f >nul 2>nul
    echo ϵͳ�����ѹرգ��밴������˳�������...
)
pause>nul