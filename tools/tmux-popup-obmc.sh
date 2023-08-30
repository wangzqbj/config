#!/bin/bash

setupMachineCmd=$(cat << EOF
    cd ${_WORKSPACE_}/openbmc
    source setup fp5280g3
EOF
)

setupSdkEnvCmd=$(cat << EOF
    source /usr/local/oecore-x86_64/environment-setup-armv7ahf-vfpv4d16-openbmc-linux-gnueabi
EOF
)

function createSession()
{
    tmux attach -t popup || tmux new-session -d -s popup \; \
	new-window -n 'openbmc_build' \; new-window -n 'sdk' \; attach \; \
	send-keys -t popup:openbmc_build "$setupMachineCmd" ENTER \; \
	send-keys -t popup:sdk "$setupSdkEnvCmd" ENTER 
}

function buildOBMCImage()
{

buildOBMCImageCmd=$(cat << EOF
    bitbake obmc-phosphor-image
EOF
)
    tmux send-keys -t popup:openbmc_build "$buildOBMCImageCmd" ENTER
}

function buildOBMCRepo()
{
    repodir="$1"
buildOBMCRepoCmd=$(cat << EOF
    cd $repodir
    [[ -d "build" ]] || meson setup build
    ninja -C build
EOF
)
    echo "buildOBMCRepo" >> /tmp/aaa
    echo "$1" >> /tmp/aaa
    tmux send-keys -t popup:sdk "$buildOBMCRepoCmd" ENTER 
}

echo "hello" >> /tmp/aaa
echo $1 >>/tmp/aaa
echo $2 >>/tmp/aaa
$1 $2
