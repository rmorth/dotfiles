if [ "$(command -v eza)" ]; then
	# Replace ls with eza but keep ls
	alias als="command ls --color=always --group-directories-first"
	alias ls='eza --color=always --group-directories-first'		# preferred listing
	alias la='eza -a --color=always --group-directories-first'  # all files and dirs
	alias ll='eza -l --color=always --group-directories-first'  # long format
	alias l="eza -lah --color=always --group-directories-first"
	alias lr="eza -lahr --sort=modified --color=always --group-directories-first"
fi
