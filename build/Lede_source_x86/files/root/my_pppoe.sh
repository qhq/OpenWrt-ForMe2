#!/bin/sh

#网络检测脚本 通过PING来判断网络互通状态
#by:朱君绰绰 V1.5

#shell测试命令
#./my_pppoe.sh runA

#计划任务命令
#5分钟执行一次，异常重启wan
#*/5 * * * * /root/my_pppoe.sh runA >> /root/my_pppoe.log 2>&1
#5分钟执行一次，异常重启网络连接
#*/5 * * * * /root/my_pppoe.sh runB >> /root/my_pppoe.log 2>&1
#5分钟执行一次，异常重启路由器
#*/5 * * * * /root/my_pppoe.sh runC >> /root/my_pppoe.log 2>&1
#runA=重启WAN（极力推荐），支持1-30分钟
#runB =重启网络连接（不推荐），支持5-30分钟，最少需要5分钟（设置太短可能无法进入路由器后台）
#runC =重启路由（不推荐），支持5-30分钟，最少需要5分钟（设置太短可能无法进入路由器后台）

#状态解释(State)
#	Carry Out=执行脚本
#	Create Log=创建日志文件
#	Clear Log = 清空日志内容
#	Log Byte 123/456=日志文件大小
#	Ping 8.8.8.8=ping
#	Ping 8.8.8.8 Yes=ping正常
#	Ping 8.8.8.8 No=ping异常
#	Ping Retry 1/3=ping重试
#	Restart Wan=重连wan
#	Restart Wan Yes=重连wan完成
#	Restart Network=重启网络进程
#	Restart Network Yes=重启网络进程完成
#	Restart Reboot=重启路由器
#	Restart Reboot Yes=已发送重启路由器命令

#相关变量解释
#	LogMax=日志大小(KB)
#	LogFile=日志文件
#	PingA,PingB=IP地址
#	CycleIndex=重试次数
#	IntervalTime=重试间隔时间(秒)

function NowTimeCall()
{
	NowTime=$(date "+%Y-%m-%d %H:%M:%S")
}


function LogTextCall()
{
	if [ ! -f "$1" ]; then
		echo "$NowTime - State:Create Log"
	else
		Size=`ls -l $1 | awk '{ print $5 }'`
		Max=$((1024*$2))
		if [ $Size -ge $Max ]; then
			cat /dev/null > $1
			echo "$NowTime - State:Clear Log"
		else
			echo "$NowTime - State:Log Byte $Size/$Max"
		fi
	fi 
}

#NowTime=$(date "+%Y-%m-%d %H:%M:%S")
NowTimeCall
echo "<my_pppoe> ----------------------------------------------"
echo "$NowTime - State:Carry Out"
LogMax=512
LogFile="/root/my_pppoe.log"
PingA=114.114.114.114
PingB=dns.alidns.com
CycleIndex=3
IntervalTime=10
LogTextCall $LogFile $LogMax

i=0
PingError=0
while [[ $i -lt $CycleIndex ]]
do
	NowTimeCall
	echo "$NowTime - State:Ping $PingA"
	if /bin/ping -c 1 $PingA >/dev/null
	then
		NowTimeCall
		echo "$NowTime - State:Ping $PingA Yes"
		PingError=0
		break
	else
		NowTimeCall
		echo "$NowTime - State:Ping $PingA No"
		NowTimeCall
		echo "$NowTime - State:Ping $PingB"
		if /bin/ping -c 1 $PingB >/dev/null
		then
			NowTimeCall
			echo "$NowTime - State:Ping $PingB Yes"
			PingError=0
			break
		else
			NowTimeCall
			echo "$NowTime - State:Ping $PingB No"
			i=$(($i + 1))
			echo "$NowTime - State:Ping Retry $i/$CycleIndex"
			PingError=1
			sleep $IntervalTime
		fi
	fi
done

if [ $PingError = 1 ]; then
	if [ $1 = runA ]; then
		NowTimeCall
		echo "$NowTime - State:Restart Wan"
		ifup wan
		NowTimeCall
		echo "$NowTime - State:Restart Wan Yes"
	fi
	
	if [ $1 = runB ]; then
		NowTimeCall
		echo "$NowTime - State:Restart Network"
		/etc/init.d/network restart
		NowTimeCall
		echo "$NowTime - State:Restart Network Yes"
	fi

	if [ $1 = runC ]; then
		NowTimeCall
		echo "$NowTime - State:Restart Reboot"
		echo "$NowTime - State:Restart Reboot Yes"
		reboot
	fi
fi



exit 0