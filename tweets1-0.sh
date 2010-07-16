#!/bin/sh
# Original news.sh script by rodolfo.novak on Google Code.
# News.sh website: http://code.google.com/p/sh-rss-feed/

# Edited to become Tweets.sh by SphereCat1.

# Here are the variables you can edit safely:

# Feed URL, with username & password in the correct spots:
URL="http://USERNAME:PASSWORD@YOUR_TWITTER_FEED"

# Number of updates to display:
HOWMANY="10"

# K, now no more editing unless you know what you're doing.
# (Or you have a backup copy)

if [ $# -eq 1 ] ; then
  headarg=$(( $1 * 2 ))
else
  headarg="-$HOWMANY"
fi

curl --silent "$URL" | grep -E '(description>)' | \
  sed -n '4,$p' | \
  sed -e 's/<description>/   /' -e 's/<\/description>//' | \
  sed -e 's/<!\[CDATA\[//g' |            
  sed -e 's/\]\]>//g' |         
  sed -e 's/<[^>]*>//g' |
  sed -e 's/\&amp\;/\&/g' |

  head $headarg | sed G | fmt
