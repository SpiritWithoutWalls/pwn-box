export EDITOR=vim
export PS1='🐳  \[\033[1;36m\]\h \[\033[1;34m\]\W\[\033[0;35m\] \[\033[1;36m\]# \[\033[0m\]'
LS_COLORS='di=01;34:ln=01;36:ex=01;32:pi=40;33:so=01;35:bd=40;33:cd=40;33:or=40;31'
export LS_COLORS

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias myip="curl ipinfo.io"

# PWN
alias gdb='gdb -q'
alias objdump='objdump -M intel'
alias strace="strace -ixv"
alias ltrace="ltrace -iC"
