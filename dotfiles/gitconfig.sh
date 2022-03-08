#!/bin/bash

if [ $# != 2 ]; then
	cat << USAGE
Usage: $0 GIT_USER_NAME GIT_USER_EMAIL
   Eg: $0 "John Wang" "wangzq.jn@gmail.com"
USAGE
	exit 1
fi

GIT_USER_NAME="$1"
GIT_USER_EMAIL="$2"

cat > ~/.gitconfig << EOF
[user]
	email = ${GIT_USER_EMAIL}
	name = ${GIT_USER_NAME}
[core]
	editor = vim
[rebase]
	autosquash = true
[sendemail]
	smtpserver = /usr/bin/msmtp
	suppresscc = self
[oh-my-zsh]
	hide-status = 1
	hide-dirty = 1
EOF
