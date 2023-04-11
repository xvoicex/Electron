@echo off
  >NUL 2>&1 REG.exe query "HKU\S-1-5-19" || (
      ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
      ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
      "%TEMP%\Getadmin.vbs"
      DEL /f /q "%TEMP%\Getadmin.vbs" 2>NUL
      Exit /b
  )
%1 %2
ver|find "5.">nul&&goto :st
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :st","","runas",1)(window.close)&goto :eof

:st
copy "%~0" "%windir%\system32\"


title IP地址配置
color 3f

mode con cols=60 lines=30
ncpa.cpl
goto menu1
 
:menu1
cls
@echo.
@echo.
@echo      _________________________________________________
@echo.
@echo              1.本地连接		2.本地连接2
@echo.                      
@echo              3.以太网		4.以太网2
@echo.                      
@echo              5.手动输入		6.检查网络
@echo.                      
@echo              7.查看配置		8.退出
@echo.                      
@echo      _________________________________________________
@echo.
@echo                  默认设置本地连接[直接回车]
@echo.                               

set num=1
set /p num=请选择[1、2、3、4]：

IF %num%==1 (
set inter=本地连接
goto menu2)
IF %num%==2 (
set inter=本地连接 2
goto menu2)

IF %num%==3 (
set inter=以太网
goto menu2)

IF %num%==4 (
set inter=以太网 2
goto menu2)
IF %num%==2 goto ipadd


IF %num%==5 (
@echo 请输入网卡名
set /p inter=
goto menu2)


IF %num%==6 goto checkNET

IF %num%==7 goto ipadd

IF %num%==8 exit

IF %num% NEQ 8 (
@echo 输入有误
@pause
goto err1)

exit

:ipadd
cls
ipconfig /all | find /i "IPv4"
@echo.
ipconfig /all | find /i "子网掩码"
@echo.
ipconfig /all | find /i "网关"
@echo.
ipconfig /all | find /i "DNS 服务器"
@pause
goto menu1


:err1
cls
goto menu1
exit
 


:menu2
cls
@echo.
@echo                    当前网卡：%inter%
@echo      _________________________________________________
@echo.
@echo              1.自动DHCP		2.手动输入
@echo.                      
@echo              3.手动DNS		4.自动DNS
@echo.                      
@echo              5.配置多IP      6.重启该网卡
@echo.                      
@echo              7.只改IP，不改网关	8.返回上一层
@echo.                      
@echo      _________________________________________________
@echo. 
@echo                  默认手动输入配置[直接回车]
@echo.      
 
set selc=2
set /p selc=请选择[1、2、3、4]：

 
@echo 正在设置...
 
IF %selc%==1 goto DHCP
IF %selc%==2 goto ipsetting
IF %selc%==3 goto DNS1
IF %selc%==4 goto DNS2
IF %selc%==5 goto setIPs
IF %selc%==6 goto DNS127
IF %selc%==7 goto IPONLY
IF %selc%==8 goto menu1
IF %selc% NEQ 8 goto err2
exit
 
 
:err2
cls
goto menu2
exit

:DHCP
@echo.
@echo 自动获取ip地址
netsh int ip set add name="%inter%" source=dhcp
@echo 自动获取DNS服务器
netsh int ip set dns name="%inter%" source=dhcp
@echo 自动获取ip地址设置完毕
@echo.
@echo.
@pause
goto menu1
 
:ipsetting
@echo 正在设置固定ip,请稍候……
@echo.
@echo 请输入ip地址：
set /p ip=
@echo.
@echo 请输入掩码(回车默认255.255.255.0)：
set netmask=255.255.255.0
set /p netmask=
@echo.
@echo 请输入网关(按一下↑)：
set /p gw=
@echo.
netsh interface ip set address "%inter%" static %ip% %netmask% %gw% 1

@echo 请输入首选DNS(回车默认1.1.1.1)：
set DNS1=1.1.1.1
set /p DNS1=
@echo.
@echo.
@echo 请输入备用DNS(回车默认2.2.2.2)：
set DNS2=2.2.2.2
set /p DNS2=

netsh interface ip set dns name="%inter%" source=static %DNS1%
netsh int ip add dns name="%inter%" %DNS2% index=2
 
cls
@echo,
set snum=2
set /p snum=是否添加副IP？2-是-[回车默认继续]:
IF %snum%==1 goto setIPs
IF %snum%==2 goto checkNET
@echo.
@echo.
@pause
exit

:IPONLY
@echo 正在设置固定ip,请稍候……
@echo.
@echo 请输入ip地址：
set /p ip=
@echo.
@echo.
netsh interface ip set address "%inter%" static %ip% 255.255.255.0
 
@echo ip地址设置完毕
@echo.
@echo.
@pause
exit



:DNS1
@echo 请输入首选DNS：
set /p DNS1=
@echo.
@echo.
@echo 请输入备用DNS：
set /p DNS2=

@echo 正在设置DNS

netsh interface ip set dns name="%inter%" source=static %DNS1%
netsh int ip add dns name="%inter%" %DNS2% index=2
 
@echo DNS设置完毕
@echo.
@echo.
@pause
goto menu1


:DNS2
@echo 正在设置DNS为自动获取
netsh interface ip set dns name="%inter%" source=dhcp
@echo DNS设置完毕
@pause
goto menu1

:setIPs

echo.
echo 请输入ip地址：
set /p ip=
echo 请输入掩码(回车默认255.255.255.0)：
set netmask=255.255.255.0
set /p netmask=
echo.

netsh interface ip add address name="%inter%" %ip% %netmask%

echo,
echo 是否继续添加？[回车默认继续]
echo 		2，否
echo 		3，够了核对一下IP
set snum=1
set /p snum=
IF %snum%==1 goto setIPs
IF %snum%==2 goto menu1
IF %snum%==3 call :ipadd
goto menu1



:DNS127
@echo 正在设置为127.0.0.1

netsh interface set interface %inter% disabled
ping -n 3 127.0.0.1>nul
netsh interface set interface %inter% enabled

 
@echo DNS设置完毕
@echo.
@echo.
@pause
goto menu1



:checkNET
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "IPv4"') do (
set str=%%i
if !sum! == 1 goto IP else pause&&exit
)

:IP
for /f "delims= " %%j in ("%str%") do set ip=%%j
for /f "tokens=2 delims=:" %%k in ('ipconfig ^| findstr "掩码"') do (
set str=%%k
if !sum! == 1 goto masks else pause&&exit
)

:masks
for /f "delims= " %%l in ("%str%") do set ms=%%l
for /f "tokens=2 delims=:" %%m in ('ipconfig ^| findstr "网关"') do (
set str=%%m
if !sum! == 1 goto gateways else pause&&exit
)

:gateways
for /f "delims= " %%n in ("%str%") do set gw=%%n
for /f "tokens=2 delims=:" %%p in ('ipconfig /all ^| findstr "服务器"') do (
set str=%%p
if !sum! == 1 goto dnss else pause&&exit
)

:dns1
for /f "delims= " %%q in ("%str%") do set ds=%%q
setlocal enabledelayedexpansion

:dns2
for /f "delims= " %%i in ('ipconfig /all') do echo %%i|findstr "^[0-9]"&&set ds2=%%i
echo 获取地址完成...

cls
echo,
cls
ipconfig /all | find /i "IPv4"
@echo.
ipconfig /all | find /i "子网掩码"
@echo.
ipconfig /all | find /i "网关"
@echo.
ipconfig /all | find /i "DNS 服务器"
echo.


ping -n 2 223.5.5.5>%temp%\1.ping & ping -n 2 223.6.6.6>>%temp%\1.ping    
findstr "TTL" %temp%\1.ping>nul
if %errorlevel%==0 (
echo     √ 外网正常
) else (
echo     × 外网不通
)         
echo.
ping -n 2 %gw%>%temp%\2.ping
findstr "TTL" %temp%\2.ping>nul
if %errorlevel%==0 (
echo     √ 网关正常
) else (
echo     × 网关不通
)
echo.
echo.
ping -n 2 127.0.0.1>%temp%\3.ping
findstr "TTL" %temp%\3.ping>nul
if %errorlevel%==0 (echo     √ TCP/IP协议正常) else (echo     × TCP/IP协议异常)
if exist %temp%\*.ping del %temp%\*.ping                
echo.
pause
goto menu1

