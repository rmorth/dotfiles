#!/usr/bin/env bash

THEME="gruvbox"
CONFIG_DIR=$(dirname $0)/themes/$THEME/config.ini
echo $CONFIG_DIR

killall polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# polybar on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR="$m" polybar --reload main -c $CONFIG_DIR &
  done
else
  polybar --reload main -c $CONFIG_DIR &
fi
