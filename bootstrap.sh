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

rm -rf "${SHELL_FOLDER}/bootstrap-gen"
mkdir -p "${SHELL_FOLDER}/bootstrap-gen"

PrivateENV="${SHELL_FOLDER}/bootstrap-gen/private-env.sh"
touch "$PrivateENV"


function InstallTools()
{
	sudo apt install curl
	sudo apt install vim
	sudo apt install lua5.4
	sudo apt install git
	sudo apt install ripgrep
	sudo apt install socat
	sudo apt install git-email
	sudo apt install msmtp
	sudo apt install global
	sudo apt install python3-pip
	pip3 install pygments
	sudo apt install fcitx5 fcitx5-chinese-addons
	sudo apt remove ibus

	sudo apt install cmake
	sudo apt install gnome-tweaks

	sudo apt install chrpath diffstat gawk lz4
	sudo apt install clang-format
	sudo apt install imagemagick

	sudo apt install python3-autopep8
	sudo apt install git-review
	sudo apt install npm
	sudo npm install -g fixjson
	sudo apt install xsel
	sudo apt install universal-ctags
	sudo apt install notify-osd
	sudo apt autoremvoe
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
	cat >> "${PrivateENV}" << EOF

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
	grep "GIT_PROXY_COMMAND" "${PrivateENV}" || echo "export GIT_PROXY_COMMAND=oe-git-proxy" >> "${PrivateENV}"

	grep "github.com" ~/.ssh/config || cat >> ~/.ssh/config <<EOF

Host github.com
	User git
	ProxyCommand nc -x ${ProxyHost}:${ProxyPortHttp} -Xconnect %h %p
EOF
}

function ConfigProxySnap()
{
	sudo snap set system proxy.http="http://${ProxyHost}:${ProxyPortHttp}"
	sudo snap set system proxy.https="http://${ProxyHost}:${ProxyPortHttp}"
}

function ConfigWorkSpace()
{
	grep "_WORKSPACE_" "${PrivateENV}" || echo "export _WORKSPACE_=${WorkSpace}" >> "${PrivateENV}"
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
