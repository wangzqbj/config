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
[alias]
	log1 = log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) %G? - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'
[sendemail]
	smtpserver = /usr/bin/msmtp
	suppresscc = self
EOF
