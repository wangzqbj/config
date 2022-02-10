
if [ -d "$HOME/.local/etc/config/tools" ];then
	export PATH="$HOME/.local/etc/config/tools:$PATH"
fi

function copy-bmc-image()
{
	dest=$1
	FP5280G2_BMC_IMAGE_PATH="${_WORKSPACE_}/openbmc/build/fp5280g2/tmp/deploy/images/fp5280g2/image-bmc"
	if cp "${FP5280G2_BMC_IMAGE_PATH}" "${dest}"; then
		echo "copy ${FP5280G2_BMC_IMAGE_PATH} to ${dest} successfully"
	else
		echo -e "\033[31mcopy ${FP5280G2_BMC_IMAGE_PATH} to ${dest} failed\033[0m"
		exit 1
	fi
}

alias run-qemu-new-image="copy-bmc-image ./ && obmc-qemu ./image-bmc"

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
