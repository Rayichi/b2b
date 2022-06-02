#!/bin/bash

arc=$(uname -srvmo)
nproc=$(uname --all)
vproc=$(cat /proc/cpuinfo | grep processor | wc -l)
nram=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)",$3,$2,$3*100/$2 }')
ndisk=$(df -Bm -a |grep dev/mapper | awk '{sum+=$3}END{printf sum "MB"}')
ndisk2=$(df -Bg -a |grep dev/mapper | awk '{sum+=$2}END{printf sum "Gb"}')
ndisk3=$(df -BM -a | grep /dev/mapper/ | awk '{sum1+=$3 ; sum2+=$2}END{printf "(%d%%)", (sum1)*100/sum2}')
ncpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')
nboot=$(who -b | awk '{printf $3 " " $4 " " $5}')
nlvm=$(lsblk |grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"}}')
ncon=$(netstat -an | grep ESTABLISHED | wc -l )
nuse=$(who | wc -l)
nip=$(hostname -I)
nmac=$(ip link show | grep link/ether | awk ' {print "(" $2 ")"}')
nsudo=$(journalctl _COMM=sudo -q | wc -l)

wall "
	#Architecture: $arc
	#CPU physical : $nproc
	#vCPU : $vproc
	#Memory Usage: $nram
	#Disk Usage: $ndisk/$ndisk2 $ndisk3
	#CPU load: $ncpu
	#Last boot: $nboot
	#LVM use: $nlvm
	#Connexions TCP : $ncon ESTABLISHED
	#User log: $nuse
	#Network: IP $nip $nmac
	#Sudo : $nsudo cmd
"
