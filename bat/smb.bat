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

for /F "tokens=*" %%i in ('"nslookup voicexx.xyz"')  do (set txt=%%i )
cls
for /F "tokens=*" %%j in ('echo %txt:~10,15%')  do (set ip=%%j )


netsh interface portproxy delete v4tov4 listenaddress=127.0.0.1  listenport=445
netsh interface portproxy add v4tov4 listenport=445 listenaddress=127.0.0.1  connectport=1445 connectaddress=%ip%
netsh interface portproxy  show all

pause