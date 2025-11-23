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
### Total memory usage (Free vs Used including percentage)
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
### Total disk usage (Free vs Used including percentage)

block_size=$(stat -f / | grep Block | awk 'NR==1{print $3}');
total_blocks=$(stat -f / | grep Blocks: | awk '{print $3}');
echo "total memory size $(($total_blocks * $block_size)) bytes"
free_blocks=$(stat -f / | grep Blocks: | awk '{print $5}');
echo "free disk space $(($free_blocks * $block_size)) bytes"
echo "used disk size $((($total_blocks-$free_blocks)* $block_size))"
available_blocks=$(stat -f / | grep Blocks: | awk '{print $7}');
#echo "available disk size $(($available_blocks * $block_size))"
#echo "used disk size $((($total_blocks-$available_blocks)* $block_size))"
used_space=$(bc -l <<< "scale=2; (1 - ($free_blocks/$total_blocks)) * 100")
echo "used disk space: $used_space%"
available_space=$(bc -l <<< "scale=2; (100 - $used_space)")
echo "available disk space: $available_space%"

### Top 5 processes by CPU usage
echo "PID and command of Top 5 processes by CPU usage:"
ps aux --sort -pcpu | awk '{print $2 " " $11}' | head -6 | tail -n +2

echo ""
### Top 5 processes by Memory usage
echo "PID and command of Top 5 processes by Memory usage:"
ps aux --sort -pmem | awk '{print $2 " " $11}' | head -6 | tail -n +2


