
#!/usr/bin/env bash
set -euo pipefail

# input / output 
input1=$1
input2=$2
fname1=${input1##*/}
fname2=${input2##*/}

lib1=$(awk -F- '{printf "%s-%s", $1, $2}' <<< "${fname1%.*}")
lib2=$(awk -F- '{printf "%s-%s", $1, $2}' <<< "${fname2%.*}")

echo "$lib1"
echo "$lib2"


TL1=$(awk -F- '{
  print substr($3, 3, length($3)-3)
}' <<< "${fname1%.*}")

TL2=$(awk -F- '{
  print substr($3, 3, length($3)-3)
}' <<< "${fname2%.*}")

if [[ $TL1 != $TL2 ]]; then
  echo "WARNING: time limits are different! $TL1 vs $TL2"
  echo "by default using TL1: $TL1"
fi

if [[ TL1 < 1000 ]]; then
  tickInterval="1day"
else
  tickInterval="1week"
fi

output="comparison-gen.mmd"




conf=$(echo "---
config: 
    gantt: 
        leftPadding: 150
        tickInterval: '$tickInterval'
    maxTextSize: 200000
---

gantt
title $lib1 (blue) VS $lib2 (gray) (s)
    dateFormat X
    axisFormat %
" > "$output")


input1_2=$(awk 'BEGIN{
  f1 = ARGV[1]; f2 = ARGV[2];
  ARGV[1] = ARGV[2] = "";        # prevent default reading
  while (1) {
    s1 = getline l1 < f1;        # read next from file1
    s2 = getline l2 < f2;        # read next from file2
    if (s1 <= 0 && s2 <= 0) break
    if (s1 > 0) print l1
    if (s2 > 0) print l2
  }
  close(f1); close(f2);
  exit
}' $input1 $input2)




awk -v tl="$TL1" '
BEGIN {
    FS = "[[:space:]]*[;:][[:space:]]*"
}
{
  if ($1 == prev) {
    ok = "done"
  } else {
    ok = "active"
  }
  if (NF == 3 && $3+0==$3) {
    x = $3
    gsub(/\./,"",x);
    if ($2 ~ /TIMEOUT/ || $2 ~ /Memory Limit/ || $2 ~ /ERROR/) {
      stat = "crit"
    } else {
      stat = ok
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
      stat = ok
    }
    printf "section %s\n", $1
    printf "%s : %s, 0, %s\n", line_name, stat, x
  }
  prev = $1
}
' <<< "$input1_2" >> "$output"


echo "TL : vert, "$TL1"000, "$TL1"000" >> "$output"





mkdir -p graphs

cfg=$(mktemp)
printf '{"maxTextSize":200000}\n' > "$cfg"

mmdc -i "$output" -o "./graphs/${lib1}-vs-${lib2}.svg" -c "$cfg"

# Clean up
rm -f "$output"
rm -f "$cfg"
