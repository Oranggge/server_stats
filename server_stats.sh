#!/bin/bash
read -r cpu1 us1 sy1 ni1 id1 wa1 hi1 si1 st1 < /proc/stat;
sleep 1;
read -r cpu2 us2 sy2 ni2 id2 wa2 hi2 si2 st2 < /proc/stat;

usdif="$(($us2 - $us1))" # normal proc executing in user mode
sydif="$(($sy2 - $sy1))" # niced processes executing in user mode
nidif="$(($ni2 - $ni1))" # processes executing in kernel mode
iddif="$(($id2 - $id1))" # idle
wadif="$(($wa2 - $wa1))" # idle cause i/o
hidif="$(($hi2 - $hi1))" # servicing interrupts hardware
sidif="$(($si2 - $si1))" # servicing interrupts software
#stdif="$(($st2 - $st1))"
#echo "usdif - $usdif"
#echo "sydif - $sydif"
#echo "nidif - $nidif"
#echo "iddif - $iddif"
#echo "wadif - $wadif"
#echo "hidif - $hidif"
#echo "sidif - $sidif"
#echo "stdif - $stdif"
sum="$(($usdif+$sydif+$nidif+$iddif+$wadif+$hidif+$sidif))"
#echo "sum - $sum"
# // todo: maybe need to summ idle + idle cause i/o . depends on the task
idle_percentage=$(bc -l <<< "scale=2;$iddif/$sum")
#echo "idle_percentage - $idle_percentage"
cpuusage=$(bc -l <<< "(1 - $idle_percentage) * 100")
echo "the cpu usage - $cpuusage%"
echo "----"
# Total memory usage (Free vs Used including percentage)
memtotal=$( grep MemTotal /proc/meminfo | awk -F ' ' '{print $2}');
echo "memTotal - $memtotal kB"
memfree=$( grep MemFree /proc/meminfo | awk -F ' ' '{print $2}');
memfreeperc=$(bc -l <<< "scale=2; (1 - ($memfree/$memtotal)) * 100")
echo "memFree is memory which is not used by OS"
echo "memFree is different from available memory"
echo "memFree - $memfree kB"
echo "memFree - $memfreeperc%"
memavailable=$( grep MemAvailable /proc/meminfo | awk -F ' ' '{print $2}');
memavailableperc=$(bc -l <<< "scale=2; (1 - ($memavailable/$memtotal)) * 100")
echo "memAvailable - $memavailable kB"
echo "mem Used - $((memtotal - memavailable)) kB"
echo "mem Used - $memavailableperc%"
