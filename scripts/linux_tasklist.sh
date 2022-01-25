#!/usr/bin/env bash
#get task list for all processes on the terminal without controlling ttys

MINWAIT=50
MAXWAIT=60

while true
do
ps aux > "$HOSTNAME-`date +"%Y%m%d-%H%M"`".txt
sleep $((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))
done
