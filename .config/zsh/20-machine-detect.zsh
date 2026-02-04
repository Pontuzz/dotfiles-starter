#!/usr/bin/env zsh
# Platform and machine detection
# Used to conditionally load features based on the environment

# Detect if running in WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
  export IS_WSL=true
  export IS_LINUX=true
else
  export IS_WSL=false
  # Detect if running on any Linux
  if [[ "$OSTYPE" == linux* ]]; then
    export IS_LINUX=true
  else
    export IS_LINUX=false
  fi
fi

# Detect macOS
if [[ "$OSTYPE" == darwin* ]]; then
  export IS_MACOS=true
else
  export IS_MACOS=false
fi

# Detect if running on ARM (e.g., Raspberry Pi, Apple Silicon)
if [[ "$(uname -m)" == "arm"* ]]; then
  export IS_ARM=true
else
  export IS_ARM=false
fi

# Hostname-based detection for specific machines
# Customize the hostname patterns below for your environment
HOSTNAME=$(hostname)
case "$HOSTNAME" in
  [work-machine]*)
    export IS_WORK_MACHINE=true
    export MACHINE_TYPE="work_machine"
    ;;
  raspberrypi*)
    export IS_RASPBERRY_PI=true
    export MACHINE_TYPE="raspberry_pi"
    ;;
  *)
    export MACHINE_TYPE="generic"
    ;;
esac

# Debug: uncomment to see detected environment
# echo "DEBUG: WSL=$IS_WSL, LINUX=$IS_LINUX, MACOS=$IS_MACOS, ARM=$IS_ARM, MACHINE=$MACHINE_TYPE"
