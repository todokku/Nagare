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

NAGARE_PATH=$(cat config/config.json | bin/jq -r ".nagare_path")
cd "${NAGARE_PATH}"

PREFIX="[${FG_MAGENTA}upkeep.sh${DEFAULT}]"

echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Cleaning up leftover files from previous runs"
src/cleanup.sh

INDEX=1
NUMOFLINES=$(wc -l < "config/channels.txt")

while IFS= read -r channel_url
do
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Processing channel ${FG_GREEN}$((INDEX++))${DEFAULT} of ${FG_GREEN}${NUMOFLINES}${DEFAULT}"
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Processing ${FG_GREEN}${channel_url}${DEFAULT}"
  src/archive.sh "$channel_url"
  src/cleanup.sh
done < config/channels.txt
