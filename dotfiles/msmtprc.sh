#!/bin/bash

if [ $# != 3 ]; then
	cat << USAGE
Usage: $0 proxy-host proxy-port(socks5) gmail-pw
   Eg: $0 "127.0.0.1" "10808" "xxxxxxxxxxx"
USAGE
	exit 1
fi

proxy_host=$1
proxy_port=$2
password=$3

cat > ~/.msmtprc << EOF
defaults
logfile ~/.msmtp.log
account   gmail
auth            on
tls             on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
host      smtp.gmail.com
port      587 
proxy_host ${proxy_host}
proxy_port ${proxy_port}
user      wangzq.jn
from      wangzq.jn@gmail.com
password  ${password}
account default: gmail
EOF

chmod 600 ~/.msmtprc
