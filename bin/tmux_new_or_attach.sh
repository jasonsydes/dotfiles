#!/usr/bin/env bash

# Create a new or attach to an existing tmux session, with special naming.
# 
# In particular, this script prefixes the date to each new session, which
# is a nice way to organize things (newer sessions are listed closer to the
# prompt).
# 
#
# Usage:
#       # List sessions:
#       tm
#       # Create a new session named "alice":
#       tm alice
#       # Attach to session named "alice":
#       tm alice
#       or
#       tm ali

NAME=$1

if [[ ! $NAME ]] ; then
    # Just print out tmux ls and exit.
    tmux ls
    exit
fi

DATE=`date +'%y%m%d'`
NEW_SESSION="${DATE}-${NAME}"

NUMBER_MATCHING=`tmux ls &> /dev/null && tmux ls 2> /dev/null | grep $NAME | wc -l`
if [ "$NUMBER_MATCHING" ] && [ "$NUMBER_MATCHING" -gt "1" ]; then
    echo "Too many matching names.  Be more specific."
    exit
fi

EXISTING_SESSION=`tmux ls 2> /dev/null | grep $NAME | sed -e 's/:.*//'`

if [[ $EXISTING_SESSION ]] ; then
    tmux attach -t "$EXISTING_SESSION"
else
    tmux new -s "$NEW_SESSION"
fi
