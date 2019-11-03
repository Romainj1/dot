#!/bin/bash
# ssh-multi
# D.Kovalov
# Based on http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html

# a script to ssh multiple servers over multiple tmux panes


starttmux() {
    if [ -z "$HOSTS" ]; then
       echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
       read HOSTS
    fi

    local hosts=( $HOSTS )


    tmux new-window "ssh ${hosts[0]}"
    unset hosts[0];
    for i in "${hosts[@]}"; do
        sleep 0.1
        tmux split-window -h  "ssh $i"
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null

}

HOSTS=$*



if ! [ "$1" = "-k" ]; then
  # HOSTS=$*
  HOSTS=$(echo $HOSTS | sed "s/-/_/g")
  QUERY=$(echo $(printf "role:*%s* " $HOSTS ) | sed "s/ / AND /g")
  HOSTS=$(knife search "$QUERY" -i 2> /dev/null | cut -d'.' -f1) # Get ridden of the .localdomain of some Hosts
else
  shift 1
  HOSTS=$*
fi

if [ "$1" = "-e" ]; then
  shift 1
  echo $HOSTS
  exit 0
fi

starttmux
