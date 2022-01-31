#!/bin/bash
set -ex

SHELL_FOLDER=$(dirname "$0")
. ${SHELL_FOLDER}/myenv.sh

if [ -z $ProxyHost ] || [ -z $ProxyPortSocks5 ] || [ -z $ProxyPortHttp ]; then
	echo "You must fill the config.sh for proxy"
	exit 1
fi

if [ -z $WorkSpace ]; then
	echo "You must fill the config.sh for workspace"
	exit 1
fi

mkdir -p "${SHELL_FOLDER}/bootstrap-gen"

cp config.sh "${SHELL_FOLDER}/bootstrap-gen/config.sh"

ConfigSH="${SHELL_FOLDER}/bootstrap-gen/config.sh"

function InstallTools()
{
	sudo apt install socat
	sudo apt install git-email
	sudo apt install msmtp
	sudo apt install global
}

function ConfigProxyWget()
{
	local HttpProxy="http://${ProxyHost}:${ProxyPortHttp}"
	cat > ~/.wgetrc << EOF_WGETRC
https_proxy = ${HttpProxy}
http_proxy = ${HttpProxy}
ftp_proxy = ${HttpProxy}
no_proxy = "127.0.0.1"
use_proxy = on
EOF_WGETRC
	cat >> "${ConfigSH}" << EOF

export http_proxy="${HttpProxy}"
export https_proxy="${HttpProxy}"
export ftp_proxy="${HttpProxy}"
export all_proxy="${HttpProxy}"
export ALL_PROXY="${HttpProxy}"
export no_proxy="127.0.0.1"
export NO_PROXY=\$no_proxy
EOF

}

function ConfigProxyGit()
{
	wget http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy
	mkdir -p ~/.local/bin
	mv oe-git-proxy ~/.local/bin/oe-git-proxy
	chmod +x ~/.local/bin/oe-git-proxy
	grep "GIT_PROXY_COMMAND" "${ConfigSH}" || echo "export GIT_PROXY_COMMAND=oe-git-proxy" >> "${ConfigSH}"

	grep "github.com" ~/.ssh/config || cat >> ~/.ssh/config <<EOF

Host github.com
	User git
	ProxyCommand nc -x ${ProxyHost}:${ProxyPortHttp} -Xconnect %h %p
EOF
}

function ConfigWorkSpace()
{
	grep "_WORKSPACE_" "${ConfigSH}" || echo "export _WORKSPACE_=${WorkSpace}" >> "${ConfigSH}"
}

function AddInitToShellRc()
{
	local SHELL_RC=~/.bashrc
	if [ -f ~/.zshrc ]; then
		SHELL_RC=~/.zshrc
	fi

	SOURCE_CMD="source ~/.local/etc/config/init.sh"
	grep "${SOURCE_CMD}" ${SHELL_RC} || { echo ""; echo "${SOURCE_CMD}"; } >> "${SHELL_RC}"
}

function InstallDotFiles()
{
	pushd ${SHELL_FOLDER}/dotfiles
	./init.sh
	popd
}

function InstallXdgConfig()
{
	cp -r ${SHELL_FOLDER}/xdg-config/* ~/.config
}

InstallTools
ConfigProxyWget
ConfigProxyGit
ConfigWorkSpace
AddInitToShellRc
InstallDotFiles
InstallXdgConfig
