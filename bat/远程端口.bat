@echo off
::����λ�ã��Զ��壬��ɾ��
set rr="HKCU\Console\%%SystemRoot%%_system32_cmd.exe"
reg add %rr% /v "WindowPosition" /t REG_DWORD /d 0x00000000 /f >nul
if not defined ff (set ff=0&start cmd /c %0&exit)
::���ڳ����Զ��壬��ɾ��
mode con lines=13 cols=60
::��ɫ���Զ��壬��ɾ��
color 3f
::���⣨�Զ��壬��ɾ��
title Զ�̶˿��޸�

::��Ȩ
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
pushd "!_FileDir!"


for /f "tokens=1,2,* " %%i in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber ^| find /i "PortNumber"') do set "regvalue=%%k"

set /a tra=%regvalue%
echo ============================
echo ��ǰԶ�̶˿�:%tra%
echo ============================
set /p  port=��������Ҫ�޸ĵ�Զ������˿ڣ�
if "%port%"=="" goto memu

::�޸�ע�������Զ�����档
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD  /d  0  /f
::�޸�Զ������˿ڵ�ע���������
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t REG_DWORD  /d %port% /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD  /d %port% /f
::�޸�Զ���������ǽ��վ����
::���÷���ǽ
netsh advfirewall set allprofiles state on
::����Ĭ�ϲ��Թ��򣬽�ֹ��վ����ֹ��վ
::netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
::��ԭ����ǽĬ�Ϲ���
::netsh advfirewall reset
::�޸�ָ���ķ���ǽ����
netsh advfirewall firewall set rule name="Allow Remote DeskTop" new localport=%port%
::�ж��޸ķ���ǽ���������Ƿ�ɹ�ִ�У����û��ִ�гɹ�˵�����Բ����ڣ�������������²��ԡ�
IF ERRORLEVEL 1  netsh advfirewall firewall add rule name="Allow Remote DeskTop" dir=in protocol=tcp localport=%port% action=allow
net stop "Remote Desktop Services" /y
net start "Remote Desktop Services"
cls
for /f "tokens=1,2,* " %%i in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber ^| find /i "PortNumber"') do set "regvalue=%%k"

set /a tra=%regvalue%
echo ============================
echo �޸����,��ǰԶ�̶˿�:%tra%
echo ============================
pause