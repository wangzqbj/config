#!/bin/bash

if [ $# != 2 ]; then
	cat << USAGE
Usage: $0 proxy-host proxy-port(http)
   Eg: $0 "127.0.0.1" "10808"
USAGE
	exit 1
fi

proxy_host=$1
proxy_port=$2

cat > ~/.npmrc << EOF
proxy=http://${proxy_host}:${proxy_port}
EOF
