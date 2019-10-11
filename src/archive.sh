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

URL="$1"
PREFIX="[${FG_CYAN}archive.sh${DEFAULT}]"

DESTINATION="$(cat config/config.json | bin/jq -r ".destination")"
RCLONE_BWLIMIT="$(cat config/config.json | bin/jq -r ".rclone_bwlimit")"

touch config/archive.txt
touch temp/current.txt
touch temp/diff.txt

echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Saving videos URL in ${FG_GREEN}temp/current.txt${DEFAULT}"
bin/youtube-dl -j --flat-playlist $URL | bin/jq -r ".id" | sed "s_^_youtube _" >> temp/current.txt
echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Sorting ${FG_GREEN}temp/current.txt${DEFAULT}"
sort -n temp/current.txt > temp/current_sorted.txt

echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Saving new videos URL in ${FG_GREEN}temp/diff.txt${DEFAULT}"
comm -23 temp/current_sorted.txt config/archive.txt > temp/diff.txt

INDEX=1
NUMOFLINES=$(wc -l < "temp/diff.txt")

if [[ "$NUMOFLINES" == "0" ]]; then
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} ${FG_YELLOW}No new video${DEFAULT}"
fi

while IFS= read -r line
do
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Downloading video ${FG_GREEN}$((INDEX++))${DEFAULT} of ${FG_GREEN}${NUMOFLINES}${DEFAULT}"
  YOUTUBE_ID="$(echo $line | cut -d " " -f 2)"
  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Downloading ${FG_GREEN}https://youtu.be/$YOUTUBE_ID${DEFAULT}"
  bin/youtube-dl --config-location config/youtube-dl.conf "https://youtu.be/$YOUTUBE_ID"

  echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] ${PREFIX} Uploading to ${FG_YELLOW}$DESTINATION${DEFAULT}"
  bin/rclone --exclude "*.part" move archives/ $DESTINATION --bwlimit $RCLONE_BWLIMIT --stats-one-line --stats 1m -v
done < temp/diff.txt
