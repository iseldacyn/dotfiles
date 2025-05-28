#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -e $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

# color codes
black='\[$(tput setaf 0)\]'
red='\[$(tput setaf 1)\]'
green='\[$(tput setaf 2)\]'
yellow='\[$(tput setaf 3)\]'
blue='\[$(tput setaf 4)\]'
magenta='\[$(tput setaf 5)\]'
cyan='\[$(tput setaf 6)\]'
lightgray='\[$(tput setaf 7)\]'
gray='\[$(tput setaf 8)\]'
lightred='\[$(tput setaf 9)\]'
lightgreen='\[$(tput setaf 10)\]'
lightyellow='\[$(tput setaf 11)\]'
lightblue='\[$(tput setaf 12)\]'
lightmagenta='\[$(tput setaf 13)\]'
lightcyan='\[$(tput setaf 14)\]'
white='\[$(tput setaf 15)\]'
reset='\[$(tput sgr0)\]'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="${lightred}\t ${magenta}\u${cyan}@${magenta}\h${reset} "
PS1=$PS1"${yellow} <(arf bark woof!)${reset}\n"
PS1=$PS1"${lightcyan}\W ${lightblue}\$(parse_git_branch)${reset}\n"
PS1=$PS1"    ${green}--> ${reset}"
PS2="${green}      > ${reset}"

PROMPT_COMMAND="export PROMPT_COMMAND=echo"
alias clear="clear; export PROMPT_COMMAND='export PROMPT_COMMAND='echo''"
