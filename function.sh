
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
