#!/bin/sh
# Original news.sh script by Rodolfo Novak.
# News.sh website: http://code.google.com/p/sh-rss-feed/.

# Edited to become Tweets.sh by SphereCat1.
# Version 1.5: Got rid of extra space on the left & now replaces all unknown characters with ?. (Fixed it temporarily to work with multiple lengths. Working on figuring out a permanent solution.)

# Here are the variables you can edit safely:

# Feed URL, with username & password in the correct spots:
URL="http://USERNAME:PASSWORD@twitter.com/statuses/friends_timeline.rss"

# Number of updates to display:
HOWMANY=10

# This one specifies the divider between tweets. Double spaced is default.
# All other Unix escape characters work too. Preface them with two extra backslashes.
DIVIDER="\\\n\\\n"

# Specify the maximum width using the fmt command. 0 to turn off.
FMT="30"

# K, now no more editing unless you know what you're doing.
# (Or you have a backup copy)

headarg=$((0-($HOWMANY+1)))

TWEETS=$(curl --silent "$URL")

  if [[ $TWEETS == *\<error\>* ]]; then
    grep -E '(error>)' tweets.txt | \
    sed -e 's/<error>//' -e 's/<\/error>//' |
    sed -e 's/<[^>]*>//g' |
    
    head $headarg

  else
	TEMP=$(
    printf "%s\n" "$TWEETS" | grep -E '(description>)' | \
	head $headarg |
    sed -n '2,$p' | \
    sed -e 's/<description>//' -e 's/<\/description>//' |
    sed -e 's/<[^>]*>//g' |
    sed -e 's/\&amp\;/\&/g' |
    sed -e 's/\&lt\;/\</g' |
    sed -e 's/\&gt\;/\>/g' |
    sed -e 's/\&quot\;/\"/g' |
    sed -e 's/\&\#*[a-z]*[0-9]*\;/\?/g' |
	sed -e 's/^  *//g' |
	sed -e :a -e '$!N;s/\n/\*DIVIDER\*/;ta' |
	sed -e "s/\*DIVIDER\*/$DIVIDER/g")
	
	echo $TEMP
  fi
  
  if [[ "$FMT" -gt "0" ]]; then
	echo $TEMP | fmt -w "$FMT"
  else
	echo $TEMP
  fi