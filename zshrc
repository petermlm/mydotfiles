# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="petermlm"

# My alias
alias cdp="pwd > ~/.cd_dump"
alias cdc="cd \$(cat ~/.cd_dump)"
alias vim="vim -p"
alias sl="ls"
alias sd="sudo docker"

# For Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Plugins
plugins=(git python docker)

# Add oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
