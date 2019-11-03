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

PREFIX="[${FG_RED}cleanup.sh${DEFAULT}]"

# echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Emptying ${FG_GREEN}temp/${DEFAULT} ..."
rm temp/* -f

# echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Sorting ${FG_GREEN}config/archive.txt${DEFAULT}"
sort -n config/archive.txt > config/archive_sorted.txt
rm config/archive.txt
mv config/archive_sorted.txt config/archive.txt

# echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Deleting subfolders (if empty) in ${FG_GREEN}archives/${DEFAULT}"
find "${NAGARE_PATH}/archives" -mindepth 1 -type d -empty -delete
