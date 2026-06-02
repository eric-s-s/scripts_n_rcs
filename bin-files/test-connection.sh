#!/bin/bash
# /usr/local/bin/network-monitor.sh

# Runs in background, logs drops with timestamps and diagnostic info

GATEWAY=$(ip route | awk '/default/ {print $3}' | head -1)
EXTERNAL="8.8.8.8"
LOG="network-drops.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

log "Starting network monitor. Gateway: $GATEWAY"

while true; do
    # Test gateway connectivity
    if ! ping -c 2 -W 2 "$GATEWAY" > /dev/null 2>&1; then
        log "GATEWAY UNREACHABLE: $GATEWAY"
        # Capture network state at time of failure
        ip addr show >> "$LOG"
        ip route show >> "$LOG"
        # Check for interface errors
        ip -s link show >> "$LOG"
        dmesg | tail -20 >> "$LOG"
    else
        # Test external connectivity
        if ! ping -c 2 -W 2 "$EXTERNAL" > /dev/null 2>&1; then
            log "EXTERNAL UNREACHABLE (gateway OK): $EXTERNAL"
        fi
    fi
    sleep 10
done
