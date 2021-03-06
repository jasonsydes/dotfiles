#!/bin/sh
alias reload!='exec "$SHELL" -l'

# Hack so that watch can 'see' aliases:
alias watch='watch '

# Better versions of squeue
#alias sq='squeue -o "%.10i %.9P %.30j %.12u %.12g %.8T %.11M %.11l %.5D %4C %6b %.10m %R %Y"'
alias sq='squeue -o "%.10i %.9P %.30j %.12u %.12g %.8T %.11M %.11l %.5D %4C %6b %R %Y"'
alias sq2='squeue -O jobid:.8,partition:.10,name:.31,username:.13,groupname:.13,state:.13,timeused:.13,timelimit:.13,numnodes:.6,numcpus:.5,gres:7,reasonlist,tres'

