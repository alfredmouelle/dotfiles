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

# --- Quota bars (same look as the quota-pace desktop mod) ---
dark=0
[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ] && dark=1

# quota_bar <label> <used%> <resets_at epoch> <window seconds>
quota_bar() {
  awk -v label="$1" -v used="$2" -v reset="$3" -v win="$4" -v now="$(date +%s)" -v dark="$dark" -v w=20 '
  function rgb(h,  r,g,b) {
    r = index("0123456789abcdef", substr(h,1,1))*16 + index("0123456789abcdef", substr(h,2,1)) - 17
    g = index("0123456789abcdef", substr(h,3,1))*16 + index("0123456789abcdef", substr(h,4,1)) - 17
    b = index("0123456789abcdef", substr(h,5,1))*16 + index("0123456789abcdef", substr(h,6,1)) - 17
    return r ";" g ";" b
  }
  function fg(h) { return "\033[38;2;" rgb(h) "m" }
  function bg(h) { return "\033[48;2;" rgb(h) "m" }
  function dur(s,  m,d,h) {
    m = int(s/60 + 0.5); d = int(m/1440); h = int((m%1440)/60)
    if (d > 0) return d "d" h "h"
    if (h > 0) return sprintf("%dh%02dm", h, m%60)
    return m "m"
  }
  BEGIN {
    rem = 100 - int(used + 0.5); if (rem < 0) rem = 0
    hasreset = (reset != "")
    left = hasreset ? reset - now : 0; if (left < 0) left = 0
    thr = (win > 86400) ? 10 : 20
    if (hasreset) {
      expct = (left < win ? left : win) / win * 100
      gap = rem - expct
      alert = (gap <= -thr) || (rem <= 15 && gap <= -5)
      good = !alert && gap >= thr
    } else { alert = rem <= 15; good = 0 }

    if (dark) {
      FILL="6b6b6b"; EMPTY="2e2e2e"; HATCH="404040"; TICK="f2f2f2"; TXT="eeeeee"; SUB="aaaaaa"
      if (alert) { FILL="cf6560"; EMPTY="3d2826"; HATCH="523432" }
      if (good)  { FILL="6fa86a"; EMPTY="2b3a2a"; HATCH="3a4e38" }
    } else {
      FILL="cfcfcf"; EMPTY="f1f1f1"; HATCH="dddddd"; TICK="111111"; TXT="333333"; SUB="666666"
      if (alert) { FILL="e38d88"; EMPTY="f9e3e1"; HATCH="efc4c1" }
      if (good)  { FILL="a3d29c"; EMPTY="e9f4e7"; HATCH="cde6c8" }
    }

    filled = int(rem / 100 * w + 0.5)
    tick = hasreset ? int((left < win ? left : win) / win * w) : -1
    if (tick >= w) tick = w - 1

    text = label " " rem "%"
    L = length(text)
    ts = int((w - L) / 2)
    if (tick >= ts && tick < ts + L) {
      r = tick + 1; l = tick - L; c = ts
      if (r + L > w) ts = l
      else if (l < 0) ts = r
      else ts = (c - l <= r - c) ? l : r
    }
    out = ""
    for (i = 0; i < w; i++) {
      cbg = (i < filled) ? FILL : EMPTY
      if (i == tick) { out = out bg(cbg) fg(TICK) "\033[1m┃\033[22m"; continue }
      if (i >= ts && i < ts + length(text)) {
        ch = substr(text, i - ts + 1, 1)
        col = (i - ts < length(label)) ? SUB : TXT
        b = (i - ts >= length(label)) ? "\033[1m" : ""
        out = out bg(cbg) fg(col) b ch "\033[22m"
        continue
      }
      out = out bg(cbg) ((i < filled) ? " " : fg(HATCH) "╱")
    }
    out = out "\033[0m"
    if (hasreset) out = out " " fg(SUB) dur(left) "\033[0m"
    printf "%s", out
  }'
}

if [ -n "$five" ]; then
  line1="$line1 ${DIMGRAY}|${RESET} $(quota_bar 5h "$five" "$five_reset" 18000)"
fi
if [ -n "$week" ]; then
  line1="$line1  $(quota_bar 7d "$week" "$week_reset" 604800)"
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
