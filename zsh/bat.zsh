if [ "$(command -v bat)" ]; then
	export BAT_THEME="gruvbox-dark"
	alias cat='bat --style header --style rule --style snip --style changes --style header'

	# pretty man pages :)
    export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi
