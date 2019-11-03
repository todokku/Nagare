#!/bin/bash

# Colors

BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
DEFAULT="\033[0;37m"
DARK_GRAY="\033[1;30m"
FG_RED="\033[1;31m"
FG_GREEN="\033[1;32m"
FG_YELLOW="\033[1;33m"
FG_BLUE="\033[1;34m"
FG_MAGENTA="\033[1;35m"
FG_CYAN="\033[1;36m"
FG_WHITE="\033[1;37m"

NAGARE_PATH=$(cat config/config.json | jq -r ".nagare_path")
cd "${NAGARE_PATH}"

PREFIX="[${FG_CYAN}getid.sh${DEFAULT}]"

DESTINATION="$(cat config/config.json | jq -r ".destination")"

# echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Cleaning up leftover files from previous runs"
rm temp/* -f

# Save IDs in ids.txt
echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Savings IDs in ${FG_GREEN}ids.txt${DEFAULT}"
bin/rclone lsf ${DESTINATION} -R | cut -d "/" -f 2 | cut -d "]" -f 1 | cut -d "[" -f 2 > temp/ids.txt

# Remove empty lines from ids.txt
sed -i "/^$/d" temp/ids.txt

# Add `youtube ` prefix
sed 's_^_youtube _' temp/ids.txt > temp/ids_with_prefix.txt

# Sorting ids.txt
echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Sorting ${FG_GREEN}temp/ids.txt${DEFAULT}"
sort -n temp/ids_with_prefix.txt > temp/ids_sorted.txt
