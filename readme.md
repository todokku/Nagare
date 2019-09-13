**For a single run**

```bash
cd /path/to/nagare
src/archive.sh URL
```

**Otherwise, Getting started**

(Omit step 1, 2 and 3 if you just want to store the files locally)

1. Setup `bin/rclone config`.
2. Edit `youtube:` in `src/archive.sh:7` to the name of your remote storage.
3. Edit `src/upkeep.sh:3` to `cd` into the path where you have `Nagare`
4. Append all your desired YouTube channel URL(s) in `config/channels.txt` in a new line.
5. Make a cron job (adjust the frequency as needed).
```
0 0 * * * /path/to/nagare/src/upkeep.sh
```

**TODO**

Run `rclone` after downloading each file. (This will lessen the required local disk space when downloading multiple videos in a single `youtube-dl` run)
