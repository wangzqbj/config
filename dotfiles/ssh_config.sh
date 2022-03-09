#!/bin/bash

grep "local-qemu" ~/.ssh/config || cat >> ~/.ssh/config <<EOF

Host local-qemu
	Hostname localhost
	Port 2222
	User root
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
EOF
