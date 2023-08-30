#!/bin/bash

if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -xC -yC -w80% -h75% -E "tmux-popup-obmc.sh createSession"
fi
