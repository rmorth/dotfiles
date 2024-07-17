if [ "$(command -v oh-my-posh)" ]; then
    eval "$(oh-my-posh init zsh -c ~/.config/oh-my-posh/config.toml)"
    alias vomp="$EDITOR ~/.config/oh-my-posh/config.toml"
fi
