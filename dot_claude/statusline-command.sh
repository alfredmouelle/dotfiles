#!/bin/sh
input=$(cat)

# --- ANSI colors (256-color) ---
RESET='\033[0m'
BOLD='\033[1m'
GRAY='\033[38;5;245m'
DIMGRAY='\033[38;5;238m'
CORAL='\033[38;5;209m'
GREEN='\033[38;5;114m'
RED='\033[38;5;203m'
YELLOW='\033[38;5;221m'
PURPLE='\033[38;5;141m'
CYAN='\033[38;5;80m'

j() { echo "$input" | jq -r "$1 // empty" 2>/dev/null; }

# --- Model ---
model=$(j '.model.display_name')
[ -z "$model" ] && model="Claude"
model_name=$(echo "$model" | sed -E 's/ [0-9][0-9.]*$//')
model_ver=$(echo "$model" | grep -oE '[0-9][0-9.]*$')

# --- Context window ---
ctx=$(j '.context_window.used_percentage')

# --- Cost + line changes ---
cost=$(j '.cost.total_cost_usd')
added=$(j '.cost.total_lines_added')
removed=$(j '.cost.total_lines_removed')

# --- 5h rate limit window ---
five=$(j '.rate_limits.five_hour.used_percentage')
five_reset=$(j '.rate_limits.five_hour.resets_at')
week=$(j '.rate_limits.seven_day.used_percentage')
week_reset=$(j '.rate_limits.seven_day.resets_at')

# --- Workspace / git ---
cwd=$(j '.workspace.current_dir')
[ -z "$cwd" ] && cwd=$(j '.cwd')
worktree=$(j '.worktree.name')
[ -z "$worktree" ] && worktree=$(basename "$cwd" 2>/dev/null)
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

# --- Output style / mode ---
style=$(j '.output_style.name')

# ---------- Line 1 ----------
line1="🤖 ${GRAY}${model_name}${RESET}"
[ -n "$model_ver" ] && line1="$line1 ${CORAL}${model_ver}${RESET}"

if [ -n "$ctx" ]; then
  ctxi=$(printf '%.0f' "$ctx")
  ctxremain=$(( 100 - ctxi ))
  if [ "$ctxremain" -le 20 ]; then ctxcol=$RED
  elif [ "$ctxremain" -le 50 ]; then ctxcol=$YELLOW
  else ctxcol=$GRAY; fi
  line1="$line1 ${DIMGRAY}|${RESET} 🧠 ${ctxcol}${ctxremain}%${RESET}"
fi

# if [ -n "$cost" ]; then
#   costf=$(printf '%.2f' "$cost")
#   line1="$line1 ${DIMGRAY}|${RESET} 💰 ${GREEN}\$${costf}${RESET}"
# fi

if [ -n "$five" ]; then
  fivei=$(printf '%.0f' "$five")
  remain=$(( 100 - fivei ))
  # color by usage
  if [ "$fivei" -ge 80 ]; then barcol=$RED
  elif [ "$fivei" -ge 50 ]; then barcol=$YELLOW
  else barcol=$GRAY; fi
  # 10-cell bar, fills as usage grows
  filled=$(( fivei / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  [ "$filled" -lt 0 ] && filled=0
  bar=""
  i=0
  while [ "$i" -lt 10 ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$(( i + 1 ))
  done
  reset_str=""
  if [ -n "$five_reset" ]; then
    now=$(date +%s)
    diff=$(( five_reset - now ))
    [ "$diff" -lt 0 ] && diff=0
    rh=$(( diff / 3600 ))
    rm=$(( (diff % 3600) / 60 ))
    if [ "$rh" -gt 0 ]; then
      reset_str=" ${GRAY}${rh}h${rm}m${RESET}"
    else
      reset_str=" ${GRAY}${rm}m${RESET}"
    fi
  fi
  line1="$line1 ${DIMGRAY}|${RESET} ⏱️ ${barcol}${bar}${RESET} ${barcol}${remain}%${RESET}${reset_str}"
fi

if [ -n "$week" ]; then
  weeki=$(printf '%.0f' "$week")
  wkremain=$(( 100 - weeki ))
  if [ "$weeki" -ge 80 ]; then wkcol=$RED
  elif [ "$weeki" -ge 50 ]; then wkcol=$YELLOW
  else wkcol=$GRAY; fi
  wkfilled=$(( weeki / 10 ))
  [ "$wkfilled" -gt 10 ] && wkfilled=10
  [ "$wkfilled" -lt 0 ] && wkfilled=0
  wkbar=""
  i=0
  while [ "$i" -lt 10 ]; do
    if [ "$i" -lt "$wkfilled" ]; then wkbar="${wkbar}█"; else wkbar="${wkbar}░"; fi
    i=$(( i + 1 ))
  done
  wkreset_str=""
  if [ -n "$week_reset" ]; then
    now=$(date +%s)
    wdiff=$(( week_reset - now ))
    [ "$wdiff" -lt 0 ] && wdiff=0
    wd=$(( wdiff / 86400 ))
    wh=$(( (wdiff % 86400) / 3600 ))
    if [ "$wd" -gt 0 ]; then
      wkreset_str=" ${GRAY}${wd}d${wh}h${RESET}"
    else
      wm=$(( (wdiff % 3600) / 60 ))
      wkreset_str=" ${GRAY}${wh}h${wm}m${RESET}"
    fi
  fi
  line1="$line1 ${DIMGRAY}/${RESET} 📅 ${wkcol}${wkbar}${RESET} ${wkcol}${wkremain}%${RESET}${wkreset_str}"
fi

# ---------- Line 2 ----------
line2="🌳 ${GRAY}${worktree}${RESET}"
if [ -n "$branch" ]; then
  line2="$line2 ${DIMGRAY}|${RESET} 🌿 ${GRAY}${branch}${RESET}"
  [ -n "$added" ] && [ "$added" -gt 0 ] 2>/dev/null && line2="$line2 ${GREEN}+${added}${RESET}"
  [ -n "$removed" ] && [ "$removed" -gt 0 ] 2>/dev/null && line2="$line2 ${RED}-${removed}${RESET}"
fi

# ---------- Line 3 (optional) ----------
line3=""
if [ -n "$style" ] && [ "$style" != "default" ] && [ "$style" != "null" ]; then
  line3="${PURPLE}▶▶ ${style}${RESET}"
fi

printf "%b\n%b" "$line1" "$line2"
[ -n "$line3" ] && printf "\n%b" "$line3"
exit 0
