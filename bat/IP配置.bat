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


title IP��ַ����
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
@echo              1.��������		2.��������2
@echo.                      
@echo              3.��̫��		4.��̫��2
@echo.                      
@echo              5.�ֶ�����		6.�������
@echo.                      
@echo              7.�鿴����		8.�˳�
@echo.                      
@echo      _________________________________________________
@echo.
@echo                  Ĭ�����ñ�������[ֱ�ӻس�]
@echo.                               

set num=1
set /p num=��ѡ��[1��2��3��4]��

IF %num%==1 (
set inter=��������
goto menu2)
IF %num%==2 (
set inter=�������� 2
goto menu2)

IF %num%==3 (
set inter=��̫��
goto menu2)

IF %num%==4 (
set inter=��̫�� 2
goto menu2)
IF %num%==2 goto ipadd


IF %num%==5 (
@echo ������������
set /p inter=
goto menu2)


IF %num%==6 goto checkNET

IF %num%==7 goto ipadd

IF %num%==8 exit

IF %num% NEQ 8 (
@echo ��������
@pause
goto err1)

exit

:ipadd
cls
ipconfig /all | find /i "IPv4"
@echo.
ipconfig /all | find /i "��������"
@echo.
ipconfig /all | find /i "����"
@echo.
ipconfig /all | find /i "DNS ������"
@pause
goto menu1


:err1
cls
goto menu1
exit
 


:menu2
cls
@echo.
@echo                    ��ǰ������%inter%
@echo      _________________________________________________
@echo.
@echo              1.�Զ�DHCP		2.�ֶ�����
@echo.                      
@echo              3.�ֶ�DNS		4.�Զ�DNS
@echo.                      
@echo              5.���ö�IP      6.����������
@echo.                      
@echo              7.ֻ��IP����������	8.������һ��
@echo.                      
@echo      _________________________________________________
@echo. 
@echo                  Ĭ���ֶ���������[ֱ�ӻس�]
@echo.      
 
set selc=2
set /p selc=��ѡ��[1��2��3��4]��

 
@echo ��������...
 
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
@echo �Զ���ȡip��ַ
netsh int ip set add name="%inter%" source=dhcp
@echo �Զ���ȡDNS������
netsh int ip set dns name="%inter%" source=dhcp
@echo �Զ���ȡip��ַ�������
@echo.
@echo.
@pause
goto menu1
 
:ipsetting
@echo �������ù̶�ip,���Ժ򡭡�
@echo.
@echo ������ip��ַ��
set /p ip=
@echo.
@echo ����������(�س�Ĭ��255.255.255.0)��
set netmask=255.255.255.0
set /p netmask=
@echo.
@echo ����������(��һ�¡�)��
set /p gw=
@echo.
netsh interface ip set address "%inter%" static %ip% %netmask% %gw% 1

@echo ��������ѡDNS(�س�Ĭ��1.1.1.1)��
set DNS1=1.1.1.1
set /p DNS1=
@echo.
@echo.
@echo �����뱸��DNS(�س�Ĭ��2.2.2.2)��
set DNS2=2.2.2.2
set /p DNS2=

netsh interface ip set dns name="%inter%" source=static %DNS1%
netsh int ip add dns name="%inter%" %DNS2% index=2
 
cls
@echo,
set snum=2
set /p snum=�Ƿ���Ӹ�IP��2-��-[�س�Ĭ�ϼ���]:
IF %snum%==1 goto setIPs
IF %snum%==2 goto checkNET
@echo.
@echo.
@pause
exit

:IPONLY
@echo �������ù̶�ip,���Ժ򡭡�
@echo.
@echo ������ip��ַ��
set /p ip=
@echo.
@echo.
netsh interface ip set address "%inter%" static %ip% 255.255.255.0
 
@echo ip��ַ�������
@echo.
@echo.
@pause
exit



:DNS1
@echo ��������ѡDNS��
set /p DNS1=
@echo.
@echo.
@echo �����뱸��DNS��
set /p DNS2=

@echo ��������DNS

netsh interface ip set dns name="%inter%" source=static %DNS1%
netsh int ip add dns name="%inter%" %DNS2% index=2
 
@echo DNS�������
@echo.
@echo.
@pause
goto menu1


:DNS2
@echo ��������DNSΪ�Զ���ȡ
netsh interface ip set dns name="%inter%" source=dhcp
@echo DNS�������
@pause
goto menu1

:setIPs

echo.
echo ������ip��ַ��
set /p ip=
echo ����������(�س�Ĭ��255.255.255.0)��
set netmask=255.255.255.0
set /p netmask=
echo.

netsh interface ip add address name="%inter%" %ip% %netmask%

echo,
echo �Ƿ������ӣ�[�س�Ĭ�ϼ���]
echo 		2����
echo 		3�����˺˶�һ��IP
set snum=1
set /p snum=
IF %snum%==1 goto setIPs
IF %snum%==2 goto menu1
IF %snum%==3 call :ipadd
goto menu1



:DNS127
@echo ��������Ϊ127.0.0.1

netsh interface set interface %inter% disabled
ping -n 3 127.0.0.1>nul
netsh interface set interface %inter% enabled

 
@echo DNS�������
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
for /f "tokens=2 delims=:" %%k in ('ipconfig ^| findstr "����"') do (
set str=%%k
if !sum! == 1 goto masks else pause&&exit
)

:masks
for /f "delims= " %%l in ("%str%") do set ms=%%l
for /f "tokens=2 delims=:" %%m in ('ipconfig ^| findstr "����"') do (
set str=%%m
if !sum! == 1 goto gateways else pause&&exit
)

:gateways
for /f "delims= " %%n in ("%str%") do set gw=%%n
for /f "tokens=2 delims=:" %%p in ('ipconfig /all ^| findstr "������"') do (
set str=%%p
if !sum! == 1 goto dnss else pause&&exit
)

:dns1
for /f "delims= " %%q in ("%str%") do set ds=%%q
setlocal enabledelayedexpansion

:dns2
for /f "delims= " %%i in ('ipconfig /all') do echo %%i|findstr "^[0-9]"&&set ds2=%%i
echo ��ȡ��ַ���...

cls
echo,
cls
ipconfig /all | find /i "IPv4"
@echo.
ipconfig /all | find /i "��������"
@echo.
ipconfig /all | find /i "����"
@echo.
ipconfig /all | find /i "DNS ������"
echo.


ping -n 2 223.5.5.5>%temp%\1.ping & ping -n 2 223.6.6.6>>%temp%\1.ping    
findstr "TTL" %temp%\1.ping>nul
if %errorlevel%==0 (
echo     �� ��������
) else (
echo     �� ������ͨ
)         
echo.
ping -n 2 %gw%>%temp%\2.ping
findstr "TTL" %temp%\2.ping>nul
if %errorlevel%==0 (
echo     �� ��������
) else (
echo     �� ���ز�ͨ
)
echo.
echo.
ping -n 2 127.0.0.1>%temp%\3.ping
findstr "TTL" %temp%\3.ping>nul
if %errorlevel%==0 (echo     �� TCP/IPЭ������) else (echo     �� TCP/IPЭ���쳣)
if exist %temp%\*.ping del %temp%\*.ping                
echo.
pause
goto menu1

