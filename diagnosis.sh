#!/bin/bash
#! /bin/bash
cd /
cd factory/
line=$(head -n 1 serial_number)
echo serialNumber=$line
cd /home/root/diagnosis
top -n 1 -b > cpu.txt
sed '2!d' cpu.txt > cpu1.txt
value=$(awk '{print $2 $3 $4 $5 }' cpu1.txt)
echo cpuUsage=$value
sed '1!d' cpu.txt > mem.txt
memory=$(awk '{print $2 $3 $4 $5 }' mem.txt)
echo memoryUsage=$memory
who > user_info.txt
cat user_info.txt | while read LINE
do
echo "usersConnected="$LINE
done
systemctl status wpa_supplicant > net.txt
echo networkStatus=$(cat net.txt | grep Active)
sh edison_script.sh
echo Y |i2cdetect -r 6 > file_i2c
sleep 1;
address=()
for i in `cat file_i2c`
do
   #v="/[A-Za-z]{2}/"
   address+=(`echo "$i" | grep -E "^[0-9a-fA-F]{2}$" `)
done
echo "Addresses => ${address[@]}"
echo "number of sensors => ${#address[@]}"
