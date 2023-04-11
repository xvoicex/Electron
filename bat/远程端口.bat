@echo off
::窗口位置（自定义，可删）
set rr="HKCU\Console\%%SystemRoot%%_system32_cmd.exe"
reg add %rr% /v "WindowPosition" /t REG_DWORD /d 0x00000000 /f >nul
if not defined ff (set ff=0&start cmd /c %0&exit)
::窗口长宽（自定义，可删）
mode con lines=13 cols=60
::颜色（自定义，可删）
color 3f
::标题（自定义，可删）
title 远程端口修改

::提权
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
echo 当前远程端口:%tra%
echo ============================
set /p  port=请输入你要修改的远程桌面端口：
if "%port%"=="" goto memu

::修改注册表启用远程桌面。
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD  /d  0  /f
::修改远程桌面端口的注册表，共两个
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t REG_DWORD  /d %port% /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD  /d %port% /f
::修改远程桌面防火墙入站规则。
::启用防火墙
netsh advfirewall set allprofiles state on
::设置默认策略规则，禁止出站，禁止入站
::netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
::还原防火墙默认规则
::netsh advfirewall reset
::修改指定的防火墙策略
netsh advfirewall firewall set rule name="Allow Remote DeskTop" new localport=%port%
::判断修改防火墙策略命令是否成功执行，如果没有执行成功说明策略不存在，这里重新添加新策略。
IF ERRORLEVEL 1  netsh advfirewall firewall add rule name="Allow Remote DeskTop" dir=in protocol=tcp localport=%port% action=allow
net stop "Remote Desktop Services" /y
net start "Remote Desktop Services"
cls
for /f "tokens=1,2,* " %%i in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber ^| find /i "PortNumber"') do set "regvalue=%%k"

set /a tra=%regvalue%
echo ============================
echo 修改完成,当前远程端口:%tra%
echo ============================
pause