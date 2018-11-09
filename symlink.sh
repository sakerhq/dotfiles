#!/bin/bash

# Usage
# cd ~/dotfiles
# chmod +x symlink.sh
# ./symlink.sh

echo 'symlinking...'
chsh -s $(which zsh)

# git
echo '...git'
mkdir $HOME/.gitconfig.d
ln -s $HOME/.dotfiles/git/.gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/git/.gitmessage $HOME/.gitconfig.d/.gitmessage
ln -s $HOME/.dotfiles/git/alias.txt $HOME/.gitconfig.d/alias.txt
ln -s $HOME/.dotfiles/git/color.txt $HOME/.gitconfig.d/color.txt

# ruby
echo '...ruby'
ln -s $HOME/.dotfiles/ruby/.gemrc $HOME/.gemrc

# zsh
# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
echo '...zsh'
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

echo '...done...'

RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
BOLD="$(tput bold)"
NOCOLOR="$(tput sgr0)"

echo
echo -en $RED'-_-_-_-_-_-_-_'
echo -e $NOCOLOR$BOLD$WHITE',------,'$NOCOLOR
echo -en $YELLOW$WHIT'_-_-_-_-_-_-_-'
echo -e $NOCOLOR$BOLD$WHITE'|   /\_/\\'$NOCOLOR
echo -en $GREEN'-_-_-_-_-_-_-'
echo -e $NOCOLOR$BOLD$WHITE'~|__( ^ .^)'$NOCOLOR
echo -en $CYAN'-_-_-_-_-_-_-'
echo -e $NOCOLOR$BOLD$WHITE'""  ""'$NOCOLOR
echo

source $HOME/.zshrc
