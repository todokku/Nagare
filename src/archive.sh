#!/bin/bash

URL="$1"

./bin/youtube-dl --config-location ./config/youtube-dl.conf $URL

./bin/rclone --exclude "*.part" move ./archives youtube: --bwlimit 20M --stats-one-line --stats 60m -v
