#!/bin/bash

TEST_ARG=$1
INSPUR_TOOLS="$INSPUR_OBMC_MISC/tools"

function main()
{
	if [ x"$TEST_ARG" = x"test-only" ];then
		"$INSPUR_TOOLS"/inspur-ut-test.sh test-only
	else
		"$INSPUR_TOOLS"/inspur-ut-test.sh
	fi
}

# Remove the ansi color https://superuser.com/questions/380772/removing-ansi-color-codes-from-text-stream
# Remove the date output
# Remove bash +x output
main 2>/dev/null | sed 's/\x1b\[[0-9;]*[mGKF]//g' | sed '/年/d'
