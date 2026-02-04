#!/usr/bin/env bash
# System information MOTD

echo ""
echo "════════════════════════════════════════════════════════════"
echo "System Information"
echo "════════════════════════════════════════════════════════════"

# Hostname and uptime
echo "Hostname:    $(hostname)"
echo "Uptime:      $(uptime -p 2>/dev/null || uptime)"

# User and shell
echo "User:        $(whoami)"
echo "Shell:       $SHELL"
echo "Shell Ver:   $($SHELL --version | head -1)"

# System resources
if command -v free &>/dev/null; then
    MEM_USAGE=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
    echo "Memory:      $MEM_USAGE"
fi

if command -v df &>/dev/null; then
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')
    echo "Disk (/):    $DISK_USAGE"
fi

# Load average
LOAD=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}' 2>/dev/null || echo "N/A")
echo "Load Avg:    $LOAD"

# Architecture and OS
echo "OS:          $(uname -s)"
echo "Arch:        $(uname -m)"

# Detect platform
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "Platform:    WSL2"
elif grep -qi raspberry /proc/device-tree/model 2>/dev/null; then
    echo "Platform:    Raspberry Pi $(cat /proc/device-tree/model 2>/dev/null)"
fi

echo "════════════════════════════════════════════════════════════"
echo ""
