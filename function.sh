
if [ -d "$HOME/.local/etc/config/tools" ];then
	export PATH="$HOME/.local/etc/config/tools:$PATH"
fi

function copy-bmc-image()
{
	local machine
	local dest
	machine=$1
	dest=$2

	IMAGE_PATH="${_WORKSPACE_}/openbmc/build/$machine/tmp/deploy/images/$machine/image-bmc"
	if cp "${IMAGE_PATH}" "${dest}"; then
		echo "copy ${IMAGE_PATH} to ${dest} successfully"
	else
		echo -e "\033[31mcopy ${IMAGE_PATH} to ${dest} failed\033[0m"
		exit 1
	fi
}

function bitbake-shared()
{
	local machine
	machine=$1
	if [ -z $machine ]; then
		echo -e "\033[31mplease specified a machine, eg: fp5280g2\033[0m"
		return
	fi

	local conf_path
	conf_path="$_WORKSPACE_/openbmc/build/$machine/conf/local.conf"
	if [ ! -f $conf_path ]; then
		echo -e "\033[31mcan not find the file: $conf_path\033[0m"
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

function installKitty()
{
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    installer=nightly
}
