# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#プロンプトの設定
#export PS1="\[\033[33m\]\W\[\033[31m\]\$\[\033[0m\] "
source /usr/local/git/contrib/completion/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[01;33m\]✘ \[\033[01;32m\]\W\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\]✘\[\033[00m\] '
#export PS1='\[\033[01;33m\]\[\033[01;32m\]\W\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\]||\[\033[00m\] '

#if [ -f $BASH_COMPLETION_DIR/git ]; then
#  export PS1='\[\033[01;33m\]\W\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\]\$\[\033[00m\] '
#  export PS1='\[\033[01;33m\]✘\[\033[01;32m\]\W\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\]✘\[\033[00m\] '
#else
#  export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w \n\[\033[01;34m\]\$\[\033[00m\] '
#fi

#デフォルトで使用するエディタの設定
export EDITOR=vim

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# cdしたらlsします
cd ()
{
    builtin cd "$@" && ls
}

#cdls ()
#{
#    \cd "$@" && ls
#}
#alias cd="cdls"

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

# if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias diff='colordiff -u'

alias g='git'
alias gg='git grep'
alias gs='git status'
alias gf='git diff'
alias gc='git checkout'
alias glp='git log -p'
alias gfc='git diff --cached'
alias gfn='git diff --name-only'
alias glpl='git --no-pager log -20 --reverse "--pretty=format:* [%H/$(basename $(pwd))]%n * %s%n%n"'
alias gb='git blame'

alias zs='bundle exec zeus start'
alias be='bundle exec'
alias bi='bundle install'
alias ze='bundle exec zeus'
alias rs='bundle exec zeus s'
alias rc='bundle exec zeus c'
alias bers='bundle exec rails server'
alias berc='bundle exec rails c'
alias us='bundle exec unicorn_rails -c config/unicorn.rb'
alias spc='bundle exec zeus rspec -c'
alias bespc='bundle exec rspec -c'
alias spcfs='bundle exec rspec -cfs'
alias nyanspc='bundle exec zeus rspec -c --format NyanCatFormatter'
alias rg='bundle exec rails g'
#alias glpl="git log --pretty=oneline | head -20 | tac | sed -e 's|\([a-z0-9]*\) \(.*\)|* [\1/${PWD##*/}]\n * \2\n|'"

function spcd() {
ruby -e 'puts `bundle exec zeus rspec -c #{`git diff #{ARGV[0]} --name-only`.split(%(\n)).select{|f| f =~ /^spec/}.delete_if{|f| f=~/^spec\/factories/}.join(%( ))}`' $1
}

function spcr() {
  git diff `git log --oneline --grep="Merge" | head -n1 | cut -c 1-9` --name-only | grep _spec.rb | xargs bundle exec rspec
}

function rubor() {
  git diff `git log --oneline --grep="Merge" | head -n1 | cut -c 1-9` --name-only | grep -v schema.rb | grep -v routes | xargs bundle exec rubocop
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/usr/local/Trolltech/Qt-4.7.4/bin

[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

PAGER=less
export PATH=/usr/local/Trolltech/Qt-4.7.4/bin:$PATH
export NOKOGIRI_USE_SYSTEM_LIBRARIES=1

export NVM_DIR="/home/yuma/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### node
export PATH=$PATH:./node_modules/.bin

### go
export GOPATH=~/.go

