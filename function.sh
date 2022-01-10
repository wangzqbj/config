
if [ -d "$HOME/.local/etc/config/tools" ];then
	export PATH="$HOME/.local/etc/config/tools:$PATH"
fi

INSPUR_TOOLS="${_WORKSPACE_}/tools"

alias inspur-gerrit='${INSPUR_TOOLS}/inspur-gerrit'
alias run-qemu='${INSPUR_TOOLS}/run-qemu.sh'

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

alias run-qemu-new-image="copy-bmc-image ./ && run-qemu ./image-bmc"

alias commit-tracker='${INSPUR_TOOLS}/infrastructure/commit-tracker.sh'
alias build-ut-docker='${INSPUR_TOOLS}/infrastructure/build-phosphor-dbus-interfaces-docker'

function gerrit-hook()
{
	scp inspur.gerrit:hooks/commit-msg \
		$(git rev-parse --show-toplevel)/.git/hooks/
}

function run-ut()
{
	REPO="$(git rev-parse --show-toplevel)"
	UT_PATH="${_WORKSPACE_}/openbmc-build-scripts"
	UNIT_TEST_PKG="$(basename $REPO)" WORKSPACE="$(dirname $REPO)" \
		"$UT_PATH/run-unit-test-docker.sh"
}

function run-robot-ci()
{
	TEST_REPO="${_WORKSPACE_}/openbmc-test-automation"
	cd ${TEST_REPO}
	robot -v OPENBMC_HOST:127.0.0.1  -v OPENBMC_PASSWORD:0penBmc -v SSH_PORT:2222 -v HTTPS_PORT:2443 \
		-v IPMI_PORT:2623 --argumentfile test_lists/QEMU_CI ./tests ./redfish ./ipmi

}
