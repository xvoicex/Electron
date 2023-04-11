#/bin/bash
# 6 */4 * * * bash /home/xunjian.sh >> /home/xunjian/x.log
#scp -P 2022  lenovo@44.157.249.33:/home/mobaxterm/xunjian/xunjian.sh /home/
#sed -i 's/柏科//g' /home/xunjian.sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
source /etc/profile
[ $(id -u) -gt 0 ] && echo "请用root用户执行此脚本！" && exit 1

t=
i=0
j=0
time=$(date +%F@%T)
day=$(date +%F)
path=/home/xunjian
fz=$(top -b -n1|head -n 1|sed 's/.*load average: \([0-9]*\.\?[0-9]*\), \([0-9]*\.\?[0-9]*\), \([0-9]*\.\?[0-9]*\).*/\1/')
ip=$(/sbin/ifconfig |grep inet |grep 44. |awk '{printf $2 "\n"}' |sed 's/addr://g')
sysVersion=$(awk '{print $(NF-1)}' /etc/redhat-release)
dq=$(echo 柏科)




function getSystemStatus(){
echo ""
echo ""
echo "############################ 系统检查 ############################"
if [ -e /etc/sysconfig/i18n ];then
default_LANG="$(grep "LANG=" /etc/sysconfig/i18n | grep -v "^#" | awk -F '"' '{print $2}')"
else
default_LANG=$LANG
fi
export LANG="en_US.UTF-8"
Release=$(grep PRETTY_NAME /etc/os-release |sed 's/[^"]*"\([^"]*\)".*/\1/')
Kernel=$(uname -r)
OS=$(uname -o)
Hostname=$(uname -n)
SELinux=$(/usr/sbin/sestatus | grep "SELinux status: " | awk '{print $3}')
LastReboot=$(who -b | awk '{print $3,$4}')
uptime=$(top -b -n1|head -n 1|sed 's/.*up \([^,]*\),.*/\1/')
echo " 系统：$OS"
echo " 当前IP：$ip"
echo " 发行版本：$Release"
echo " 内核：$Kernel"
echo " 主机名：$Hostname"
echo " SELinux：$SELinux"
echo "语言/编码：$default_LANG"
echo " 当前时间：$(date +'%F %T')"
echo " 最后启动：$LastReboot"
echo " 运行时间：$uptime"
echo "##################################################################"
}


function Checkpath(){
echo ""
echo ""
echo "############################ 检查文件路径 ############################"
if [ -d "$path" ];then
	echo "文件夹存在"
else
	echo "文件夹不存在"
	mkdir $path
fi

if [ -f "$path/xunjian.log" ];then
	echo "xunjian.log存在"
else
	echo "xunjian.log不存在,创建临时日志文件"
	touch $path/xunjian.log
fi
echo "######################################################################"
}

#echo -e $time > $path/xunjian.log
#w  >> $path/xunjian.log

function Checkload(){
echo "############################ 负载检查 ############################"
if (echo $fz 10 |awk '!($1 >= $2){exit 1}') then
	t=$(echo $dq+$ip+$time+启动时长:$up+负载:$fz)
	echo -e  负载过高,退出脚本,$t
	top -b -n 1 >> $path/xunjian.log
	exit 0
else
	i=$i+1
	echo -e  负载正常,$t
	t=$(echo $dq+$ip+$time+启动时长:$up+负载:$fz)
fi
echo "##################################################################"
}


function Checktop(){
echo "############################ cpu占用前十进程 ############################"
top -b -n 1|head -n 17
echo "#########################################################################"
}

function Checkram(){
echo "############################ 检查内存占用 ############################"

}
















# df -h|grep /home  |awk '{printf $5 "\n"}'|sed 's/%//g'
lines=$(df -h|grep /home  |awk '{printf $5 "\n"}'|sed 's/%//g' |wc -l)
k=0
for (( line=1 ; line<=$lines ; line= line + 1 ))
do
                dused=$(df -h|grep /home  |awk '{printf $5 "\n"}'|sed 's/%//g' |head -n $line |tail -n 1)
                if (echo $dused 90 |awk '!($1 >= $2){exit 1}')  then
					dev=$(df -h|grep /home  |awk '{printf $6 "\n"}' |head -n $line |tail -n 1)
					#t=$(echo $t+$dev:$dused%)
					k=$k+1
					echo -e $dev 空间使用率 $dused % 超过90% >> $path/xunjian.log
                elif (echo $line $lines |awk '!($1 > $2){exit 1}') then
						t=$(echo $t)
						i=$i+1
                        break
                fi
done
k=$(echo $k|bc)
if (echo $k 0 |awk '!($1 > $2){exit 1}') then
	echo -e 有$k个盘占用超90%
	t=$(echo $t+有$k个盘占用超90%)
else
	echo -e 磁盘占用正常 $k
	t=$(echo $t+磁盘占用正常)
fi




df -h >> $path/xunjian.log

#exit 0
echo -e --------------------------------mdu  >> $path/xunjian.log
ps -ef |grep mdu >> $path/xunjian.log
echo -e --------------------------------vod  >> $path/xunjian.log
ps -ef |grep vod >> $path/xunjian.log
echo -e --------------------------------sa  >> $path/xunjian.log
ps -ef |grep sa >> $path/xunjian.log


mdu=$(ps -ef |grep mdu |grep watchdog |wc -l)
vod=$(ps -ef |grep vod |grep watchdog |wc -l)
sa=$(ps -ef |grep sa |grep watchdog |wc -l)

#-------mdu

if (echo $mdu 3 |awk '!($1 >= $2){exit 1}') then
	echo -e mdu正常
	t=$(echo $t+mdu正常)
	i=$i+1
else
	echo -e mdu服务异常
	t=$(echo $t+mdu---异常---)
	ps -ef |grep mdu |grep watchdog
fi

#-------vod

if (echo $vod 6 |awk '!($1 >= $2){exit 1}') then
	echo -e vod正常
	t=$(echo $t+vod正常)
	i=$i+1
else
	echo -e vod服务异常
	t=$(echo $t+vod---异常---)
	ps -ef |grep vod |grep watchdog
fi

#-------sa

if (echo $sa 6 |awk '!($1 >= $2){exit 1}') then
	echo -e sa正常
	t=$(echo $t+sa正常)
	i=$i+1
else
	echo -e sa服务异常
	t=$(echo $t+sa---异常---)
	ps -ef |grep sa |grep watchdog
fi

#echo $t




vpr=$(lsof -u sa |grep .vpr |wc -l)
error=$(bash /home/disk_status_creat.sh |grep error |wc -l)

normal=

if (echo $error 0 |awk '!($1 > $2){exit 1}') then
#	bash /home/disk_status_creat.sh > $path/error-$time.log
	echo -e 读写错误了
	bash /home/disk_status_creat.sh > $path/error-$time.log
	t=$(echo $t--读写异常--)
	j=$j+1
else
	t=$(echo $t+读写正常)
	i=$i+1
fi

if (echo $vpr 4 |awk '!($1 > $2){exit 1}') then
#	bash /home/disk_status_creat.sh > $path/error-$time.log
	echo -e 录像正常
	t=$(echo $t+录像任务$vpr个)
	i=$i+1
else
#	bash /home/disk_status_creat.sh > $path/error-$time.log
	echo -e 当前没有录像任务
	t=$(echo $t--录像异常任务$vpr个--)
	j=$j+1
fi




t=$(echo $t |sed 's/:/-/g')
echo -e $t
mv $path/xunjian.log  $path/$t.log
find $path/ -mtime +6 -name '*.log' | xargs rm -f




#exit 0

#sftp配置文件
#sftp_conf_path=/etc/sftp.conf
#获取sftp的IP地址
sftp_ip=44.157.249.33
#获取sftp的端口
#sftp_port=1022
#获取sftp的用户名
sftp_user=lenovo
#获取sftp的密码
sftp_password=sdgA#2022
out_path=$path/
sftp_path=/home/mobaxterm/xunjian/$day
file=$t.log

echo $sftp_path
echo $file

echo --------------------随机延迟
date +%F@%T
sleep $(($RANDOM%20))
date +%F@%T
echo --------------------随机延迟

#实现SFTP传输
/usr/bin/expect << EOP
#单位:秒
set timeout  10000

spawn scp -P 2022 -o StrictHostKeyChecking=no $path/$t.log  $sftp_user@$sftp_ip:$sftp_path
#反馈字符串包含 passowrd,则发送密码
expect "password:"
send "$sftp_password\r"
#set timeout 300
expect EOF
exit 0
