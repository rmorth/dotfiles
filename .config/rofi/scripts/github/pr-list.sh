#!/bin/bash

declare -A REPOS=(
  ["Nexar SDK"]="getnexar/nexar-client-sdk"
  ["Platform AONI"]="getnexar/nexar_n1"
  ["Dotfiles"]="rmorth/dotfiles"
)

repo_choice=$(printf "%s\n" "${!REPOS[@]}" | rofi -dmenu -p "Choose Repo")
[ -z "$repo_choice" ] && exit 1

selected_repo="${REPOS[$repo_choice]}"

prs=$(gh pr list --repo "$selected_repo" --limit 20 --json number,title,headRefName,author \
  --template '{{range .}}{{printf "#%v - %s - %s\n" .number .title .author.login}}{{end}}')
[ -z "$prs" ] && notify-send "No PRs found for $repo_choice" && exit 0

selected=$(echo "$prs" | rofi -dmenu -p "PRs in $repo_choice")
pr_number=$(echo "$selected" | awk '{print $1}')
[ -n "$pr_number" ] && gh pr view "$pr_number" --repo "$selected_repo" --web

