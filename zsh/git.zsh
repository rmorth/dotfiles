if [ "$(command -v git)" ]; then
	alias vgit="$EDITOR ~/.gitconfig"
	alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
	alias gs="g s" # fix typo, don't open ghostscript and DON'T uninstall it
fi
