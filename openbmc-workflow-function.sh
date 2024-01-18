
source "$HOME/.local/etc/config/function.sh"

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
