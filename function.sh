
if [ -d "$HOME/.local/etc/config/tools" ];then
	export PATH="$HOME/.local/etc/config/tools:$PATH"
fi

function log_ok()
{
        echo -e "\033[1;5;30;42m$@\033[0m"
}


function log_warn()
{
        echo -e "\033[1;5;30;43m$@\033[0m"
}

function log_error()
{
        echo -e "\033[1;5;30;41m$@\033[0m"
}

function log_fatal()
{
	log_error $@
	exit 1
}

# copied from https://github.com/skywind3000/vim/blob/master/etc/function.sh#L393
function q-ansicolors
{
        esc="\033["
        echo -e "\t  40\t   41\t   42\t    43\t      44       45\t46\t 47"
        for fore in 30 31 32 33 34 35 36 37; do
                line1="$fore  "
                line2="    "
                for back in 40 41 42 43 44 45 46 47; do
                        line1="${line1}${esc}${back};${fore}m Normal  ${esc}0m"
                        line2="${line2}${esc}${back};${fore};1m Bold    ${esc}0m"
                done
                echo -e "$line1\n$line2"
        done

        echo ""
        echo "# Example:"
        echo "#"                                                                                                                                      echo "# Type a Blinkin TJEENARE in Swedens colours (Yellow on Blue)"
        echo "#"
        echo "#           ESC"
        echo "#            |  CD"
        echo "#            |  | CD2"
        echo "#            |  | | FG"
        echo "#            |  | | |  BG + m"
        echo "#            |  | | |  |         END-CD"
        echo "#            |  | | |  |            |"
        echo "# echo -e '\033[1;5;33;44mTJEENARE\033[0m'"
        echo "#"
        echo "# Sedika Signing off for now ;->"
}

function tpeek()
{
	if [ -z $TMUX ]; then
		echo "not in tmux"
		return;
	fi
	tmux split-window -p 33 "$EDITOR" "$@" || return;
}

function copy-bmc-image()
{
	local machine
	local dest
	machine=$1
	dest=$2

	IMAGE_PATH="${_WORKSPACE_}/openbmc/build/$machine/tmp/deploy/images/$machine/image-bmc"
	if cp "${IMAGE_PATH}" "${dest}"; then
		log_ok "copy ${IMAGE_PATH} to ${dest} successfully"
	else
		log_error "copy ${IMAGE_PATH} to ${dest} failed"
		return
	fi
}

function bitbake-shared()
{
	local machine
	machine=$1
	if [ -z $machine ]; then
		log_error "please specified a machine, eg: fp5280g2"
		return
	fi

	local conf_path
	repo_path=$(git rev-parse --show-toplevel)
	conf_path="$repo_path/build/$machine/conf/local.conf"
	if [ ! -f $conf_path ]; then
		log_error "can not find the file: $conf_path"
		return
	fi
	local dl_dir
	dl_dir="DL_DIR=\"$_WORKSPACE_/bitbake_downloads\""
	local sstate
	sstate="SSTATE_DIR=\"$_WORKSPACE_/bitbake_sharedstatecache\""

	grep "$dl_dir" $conf_path || { echo ""; echo "$dl_dir"; echo "$sstate" } >> "$conf_path"

}

function weather()
{
	local city="${1:-jinan}"
	if [ -x "$(which wget)" ]; then
		wget -qO- "wttr.in/~${city}"
	elif [ -x "$(which curl)" ]; then
		curl "wttr.in/~${city}"
	fi

}

function my-public-ip()
{
	if command -v curl &> /dev/null; then
		curl ifconfig.co
	elif command -v wget &> /dev/null; then
		wget -qO- ifconfig.co
	fi
}

function install-kitty()
{
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    installer=nightly
}


function update-inspur-tools()
{
	pushd "$HOME/.inspur-obmc-misc"
	if [ -d tools ]; then
		pushd tools
		git pull origin master || { popd; rm -rf tools; git clone ssh://inspur.gerrit/openbmc/tools; }
		popd
	else
		git clone ssh://inspur.gerrit/openbmc/tools
	fi
	popd

	"$HOME/.inspur-obmc-misc/tools/bootstrap.sh"

}

function obmc-qemu-login()
{
	sshpass -p '0penBmc' ssh local-qemu
}

function obmc-qemu-scp()
{
	local src="$1"
	local dest="$2"
	if [ -z $dest ]; then
		dest="/tmp"
	fi

	if sshpass -p '0penBmc' scp -r $src local-qemu:$dest; then
		log_ok "Copy $src to local-qemu:$dest successfully"
	else
		log_error "Copy $src to local-qemu:$dest failed"
	fi
}

function obmc-coredump-unzip()
{
	local d=${1%%.*}
	tar xvf $1
	zstd -d $d/core*.zst
}

function obmc-copy-ci-logs()
{
	scp -r openbmc-ci:/home/openbmc/openbmc-ci/qemu-robot-ci/openbmc-build-scripts/report.html ./
	scp -r openbmc-ci:/home/openbmc/openbmc-ci/qemu-robot-ci/openbmc-build-scripts/log.html ./
	scp -r openbmc-ci:/home/openbmc/openbmc-ci/qemu-robot-ci/openbmc-build-scripts/output.xml ./
	scp -r openbmc-ci:/home/openbmc/openbmc-ci/qemu-robot-ci/openbmc-build-scripts/logs ./
}

function alarm_clock()
{
	echo "notify-send --icon=gtk-info Info '$1'" | at "$2"
}

