#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -e $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

PS1="[\u@\h \W]$ "
export PS1="\[\e[1;32m\]\[\e[1;35m\]\u\[\e[0;36m\]@\[\e[1;35m\]\h \[\e[1;36m\]\W$(__git_ps1 " (%s)")\[\e[0;32m\] > \[\e[m\]"
