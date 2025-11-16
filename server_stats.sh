#!/bin/bash
us1="$(head -1 /proc/stat | awk -F ' ' '{print $2}')";
sleep 2;
us2="$(head -1 /proc/stat | awk -F ' ' '{print $2}')";

echo $us1;
echo $us2;
echo "us1 - us2 $(($us1 - $us2))"

