if [ "$(command -v bat)" ]; then
	export BAT_THEME="Dracula"
	alias cat='bat --style header --style rules --style snip --style changes --style header'
fi
