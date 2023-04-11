@echo off
set tm1=%time:~0,2% 
set tm2=%time:~3,2% 
set tm3=%time:~6,2% 
::窗口位置（自定义，可删）
set rr="HKCU\Console\%%SystemRoot%%_system32_cmd.exe"
reg add %rr% /v "WindowPosition" /t REG_DWORD /d 0x00000000 /f >nul
if not defined ff (set ff=0&start cmd /c %0&exit)
::窗口长宽（自定义，可删）
mode con lines=20 cols=60
::颜色（自定义，可删）
color 3f
::标题（自定义，可删）
title smb本地转换
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
    echo 系统代理目前处于关闭状态，正在开启代理，请稍候...
    echo=
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul 2>nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "%ip%:7890" /f >nul 2>nul
    echo 系统代理已开启，请按任意键关闭本窗口...
) else if %ProxyEnableValue% equ 1 (
    echo 系统代理目前处于开启状态，正在关闭代理，请稍候...
    echo=
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul 2>nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f >nul 2>nul
    echo 系统代理已关闭，请按任意键退出本窗口...
)
pause>nul