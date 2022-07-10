if [ "$(command -v exa)" ]; then
	# Replace ls with exa but keep ls
	alias als="command ls --color=always --group-directories-first"
	alias ls='exa --color=always --group-directories-first'		# preferred listing
	alias la='exa -a --color=always --group-directories-first --no-icons'  # all files and dirs
	alias ll='exa -l --color=always --group-directories-first --no-icons'  # long format
	alias l="exa -lah --color=always --group-directories-first"
	alias lr="exa -lahr --sort=modified --color=always --group-directories-first"
fi
