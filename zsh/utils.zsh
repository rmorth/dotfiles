alias vzsh="$EDITOR ~/.zshrc"

alias curtime="date +%H:%M' '%Y-%m-%d' W:'%U"
alias msepoch="date +%s%N | cut -b1-13"

alias sbell='paplay /usr/share/sounds/freedesktop/stereo/complete.oga'

alias rm="rm -v"
alias df='df -h'

# list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"

# use xclip to clipboard target as default
alias xclip='xclip -selection c'

# Preview files using fzf
alias see="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Amenities
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ex = EXtractor for all kinds of archives
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

add_path ()
{
	if [ -z $1 ] ; then
		return 1
	fi

	if [ ! -d $1 ] ; then
		return 1
	fi

	# FIXME: this isn't 100% correct
	# leads to duplicated entries, needs regex
	if echo $PATH | grep ":$1:" > /dev/null; then
		return 1
	fi

	export PATH="$PATH:$1"
}

# MOVE THESE OUT
ijq ()
{
	if [ -z $1 ]; then
		echo "usage: ijq <json_file>"
		return 1
	fi

	if [ ! -f $1 ] ; then
		echo "File $1 not found."
		return 1
	fi

	echo '' | fzf --print-query --preview-window=up,99% --preview "jq --color-output {q} < $1"
}

rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	open "$file"
}
