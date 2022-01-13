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

# 遇到斜体/色彩支持问题，参考: https://github.com/tmux/tmux/blob/2.1/FAQ#L355-L383

cp ./tmux.conf ~/.tmux.conf
