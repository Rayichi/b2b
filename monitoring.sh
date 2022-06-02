#!/bin/bash

arc=$(uname -srvmo)
nproc=$(uname --all)
vproc=$(cat /proc/cpuinfo | grep processor | wc -l)
nram=$(free -m 'NR==2{printf "%s/%s (%.2f%%)"}')
ndisk=$(df -Bg -a |grep dev/mapper | awk '{sum+=$3}END{printf sum}')
ndisk2=$(df -Bg -a |grep dev/mapper | awk '{sum+=$2}END{printf sum}')
ndisk3=$(df -BM -a | grep /dev/mapper/ | awk '{sum1+=$3 ; sum2+=$2}END{printf "(%d%%)", (sum1-sum2)*100/sum2}')
ncpu=$(mpstat |grep all | awk'{printf "%.2f%%", 100-$13}')
nboot=$(who -b | awk '{printf $3 " " $4 " " $5}')
nlvm=$(lsblk |grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"}}')
ncon=$(netstat -an | grep ESTABLISHED | wc l- | awk '{printf "ESTABLISHED"}')
nuse=$(users | wc -l)
nip=$(hostname -I)
nmac=$(ip a | grep link/ether | awk ' {print "(" $2} ")"')
nsudo=$(journqlctl _COMM=sudo -q | wc -l)

wall "
	#Architecture: $arc
	#CPU physical : $nproc
	#vCPU : $vproc
	#Memory Usage: $nram
	#Disk Usage: $ndisk/$ndisk2 Mb $ndisk3
	#CPU load: $ncpu
	#Last boot: $nboot
	#LVM use: $nlvm
	#Connexions TCP : $ncon
	#User log: $nuse
	#Network: IP $nip $nmac
	#Sudo : $nsudo cmd
"
