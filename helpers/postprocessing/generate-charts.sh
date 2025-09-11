#!/usr/bin/env bash
set -euo pipefail

# input / output 
input=$1
fname=${input##*/}
lib=$(awk -F- '{printf "%s-%s", $1, $2}' <<< "${fname%.*}")

TL=$(awk -F- '{
  print substr($3, 3, length($3)-3)
}' <<< "${fname%.*}")

if [[ $TL < 1000 ]]; then
  tickInterval="1day"
else
  tickInterval="1week"
fi

echo "$lib"
output="comparison-gen.mmd"




echo "---
config: 
    gantt: 
        leftPadding: 150
        tickInterval: '$tickInterval'
---

gantt
title $lib (s)
    dateFormat X
    axisFormat %
" > "$output"


awk -v tl="$TL" '
BEGIN {
    FS = "[[:space:]]*[;:][[:space:]]*"
}
{
  if (NF == 3 && $3+0==$3) {
    x = $3
    gsub(/\./,"",x);
    if ($2 ~ /TIMEOUT/ || $2 ~ /Memory Limit/ || $2 ~ /ERROR/) {
      stat = "crit"
    } else {
      stat = "active"
    }
    printf "section %s\n", $1
    printf "%s : %s, 0, %s\n", $3, stat, x
  } else if ($2+0 == $2){
    x = $2
    gsub(/\./,"",x);
    line_name = $2
    if ($3 ~ /timeout/ && $2+0 == 0) {
      stat = "crit"
      x = tl"000"
      line_name = "TL"
    } else if ($4 == "BAD" || $4 == "ERROR") {
      stat = "crit"
    } else {
      stat = "active"
    }
    printf "section %s\n", $1
    printf "%s : %s, 0, %s\n", line_name, stat, x
  }
}
' "$input" >> "$output"

echo "TL : vert, "$TL"000, "$TL"000" >> "$output"

mkdir -p graphs
mmdc -i "$output" -o "./graphs/${lib}.svg"

# Clean up
rm -f "$output"
