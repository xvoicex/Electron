@echo off
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

set host=6.ipw.cn

:open
::Ҫping��ip
ping %host%

if %ERRORLEVEL%==0 goto Ok
if %ERRORLEVEL%==1 goto No
exit

:No
cls&echo no %date%_%time%
::ʧ�ܺ������־
echo  No %date%_%time%>>C:\Users\vm\OneDrive - voice\����\netlog.txt
::������·

for /f "" %%i in ('curl %host%') do set "ip=%%i" 


echo %ip%

echo %ip%|findstr "2408" >nul &&(
	echo ipv6,ok
)||(
	echo ipv6,error
	echo ��������........
	netsh interface set interface "Ethernet0" admin=disable
	netsh interface set interface "Ethernet0" admin=enable
)
::pause
exit


:Ok
cls&echo ok %date%_%time%

exit