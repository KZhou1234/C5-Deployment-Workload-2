#!/bin/bash


CPU_Threshold=65
Mem_Threshold=85
Disk_Threshold=65

CPU_Usage=$(top -bn2 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100-$1}')
#-n2:use second iteration avoid first loop since boot
if (( $(echo "$CPU_Usage > $CPU_Threshold" | bc -l) ))
then
  echo "CPU usage now is $CPU_Usage, higher than $CPU_Threshold."
  exit 1
else
 echo "CPU usage normal"
fi 


Mem_Usage=$(free | grep "Mem" | awk '{print $3/$2 * 100.0}')
if (( $(echo  "$Mem_Usage > $Mem_Threshold" | bc -l) ))
then
  echo "Memory usage now is $Mem_Usage, higher than $Mem_Threshold."
  exit 1
else
 echo "Memory usage normal"
fi 


Disk_Usage=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
if (( $(echo "$Disk_Usage > $Disk_Threshold" | bc -l) ))
then
  echo "Disk usage now is $Disk_Usage, higher than $Disk_Threshold."
  exit 1
else
 echo "Disk usage normal"
fi 

exit 0
