#!/bin/bash

INTERVAL=10  # Check every 60 seconds
LOG_FILE="/home/admin/memory-monitor.log"

echo "Starting memory monitor at $(date)" | tee -a "$LOG_FILE"
echo "Time,VmSize_KB,VmSize_GB_approx,DRI_Mappings,Doublemapper_Mappings,Total_Mappings" | tee -a "$LOG_FILE"

while true; do
    PID=$(pidof AvaloniaMemoryTest)

    if [ -n "$PID" ]; then
        # Get VmSize in KB
        VM_SIZE_KB=$(grep VmSize /proc/$PID/status | awk '{print $2}')

        # Approximate GB (divide by 1048576)
        VM_SIZE_GB=$((VM_SIZE_KB / 1048576))

        # Count DRI mappings
        DRI_COUNT=$(sudo cat /proc/$PID/maps | grep "/dev/dri/card0" | wc -l)

        # Count doublemapper mappings
        DM_COUNT=$(sudo cat /proc/$PID/maps | grep "/memfd:doublemapper" | wc -l)

        # Total mappings
        TOTAL_MAPS=$(sudo cat /proc/$PID/maps | wc -l)

        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

        echo "$TIMESTAMP,$VM_SIZE_KB,$VM_SIZE_GB,$DRI_COUNT,$DM_COUNT,$TOTAL_MAPS" | tee -a "$LOG_FILE"
    else
        echo "$(date): Process not running" | tee -a "$LOG_FILE"
    fi

    sleep $INTERVAL
done