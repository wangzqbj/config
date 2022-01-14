#!/bin/bash

TEST_ARG=$1

function run-ut-test-only()
{
	REPO="$VIM_ROOT"
	UT_PATH="${_WORKSPACE_}/openbmc-build-scripts"
	UNIT_TEST_PKG="$(basename "$REPO")" WORKSPACE="$(dirname "$REPO")" \
		NO_FORMAT_CODE=1 TEST_ONLY=1  "$UT_PATH/run-unit-test-docker.sh"

}

function run-ut()
{
	REPO="$VIM_ROOT"
	UT_PATH="${_WORKSPACE_}/openbmc-build-scripts"
	UNIT_TEST_PKG="$(basename "$REPO")" WORKSPACE="$(dirname "$REPO")" \
		"$UT_PATH/run-unit-test-docker.sh"

}


function main()
{
	if [ x"$TEST_ARG" = x"test-only" ];then
		run-ut-test-only
	else
		run-ut
	fi
}

# Remove the ansi color https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream
main | sed 's/\x1b\[[0-9;]*[mGKF]//g' 
