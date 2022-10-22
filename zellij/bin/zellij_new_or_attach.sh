#!/usr/bin/env bash

# Create a new or attach to an existing zellij session, with special naming.
# 
# In particular, this script prefixes the date to each new session, which
# is a nice way to organize things (newer sessions are listed closer to the
# prompt).
# 
#
# Usage:
#       # List sessions:
#       zj
#       # Create a new session named "alice":
#       zj alice
#       # Attach to session named "alice":
#       zj alice
#       or
#       zj ali

NAME=$1

if [[ ! $NAME ]] ; then
    # Just print out zellij ls and exit.
    zellij ls
    exit
fi

DATE=`date +'%Y%m%d'`
NEW_SESSION="${DATE}_${NAME}"

NUMBER_MATCHING=`zellij ls &> /dev/null && zellij ls 2> /dev/null | grep $NAME | wc -l`
if [ "$NUMBER_MATCHING" ] && [ "$NUMBER_MATCHING" -gt "1" ]; then
    echo "Too many matching names.  Be more specific."
    exit
fi

EXISTING_SESSION=`zellij ls 2> /dev/null | grep $NAME | sed -e 's/:.*//'`

if [[ $EXISTING_SESSION ]] ; then
    zellij attach "$EXISTING_SESSION"
else
    zellij attach --create "$NEW_SESSION"
fi
