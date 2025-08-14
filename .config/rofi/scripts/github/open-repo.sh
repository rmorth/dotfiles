#!/bin/bash

declare -A REPOS=(
  ["Nexar SDK"]="getnexar/nexar-client-sdk"
  ["Platform AONI"]="getnexar/nexar_n1"
  ["Dotfiles"]="rmorth/dotfiles"
)

repo=$(printf "%s\n" "${!REPOS[@]}" | rofi -dmenu -i -p "Open Repo")
[ -z "$repo" ] && exit

gh repo view --web "${REPOS[$repo]}"
