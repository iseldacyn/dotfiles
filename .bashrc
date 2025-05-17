#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -e $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

#color codes
normal="\[\e[0m"
black="\[\e[30m"
red="\[\e[31m"
green="\[\e[32m"
yellow="\[\e[33m"
blue="\[\e[34m"
magenta="\[\e[35m"
cyan="\[\e[36m"
lightgray="\[\e[37m"
gray="\[\e[90m"
lightred="\[\e[91m"
lightgreen="\[\e[92m"
lightyellow="\[\e[93m"
lightblue="\[\e[94m"
lightmagenta="\[\e[95m"
lightcyan="\[\e[96m"
white="\[\e[97m"

export PS1="${magenta}\u${cyan}@${magenta}\h ${cyan}\W ${yellow} <(arf bark woof!)${green}\n    --> ${normal}"
