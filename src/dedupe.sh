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

PREFIX="[${FG_CYAN}dedupe.sh${DEFAULT}]"

DESTINATION="$(cat config/config.json | bin/jq -r ".destination")"

# Save IDs in asdf.txt
echo -e "${PREFIX} Savings IDs in ${FG_GREEN}asdf.txt${DEFAULT}"
bin/rclone lsf $DESTINATION -R | cut -d "/" -f 2 | cut -d "]" -f 1 | cut -d "[" -f 2 > temp/asdf.txt

# Remove empty lines from asdf.txt
sed -i "/^$/d" temp/asdf.txt

# Extract duplicates lines
echo -e "${PREFIX} Extracting dupes into ${FG_GREEN}dupe.txt${DEFAULT}"
sort -n temp/asdf.txt | uniq -d > temp/dupe.txt

while IFS= read -r line
do
  # Delete dupes from DESTINATION
  echo -e "${PREFIX} Deleting dupes from ${FG_GREEN}${DESTINATION}${DEFAULT}"
  bin/rclone delete -n $DESTINATION --include "*$line*"

  # Delete dupes from archive.txt
  echo -e "${PREFIX} Deleting dupes from ${FG_GREEN}archives.txt${DEFAULT}"
  sed -i "/^youtube ${line}/d" temp/archive.txt
done < temp/dupe.txt

echo -e "${PREFIX} Deleting ${FG_GREEN}asdf.txt${DEFAULT}"
rm temp/asdf.txt
echo -e "${PREFIX} Deleting ${FG_GREEN}dupe.txt${DEFAULT}"
rm temp/dupe.txt
