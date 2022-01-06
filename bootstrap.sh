#!/bin/bash
set -ex

if [ $# != 1 ]; then
	cat << USAGE
Usage: $0 proxy
   Eg: $0 http://127.0.0.1:1088
USAGE
	exit 1
fi

SHELL_FOLDER=$(dirname "$0")

PROXY_SH="${SHELL_FOLDER}/proxy.sh"
PROXY_SERVER="$1"

cat > "${PROXY_SH}" << EOF
export http_proxy="${PROXY_SERVER}"
export https_proxy="${PROXY_SERVER}"
export ftp_proxy="${PROXY_SERVER}"
export all_proxy="${PROXY_SERVER}"
export ALL_PROXY="${PROXY_SERVER}"
export no_proxy="127.0.0.1"
export NO_PROXY=\$no_proxy
EOF

if [ -f ~/.wgetrc ]; then
	echo "机器自带有wgetrc, 未设置"
else
	cat > ~/.wgetrc << EOF_WGETRC
https_proxy = ${PROXY_SERVER}
http_proxy = ${PROXY_SERVER}
ftp_proxy = ${PROXY_SERVER}
no_proxy = "127.0.0.1"
use_proxy = on
EOF_WGETRC
fi

mkdir -p ~/.local/bin

if [ ! -f ~/.local/bin/oe-git-proxy ]; then
	which socat  ||  sudo apt install socat
	wget http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy
	mv oe-git-proxy ~/.local/bin/oe-git-proxy
	chmod +x ~/.local/bin/oe-git-proxy
fi

LOCAL_SH="${SHELL_FOLDER}/local.sh"
if [ x"${USER}" = x"wangzq" ]; then
	cat > "${LOCAL_SH}" << EOF_LOCAL
export _WORKSPACE_="${HOME}/workspace"
EOF_LOCAL
elif [ x"${USER}" = x"openbmc" ]; then
	cat > "${LOCAL_SH}" << EOF_LOCAL
export _WORKSPACE_=/build/obmc/gerrit-tracker
EOF_LOCAL
fi

SHELL_RC=~/.bashrc

if [ -f ~/.zshrc ]; then
	SHELL_RC=~/.zshrc
fi

SOURCE_CMD="source ~/.local/etc/config/init.sh"

grep "${SOURCE_CMD}" ${SHELL_RC} || { echo ""; echo "${SOURCE_CMD}"; } >> "${SHELL_RC}"
