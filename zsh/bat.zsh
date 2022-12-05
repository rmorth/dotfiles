if [ "$(command -v bat)" ]; then
	export BAT_THEME="Dracula"
	alias cat='bat --style header --style rule --style snip --style changes --style header'

	# pretty man pages :)
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi
