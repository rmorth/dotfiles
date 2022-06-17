if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
	tmux attach -t default || tmux new -s default
fi

# Path to your oh-my-zsh installation.
#installation via script from github
#export ZSH="/home/$USER/.oh-my-zsh"
#installation via paru -S oh-my-zsh-git
export ZSH=/usr/share/oh-my-zsh/

# Path of kdrive, useful in scripting (i.e tmuxinator)
export KDRIVE=$HOME/kdrive

if uname --kernel-version | grep -q 'Arco'; then
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# if you installed the package oh-my-zsh-powerline-theme-git then you type here "powerline" as zsh theme
ZSH_THEME="robbyrussell" # set by `omz`

# Alt keys might not be working to move through words
# If you want to double-check the key codes, use cat
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

SAVEHIST=1000000
HISTSIZE=1000000
# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

if test -z "$HISTFILE"
then
  HISTFILE="$HOME/.zsh_history"
fi

if ! test -f "$HISTFILE"
then
  echo >&2 "NOTE: \$HISTFILE does not exist, creating it ..."

  mkdir -p "$(dirname "$HISTFILE")"
  touch $HISTFILE
fi

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Hyphen-insensitive completion, _ and - will be interchangeable.
# Case-sensitive completion must be off.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions sudo docker docker-compose gitignore fzf-tab zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

### Some of these might be arch only

setopt GLOB_DOTS

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth:erasedups

export EDITOR='vim'
export VISUAL='vim'

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/share/gem/ruby/3.0.0/bin" ] ;
  then PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
fi

if [ -d "$HOME/.fzf/bin" ] ;
  then PATH="$HOME/.fzf/bin:$PATH"
fi

# ex = EXtractor for all kinds of archives
## usage: ex <file>
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

#create a file called .zshrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.
[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

eval "$(starship init zsh)"

### ALIASES

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"
alias curtime="date +%H:%M' '%Y-%m-%d' W:'%U"
alias msepoch="date +%s%N | cut -b1-13"

# tmuxinator alias
alias mux="tmuxinator"

# Replace ls with exa but keep ls
alias als="command ls --color=always --group-directories-first"
alias ls='exa --color=always --group-directories-first'		# preferred listing
alias la='exa -a --color=always --group-directories-first --no-icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --no-icons'  # long format
alias l="exa -lah --color=always --group-directories-first"
alias lr="exa -lahr --sort=modified --color=always --group-directories-first"
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace cat with bat
alias cat='bat --style header --style rules --style snip --style changes --style header'

# Fix typos
alias gs="g s" # don't open ghostscript and DON'T uninstall it

# Other amenities
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rm="rm -v"
alias df='df -h'

alias xclip='xclip -selection c'
alias onefetch='onefetch --show-logo=auto'

# Configuration related aliases 
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias vzsh="$EDITOR ~/.zshrc"
alias vkitty="$EDITOR ~/.config/kitty/kitty.conf"
alias valacritty="$EDITOR ~/.config/alacritty/alacritty.yml"
alias vstarship="$EDITOR ~/.config/starship.toml"
alias vgit="$EDITOR ~/.gitconfig"
alias vtmux="$EDITOR ~/.tmux.conf"

if hostnamectl | grep -q 'veniam'; then
	alias ossh="obu-ssh"

	getpass() {
		if [ -n "$1" ]
		then
			obu-pass "$1" | xclip
		else
			echo Needs DEVICE_ID
		fi
	}

	acc() {
		if [ -n "$1" ]
		then
			obu-pass "$1" | xclip
			obu-ssh  "$1"
		else
			echo Needs DEVICE_ID
		fi
	}
fi

if uname --kernel-version | grep -q 'Ubuntu'; then
fi

if uname --kernel-version | grep -q 'Arco'; then
	#pacman unlock
	alias unlock="sudo rm /var/lib/pacman/db.lck"
	alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

	#arcolinux logout unlock
	alias rmlogoutlock="sudo rm /tmp/arcologout.lock"

	#which graphical card is working
	alias whichvga="/usr/local/bin/arcolinux-which-vga"

	alias pacman='pacman --color auto'

	#Cleanup orphaned packages
	alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

	# Recent installed packages
	alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

	# Sort installed packages according to size in MB
	alias big="expac -H M '%m\t%n' | sort -h | nl"

	#iso and version used to install ArcoLinux
	alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
