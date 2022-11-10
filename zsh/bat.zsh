if [ "$(command -v bat)" ]; then
	export BAT_THEME="Dracula"
	alias cat='bat --style header --style rule --style snip --style changes --style header'
fi
