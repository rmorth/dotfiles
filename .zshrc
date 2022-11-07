export EDITOR='vim'
export VISUAL='vim'
export HISTCONTROL=ignoreboth:erasedups

export MWYL_KDRIVE=$HOME/kdrive
export MWYL_WORKSPACE=$HOME/workspace

export OMZ="$HOME/.oh-my-zsh/"

plugins=(git zsh-autosuggestions sudo docker docker-compose gitignore fzf-tab zsh-syntax-highlighting)
source $OMZ/oh-my-zsh.sh

SAVEHIST=1000000
HISTSIZE=1000000
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time
setopt GLOB_DOTS # include '.' in wildcards

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

source $HOME/zsh/utils.zsh

add_path "$HOME/.bin"
add_path "$HOME/.local/.bin"
add_path "$HOME/.cargo/bin"
add_path "$HOME/.fzf/bin"
add_path "$HOME/.local/share/gem/ruby/3.0.0/bin"

# Alt keys might not be working to move through words
# If you want to double-check the key codes, use cat
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

for ZSH_CONFIG_FILE in $HOME/zsh/*; do
    if [ -r $ZSH_CONFIG_FILE ]; then
        source $ZSH_CONFIG_FILE
    else
        echo "file not readable or not found: $ZSH_CONFIG_FILE"
    fi
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
