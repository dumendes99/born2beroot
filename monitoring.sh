#!/bin/bash

rm -rf temp.tmp

{
	echo "/--------------------------------------------------------------------"
	echo "|" "Architecture	:" "$(uname -a)"
	echo "|" "CPU physical	:" "$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)"
	echo "|" "vCPU			:" "$(grep 'processor' /proc/cpuinfo | uniq | wc -l)"
	USED_R=$(free -m | awk 'NR == 2 {print $3}')
	TOTAL_R=$(free -m | awk 'NR == 2 {print $2}')
	PCRT_R=$(free -m | awk 'NR == 2 {printf "%.2f, $3*100/$2"}')
	echo "|" "Memory usage	:" "${USED_R}/${TOTAL_R}MB" "(${PCRT_R}%)"
	USED_D=$(df -m --total | awk 'END{print $3}')
	TOTAL_D=$(df -h --total | awk 'END{print $2}')
	PRCT_D=$(df -h --total | awk 'END{print $5}')
	echo "|" "Disk usage	:" "${USED_D}/${TOTAL_D}" "${PRCT_D})"
	echo "|" "CPU load		:" "$(mpstat | awk '/all/ {printf "%.2f", 100 - $NF}')%"
	echo "|" "Last boot		:" "$(who -b | awk '{print $3, $4}')"
	LVM=$(lsblk | grep "lvm" | wc -l)
	echo "|" "LVM in use	:" "$(if [ $LVM -eq 0 ]; then echo no; else echo yes; fi)"
	echo "|" "Connect TCP	:" "$(ss -s | awk '/TCP:/ {print $2}')"
	echo "|" "Users logged	:" "$(who | wc -l)"
	echo "|" "Network		:" "IP $(hostname -I)" "($(/usr/sbin/ifconfig | awk '/ether/ {print $2}'))"
	echo "|" "Sudo			:" "$(grep -c 'COMMAND' /var/log/sudo/sudo.log)" "cmd"
	echo "/--------------------------------------------------------------------"
} >> temp.tmp

cat temp.tmp

rm -rf temp.tmp