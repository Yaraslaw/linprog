#!/usr/bin/env bash
#
# convert.sh — normalize a 3-col “Test : Result : Time” table,
# replacing XrY→X/Y and auto-truncating decimals so each Result fits in 20 chars.

# widths (chars)
W_TEST=20
W_RESULT=20
result_file="${2:-/dev/stdin}"

# maximum precision for an initial pass (override via env MAX_SCALE)
MAX_SCALE=${MAX_SCALE:-16}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"   # ltrim
  s="${s%"${s##*[![:space:]]}"}"   # rtrim
  printf '%s' "$s"
}

compute_dp() {
  local X=$1 Y=$2 D=$3
  awk "BEGIN {result = $X / $Y; formatted = sprintf(\"%.${D}f\", result); sub(/0+$/, \"\", formatted); sub(/\.$/, \"\", formatted); print formatted}"
}

while IFS=':' read -r col1 col2 col3; do
  # skip any totally blank line (all three empty)
  if [[ -z $col1 && -z $col2 && -z $col3 ]]; then
    continue
  fi

  # 1) split & trim
  t=$(trim "$col1")
  r=$(trim "$col2")
  tm=$(trim "$col3")

  # 2) if r matches XrY, recalc; else leave as-is
  if [[ $r =~ ^(-?[0-9]+)r(-?[0-9]+)$ ]]; then
    X=${BASH_REMATCH[1]}
    Y=${BASH_REMATCH[2]}

    raw_full=$(awk "BEGIN {printf \"%.${MAX_SCALE}f\", $X / $Y}")
    raw_trim=$(printf '%s' "$raw_full" \
                | sed -E 's/(\.[0-9]*[1-9])0+$/\1/; s/\.0+$//')

    if [[ $raw_trim == *.* ]]; then
      intpart=${raw_trim%%.*}
    else
      intpart=$raw_trim
    fi
    iplen=${#intpart}

    dec_allowed=$(( W_RESULT - iplen - 1 ))
    (( dec_allowed < 0 )) && dec_allowed=0

    raw=$(compute_dp "$X" "$Y" "$dec_allowed")
    r="$raw"
  fi

  # 3) pad to fixed widths
  t=$(printf "%-*s" "$W_TEST" "$t")
  r=$(printf "%-*s" "$W_RESULT" "$r")

  # 4) rejoin with single-space colons
  printf '%s : %s : %s\n' "$t" "$r" "$tm" >> "$result_file"
  printf '%s : %s : %s\n' "$t" "$r" "$tm"
done < "${1:-/dev/stdin}"

echo "Converted results written to: $result_file"
