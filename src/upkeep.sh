#!/bin/bash

cd /mnt/d/code/nagare

while IFS= read -r line
do
  echo "$line"
  ./src/archive.sh "$line"
done < ./config/channels.txt
