#!/bin/bash

# Get the IP address and subnet mask using the 'ip' command
read -r ip <<< $(ip -o -f inet addr show | awk '/scope global/ {print $4}')

#calculating subnet address
IFS=/ read -r ip prefix <<< $ip
IFS=. read -r i1 i2 i3 i4 <<< $ip
IFS=. read -r xx m1 m2 m3 m4 <<< $(for a in $(seq 1 32); do if [ $(((a - 1) % 8)) -eq 0 ]; then echo -n .; fi; if [ $a -le $prefix ]; then echo -n 1; else echo -n 0; fi; done)

#formatting
subnet_ip=$(printf "%d.%d.%d.%d\n" "$((i1 & (2#$m1)))" "$((i2 & (2#$m2)))" "$((i3 & (2#$m3)))" "$((i4 & (2#$m4)))")

#network scan
nmap -sn "$subnet_ip/$prefix"
