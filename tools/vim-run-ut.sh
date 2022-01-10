#!/bin/bash

function run-ut()
{
	REPO="$VIM_ROOT"
	UT_PATH="${_WORKSPACE_}/openbmc-build-scripts"
	UNIT_TEST_PKG="$(basename $REPO)" WORKSPACE="$(dirname $REPO)" \
		NO_FORMAT_CODE=1 TEST_ONLY=1  "$UT_PATH/run-unit-test-docker.sh"

}

run-ut
