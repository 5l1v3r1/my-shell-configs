#!/bin/bash

# Git Prompt
__my_git_prompt_repo_name() {
  # inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  # preserve exit status
  local exit=$?
  local printf_format='%s'
  #local printf_format='[\033[36m%s \033[31m%s\033[0m]'
  if [ `git rev-parse --is-inside-work-tree 2>/dev/null` ]; then
    local repo_name=$(basename `git rev-parse --show-toplevel`)
    # local git_ps1=$(__git_ps1 %s)
    # echo "[%{${fg[cyan]}%}$repo_name %{${fg[red]}%}$git_ps1%{${reset_color}%}]"
    # echo -e -n "[\033[36m$repo_name \033[31m$git_ps1\033[0m]"
    printf -- "$printf_format" $repo_name
  else
    printf ""
  fi
  return $exit
}

GIT_HELPR_PATH=`dirname $(dirname $BASH_SOURCE)`/git_helper

__source_git_helper() {
  if [ -f $GIT_HELPR_PATH/git-completion.bash ]; then
    . $GIT_HELPR_PATH/git-completion.bash
  fi
  if [ -f $GIT_HELPR_PATH/git-prompt.sh ]; then
    . $GIT_HELPR_PATH/git-prompt.sh
  fi
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWUPSTREAM=auto
  GIT_PS1_SHOWUNTRACKEDFILES=1
  # no colored
  # export PS1='\[\033[32m\]\u@\h\[\033[0m\] \[\033[33m\]\W\[\033[0m\] $(__git_ps1 "[\[\033[31m\]%s\[\033[0m\]]")\$ '

  # colored
  #GIT_PS1_SHOWCOLORHINTS=true
  #export PROMPT_COMMAND='__git_ps1 "\[\033[32m\]\u@\h\[\033[0m\] \[\033[33m\]\W\[\033[0m\]" "\\\$ "'
}

# show git status
__source_git_helper
if ! command -v __git_ps1 1>/dev/null 2>&1; then
  curl -L -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > $GIT_HELPR_PATH/git-prompt.sh
  curl -L -sS https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > $GIT_HELPR_PATH/git-completion.bash
  echo -e "Git Completion Scripts Downloaded!"
  echo -e "See $GIT_HELPR_PATH"
  __source_git_helper
fi
# export PS1='\[\033[32m\]\u@\h\[\033[0m\] \[\033[33m\]\W\[\033[0m\] $(__my_git_prompt)\$ '
export PS1='\[\033[32m\]\u@\h\[\033[0m\] \[\033[33m\]\W\[\033[0m\] $(__git_ps1 "[\[\033[36m\]$(__my_git_prompt_repo_name) \[\033[31m\]%s\[\033[0m\]]")\$ '
# export PS1='\[\033[32m\]\u \[\033[33m\]\w\[\033[0m\] $(__my_git_prompt)\$ '

# Raspberry Pi Default
# export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] "
# Raspberry Pi Like PS1
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;34m\]$(__git_ps1 "[\[\033[36m\]$(__my_git_prompt_repo_name) \[\033[31m\]%s\[\033[01;34m\]]")\$\[\033[00m\] '

# Aliases
case "${OSTYPE}" in
darwin*)
  alias ls="ls -G"
  alias ll="ls -lhG"
  alias la="ls -lhaG"
  # alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
  ;;
linux*)
  alias ls='ls --color'
  alias ll='ls -lh --color'
  alias la='ls -lha --color'
  ;;
esac

# For loading applications
if [ -f $HOME/.ngrok/ngrok ]; then
  alias ngrok="$HOME/.ngrok/ngrok"
fi

# gi command
# Usage:
# cd MYAPP && gi node rails
# API See https://www.gitignore.io/docs#-install-command-line-git
__gi() {
  params=`echo $@ | tr ' ' ','`
  FILE_PATH=$PWD"/.gitignore"
  if [ -f $FILE_PATH ]; then
    if [ $params = "" ]; then
      echo "Params needed"
      return 1
    fi
    echo -e "\n\n###### Updated At `date +%Y-%m-%d` ######" >> $FILE_PATH
    curl -L -s "https://www.gitignore.io/api/"$params >> $FILE_PATH
    echo $PWD"/.gitignore updated"
  else
    # add most used os
    params="windows,macos,linux,"$params
    curl -L -s "https://www.gitignore.io/api/"$params > $FILE_PATH
    echo ".gitignore File Created At:"
    echo $PWD"/.gitignore"
  fi
}
alias gi=__gi

# envs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  #eval "$(pyenv virtualenv-init -)"
fi

export PATH="$HOME/.rbenv/bin:$PATH"
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi


export PATH="$HOME/.nodenv/bin:$PATH"
if command -v nodenv 1>/dev/null 2>&1; then
  eval "$(nodenv init -)"
fi

export GOENV_ROOT="$HOME/.goenv"
if command -v goenv 1>/dev/null 2>&1; then
  eval "$(goenv init -)"
fi
export GOPATH="$HOME/.go"
if [[ ! -d $GOPATH ]]; then
  mkdir $GOPATH
fi
if [[ ! -d "$GOPATH/bin" ]]; then
  mkdir "$GOPATH/bin"
fi
export PATH="$GOENV_ROOT/bin:$GOPATH/bin:$PATH"
