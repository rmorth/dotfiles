if [ "$(command -v tmux)" ]; then
	alias vtmux="$EDITOR ~/.tmux.conf"

	if [ "$(command -v tmuxinator)" ]; then
		alias mux="tmuxinator"
	fi
fi

# Enter tmux right away
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
# 	tmux attach -t default || tmux new -s default
# fi
