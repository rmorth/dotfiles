#!/bin/bash

choice=$(printf "Open Repository\nList PRs\nReview Requests\n" | rofi -dmenu -i -p "GitHub Menu")
script_dir="$HOME/.config/rofi/scripts"

case "$choice" in
  "Open Repository")
    $script_dir/github/open-repo.sh
    ;;
  "List PRs")
    $script_dir/github/pr-list.sh
    ;;
"Review Requests")
    $script_dir/github/pending-reviews.sh
    ;;
esac

