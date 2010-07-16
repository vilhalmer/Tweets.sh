#!/bin/sh
# Original news.sh script by Rodolfo Novak.
# News.sh website: http://code.google.com/p/sh-rss-feed/.

# Edited to become Tweets.sh by SphereCat1.
# Version 1.4.1: Got rid of extra space on the left & now replaces all unknown characters with ?. (Fixed it temporarily to work with multiple lengths. Working on figuring out a permanent solution.)

# Here are the variables you can edit safely:

# Feed URL, with username & password in the correct spots:
URL="http://USERNAME:PASSWORD@twitter.com/statuses/friends_timeline.rss"

# Number of updates to display:
HOWMANY="10"

# K, now no more editing unless you know what you're doing.
# (Or you have a backup copy)

headarg="-$HOWMANY"

curl --silent "$URL" > tweets.txt

  if [[ `cat tweets.txt` == *\<error\>* ]]; then
    grep -E '(error>)' tweets.txt | \
    sed -e 's/<error>//' -e 's/<\/error>//' |
    sed -e 's/<[^>]*>//g' |
    
    head $headarg | sed G | fmt

  else
    grep -E '(description>)' tweets.txt | \
    sed -n '2,$p' | \
    sed -e 's/<description>//' -e 's/<\/description>//' |
    sed -e 's/<[^>]*>//g' |
    sed -e 's/\&amp\;/\&/g' |    # Amperstand
    sed -e 's/\&lt\;/\</g' |     # Less-than
    sed -e 's/\&gt\;/\>/g' |     # Greater-than
    sed -e 's/\&quot\;/\"/g' |   # Double quoted
    sed -e 's/\&....\;/\?/g' |   # Replace all unknown characters with ?
    sed -e 's/\&.....\;/\?/g' |   # Same as above...

    head $headarg | sed G | fmt
  fi