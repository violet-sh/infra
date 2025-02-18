#!/usr/bin/env bash
set -eou pipefail

# Colors
black="\033[30m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
purple="\033[35m"
cyan="\033[36m"
white="\033[37m"
bold_black="\033[30;1m"
bold_red="\033[31;1m"
bold_green="\033[32;1m"
bold_yellow="\033[33;1m"
bold_blue="\033[34;1m"
bold_purple="\033[35;1m"
bold_cyan="\033[36;1m"
bold_white="\033[37;1m"
reset="\033[0m"

# Styles
declare -A styles=(
    [name]="$reset"
    [mountpoint]="$green"
    [mounted]="$purple"
    [used]="$yellow"
    [available]="$red"
    [compression]="$cyan"
    [compressratio]="$green"
    [encryption]="$black"
)

properties=${ZLS_PROPERTIES:-name,mountpoint,mounted,used,available,compression,compressratio,encryption}
header=$(echo ${properties//,/ ,} | sed -r 's/(^|,)([a-z])/\U\2/g')

cmd="{print"
idx=1
for prop in ${properties//,/ }; do
    cmd+=" \"${styles[$prop]}\" \$$idx,";
    let idx+=1;
done
cmd="${cmd::-1}}"

echo -e "$header\n$(
    zfs list -Ho $properties | \
    awk -F "\t" -v OFS=" " "$cmd"
)" | \
column -t -s " "
