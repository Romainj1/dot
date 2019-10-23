#!/bin/bash
# ssh-multi
# D.Kovalov
# Based on http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html

# a script to ssh multiple servers over multiple tmux panes

starttmux() {
  HOSTS=$@

  if [ -z $TMUX]; then
    echo "Please run tmux"
  else

    if [ -z "$HOSTS" ]; then
      echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
      read HOSTS
    fi

    FIRST_HOST=$(echo $HOSTS | cut -d' ' -f1)
    HOSTS=$(echo $HOSTS | cut -d' ' -f2-)

    tmux new-window "ssh $FIRST_HOST"
    for i in "$HOSTS"; do
        tmux split-window -h  "ssh $i"
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
  fi
}

ksr() {
  HOSTS=$(echo $@ | sed "s/-/_/g")
  QUERY=$(echo $(printf "role:*%s* " $HOSTS ) | sed "s/ / AND /g")
  knife search "$QUERY" -i 2> /dev/null | cut -d'.' -f1 # Get ridden of the .localdomain of some Hosts 
}

kst() {
  # Check here to fail fast
  if [ -z $TMUX]; then
    echo "Please run tmux"
  else
    PARAMS=$@
    HOSTS=$(ksr $PARAMS)
    starttmux $HOSTS
  fi
}
