# server_stats.sh

This is a small bash script done by me for the exercise from - https://roadmap.sh/projects/server-stats.

It prints basic info about the server:
- Total CPU usage (it calculate it's over 1 second interval)
- Total memory usage (read from /proc/meminfo)
- Total disk usage for `/` (stat is used)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

## Requirements

This script is using only `bash`, `ps`, `stat`, `bc`, `echo`, `grep`, `awk`, `head`.
this tools are usually available by default on most Linux systems.

## Usage 
```bash
chmod +x server_stats.sh
./server_stats.sh```
