#!/usr/bin/env zsh
# Example ASCII Art MOTD — professional banner for SSH login
# Uses figlet for the ASCII art logo (falls back to simple text if unavailable)
# Customize the figlet text and colors below for your own branding.
# Part of the dotfiles shared MOTD system.

# ── Early exit (sourced, so use return, not exit) ──
[[ -t 1 ]] || return 0
local -i term_cols
{ term_cols=$(tput cols 2>/dev/null || echo 80); } 2>/dev/null
(( term_cols >= 50 )) || return 0

# ── Colors (customize these for your own brand) ──
c_rst=$'\033[0m'
c_brand=$'\033[38;5;214m'    # Warm orange (example brand color)
c_dim=$'\033[38;5;239m'      # Dim grey for separators
c_label=$'\033[38;5;244m'    # Grey labels
c_val=$'\033[38;5;252m'      # Light grey values
c_green=$'\033[38;5;76m'     # Docker all up
c_yellow=$'\033[38;5;220m'   # Docker partial

# ── Customize this text ──
# Change "DOTFILES" to your project/service name
local brand_text="DOTFILES"

# ── Collect system info ──
local hname="${HOSTNAME:-$(hostname 2>/dev/null || echo 'unknown')}"

local uptime_str=""
if command -v uptime >/dev/null 2>&1; then
  if uptime -p >/dev/null 2>&1; then
    uptime_str="$(uptime -p 2>/dev/null | sed 's/^up //')"
  else
    uptime_str="$(uptime 2>/dev/null | sed 's/.*up \([^,]*\),.*/\1/')"
  fi
fi

local ip_addr=""
if command -v ip >/dev/null 2>&1; then
  ip_addr="$(ip -4 addr show 2>/dev/null | grep -oP 'inet \K[0-9.]+' | grep -v '^127\.' | head -1)"
fi
ip_addr="${ip_addr:-$(hostname -I 2>/dev/null | awk '{print $1}')}"

# Docker status (icon only — concise)
local docker_dot=""
if command -v docker >/dev/null 2>&1; then
  local d_total=$(docker ps -a --format '{{.Names}}' 2>/dev/null | wc -l)
  local d_run=$(docker ps --format '{{.Names}}' 2>/dev/null | wc -l)
  if (( d_total > 0 )); then
    if (( d_run == d_total )); then
      docker_dot="${c_green}●${c_rst}"
    elif (( d_run > 0 )); then
      docker_dot="${c_yellow}●${c_rst}"
    else
      docker_dot="○"
    fi
  fi
fi

# OS short name
local os_short=""
if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  case "$ID" in
    ubuntu) os_short="Ubuntu" ;;
    debian) os_short="Debian" ;;
    alpine) os_short="Alpine" ;;
    arch)   os_short="Arch"   ;;
    fedora) os_short="Fedora" ;;
    rhel|centos) os_short="RHEL" ;;
    *)      os_short="${NAME%% *}" ;;
  esac
fi

# ── Generate ASCII art ──
local -a art_lines=()
local fig_w=$(( term_cols - 4 ))
(( fig_w > 60 )) && fig_w=60
(( fig_w < 30 )) && fig_w=30

if command -v figlet >/dev/null 2>&1; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Strip trailing whitespace first; skip if only spaces
    local trimmed="${line%"${line##*[![:space:]]}"}"
    [[ -n "${trimmed}" ]] && art_lines+=("$trimmed")
  done < <(figlet -f big -w "$fig_w" "$brand_text" 2>/dev/null)
fi

# ── Render: ASCII art ──
echo ""

if (( ${#art_lines[@]} > 0 )); then
  # Find max line width for uniform centering
  local -i max_art_w=0
  for line in "${art_lines[@]}"; do
    (( ${#line} > max_art_w )) && max_art_w=${#line}
  done
  local -i art_pad=$(( (term_cols - max_art_w) / 2 ))
  (( art_pad < 0 )) && art_pad=0
  for line in "${art_lines[@]}"; do
    local -i rpad=$(( max_art_w - ${#line} ))
    (( rpad < 0 )) && rpad=0
    printf "%*s${c_brand}%s%*s${c_rst}\n" $art_pad "" "$line" $rpad ""
  done
else
  # Fallback if figlet not available
  local tagline="=====  ${brand_text}  ====="
  local -i pad=$(( (term_cols - ${#tagline}) / 2 ))
  (( pad < 0 )) && pad=0
  printf "%*s${c_brand}%s${c_rst}\n" $pad "" "$tagline"
fi

echo ""

# ── Render: separator ──
local sep_len=40
(( sep_len > term_cols - 10 )) && sep_len=$(( term_cols - 10 ))
local sep=$(printf '─%.0s' $(seq 1 $sep_len))
local -i sep_pad=$(( (term_cols - sep_len) / 2 ))
(( sep_pad < 0 )) && sep_pad=0
printf "%*s${c_dim}%s${c_rst}\n" $sep_pad "" "$sep"

# ── Render: info line ──
local -a info_parts=()
info_parts+=("${c_val}${hname}${c_rst}")
[[ -n "$ip_addr" ]] && info_parts+=("${c_label}${ip_addr}${c_rst}")
[[ -n "$uptime_str" ]] && info_parts+=("${c_label}up ${uptime_str}${c_rst}")
[[ -n "$os_short" ]] && info_parts+=("${c_label}${os_short}${c_rst}")
[[ -n "$docker_dot" ]] && info_parts+=("${docker_dot} ${c_label}docker${c_rst}")

local sep_str=" ${c_dim}│${c_rst} "
local info_str=""
for (( i = 1; i <= ${#info_parts[@]}; i++ )); do
  info_str+="${info_parts[$i]}"
  (( i < ${#info_parts[@]} )) && info_str+="$sep_str"
done

# Calculate plain-text width using zsh-native (no sed)
local clean_info="${info_str//$'\033['[0-9;]#m/}"
local -i info_w=${#clean_info}
local -i pad=$(( (term_cols - info_w) / 2 ))
(( pad < 0 )) && pad=0
printf "%*s%s\n" $pad "" "$info_str"

echo ""
