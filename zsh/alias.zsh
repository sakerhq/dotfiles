# Example aliases
# alias zshconfig="nano ~/.zshrc"
# alias ohmyzsh="nano ~/.oh-my-zsh"
alias n="nano"
alias ls='ls -lAFh'
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Shortcuts
alias atom="atom ./"
alias e="$EDITOR"

[[ -f ~/.aliases.local ]] && source ~/.aliases.local
