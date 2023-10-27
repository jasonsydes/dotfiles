#!/usr/bin/env bash

# Make all panes "sudo ready" in a given tmux session.
#
# What does that mean? Basically, I hate typing my long password into multiple tmux panes in a given tmux session,
# so this command just takes A SINGLE ENTRY OF SUDO sends a simple "sudo -E echo" command to every pane in a 
# given session. Then, sudo will be "active" for the next however many minutes in all panes for the entire session, 
# allowing me to just prefix commands needing sudo with 's'.
#
# Usage:
#       # Activate sudo for all panes in the "alice" session.
#       tms alice

NAME=$1

if [[ ! $NAME ]] ; then
    # Just print usage and exit.
    echo "Usage:"
    echo "    tms partial_substr_of_session_name"
    echo "Example:"
    echo "    # send sudo to 20231027_alice"
    echo "    tms alice"
    exit
fi

NUMBER_MATCHING=`tmux ls &> /dev/null && tmux ls 2> /dev/null | grep $NAME | wc -l`
if [ "$NUMBER_MATCHING" ] && [ "$NUMBER_MATCHING" -gt "1" ]; then
    echo "Too many matching session names.  Be more specific."
    exit
fi

EXISTING_SESSION=`tmux ls 2> /dev/null | grep $NAME | sed -e 's/:.*//'`

if [[ ! $EXISTING_SESSION ]] ; then
    echo "Weird (or is this normal?), no matching sessions???"
    exit
fi

echo
echo "WARNING: DANGER OF LEAKING PASSWORD TO YOUR BASH HISTORY!!!"
echo "         PLEASE ENSURE THE FOLLOWING ARE TRUE BEFORE CONTINUING:"
echo
echo "         1. Every pane in session $EXISTING_SESSION is sitting an empty prompt."
echo "         2. Every pane has a normal user (a non-root user)."
echo "         3. No pane is recently 'sudo active' (i.e., no pane was recently given successful sudo command... )"
echo "         4. Please don't use this if your name isn't JasonS, thanks...."
echo 
sleep 1

echo "ENTER [sudo] password for $USER:"
read -s PASSWORD

# Gather up the list of panes
PANES=$(tmux list-panes -a | grep "^$EXISTING_SESSION:" | awk '{print $1}' | sed -e 's/:$//')

for PANE in $PANES; do 
    echo Sending sudo command to $PANE
    tmux send-keys -t $PANE "sudo -E echo Activating sudo..." ENTER
    sleep 0.5
    tmux send-keys -t $PANE "$PASSWORD" ENTER
done
