#!/bin/bash

. ../config.sh

if [ -z "${GIT_USER_NAME}" ] || [ -z "${GIT_USER_EMAIL}" ] ; then
	echo "You must fill the config.sh for git"
	exit 1
fi

if [ -z "${ProxyHost}" ] || [ -z "${ProxyPortSocks5}" ] || [ -z "${GMAIL_APP_PW}" ] ; then
	echo "You must fill the config.sh for proxy (socks5 for msmtp)"
	exit 1
fi

./gitconfig.sh "${GIT_USER_NAME}" "${GIT_USER_EMAIL}"
./msmtprc.sh "${ProxyHost}" "${ProxyPortSocks5}" "${GMAIL_APP_PW}"

# https://github.com/tmux/tmux/blob/2.1/FAQ#L355-L383
cat <<EOF|tic -x -
tmux|tmux terminal multiplexer,
    ritm=\E[23m, rmso=\E[27m, sitm=\E[3m, smso=\E[7m, Ms@,
    use=xterm+tmux, use=screen,

tmux-256color|tmux with 256 colors,
    use=xterm+256setaf, use=tmux,
EOF

cp ./tmux.conf ~/.tmux.conf
