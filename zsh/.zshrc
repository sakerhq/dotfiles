
# Path to your dotfiles installation.
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# the official Saker theme
ZSH_THEME="saker"

plugins=(git bundler dotenv osx rake rvm ruby)

source $ZSH/oh-my-zsh.sh

config_files=($DOTFILES/zsh/*.zsh)
for file in $config_files; do
  source $file
done

ZSH_CUSTOM=$DOTFILES/zsh

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
