#!/usr/bin/env bash
# Platform detection for Bash
# Sets flags used by other modules

# Detect platform
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
else
    IS_WSL=false
fi

IS_LINUX=false
IS_MACOS=false
IS_ARM=false

case "$OSTYPE" in
    linux*)   IS_LINUX=true ;;
    darwin*)  IS_MACOS=true ;;
esac

# Detect architecture
if [[ "$(uname -m)" == "arm"* || "$(uname -m)" == "aarch64" ]]; then
    IS_ARM=true
fi

# Detect machine type
# Customize the hostname patterns below for your environment
# Example: add your work laptop hostname pattern to set MACHINE_TYPE="work"
MACHINE_TYPE="generic"
if [[ -n "$HOSTNAME" ]]; then
    case "$HOSTNAME" in
        *pi*|*raspberry*)
            MACHINE_TYPE="raspberry_pi"
            ;;
        # Add your own patterns here, e.g.:
        # my-laptop-*)
        #     MACHINE_TYPE="work_laptop"
        #     ;;
    esac
fi

export IS_WSL IS_LINUX IS_MACOS IS_ARM MACHINE_TYPE
