#!/bin/sh
# Original news.sh script by Rodolfo Novak.
# News.sh website: http://code.google.com/p/sh-rss-feed/.

# Edited to become Tweets.sh by SphereCat1.
# Version 1.1: Fixed bug that was skipping the first two tweets, cleaned up code.

# Here are the variables you can edit safely:

# Feed URL, with username & password in the correct spots:
URL="http://USERNAME:PASSWORD@YOUR_TWITTER_FEED"

# Number of updates to display:
HOWMANY="10"

# K, now no more editing unless you know what you're doing.
# (Or you have a backup copy)

headarg="-$HOWMANY"

curl --silent "$URL" | grep -E '(description>)' | \
  sed -n '2,$p' | \
  sed -e 's/<description>/   /' -e 's/<\/description>//' |
  sed -e 's/<[^>]*>//g' |
  sed -e 's/\&amp\;/\&/g' |

  head $headarg | sed G | fmt
