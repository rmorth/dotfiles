#!/bin/bash

declare -A REPOS=(
  ["Nexar SDK"]="getnexar/nexar-client-sdk"
  ["Platform AONI"]="getnexar/nexar_n1"
  ["Dotfiles"]="rmorth/dotfiles"
)

selected_repo=$(printf "%s\n" "${!REPOS[@]}" | rofi -dmenu -i -p "Review Requests For")
[ -z "$selected_repo" ] && exit

prs=$(gh pr list --repo "${REPOS[$selected_repo]}" --search "review-requested:@me state:open" --json number,title,author \
  --template '{{range .}}{{printf "#%v - %.57s - %s\n" .number .title .author.login}}{{end}}')

[ -z "$prs" ] && notify-send "No review requests" "You're not a reviewer for anything in $selected_repo" && exit

selected=$(echo "$prs" | rofi -dmenu -p "Review PRs (${REPOS[$selected_repo]})")
pr_number=$(echo "$selected" | grep -oE '^#[0-9]+' | tr -d '#')
[ -n "$pr_number" ] && gh pr view "$pr_number" --repo "${REPOS[$selected_repo]}" --web

