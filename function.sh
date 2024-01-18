
if [ -d "$HOME/.local/etc/config/tools" ];then
	export PATH="$HOME/.local/etc/config/tools:$PATH"
fi

function log_ok()
{
        echo -e "\033[1;5;30;42m$@\033[0m"
}


function log_warn()
{
        echo -e "\033[1;5;30;43m$@\033[0m"
}

function log_error()
{
        echo -e "\033[1;5;30;41m$@\033[0m"
}

function log_fatal()
{
	log_error $@
	exit 1
}

# copied from https://github.com/skywind3000/vim/blob/master/etc/function.sh#L393
function q-ansicolors
{
        esc="\033["
        echo -e "\t  40\t   41\t   42\t    43\t      44       45\t46\t 47"
        for fore in 30 31 32 33 34 35 36 37; do
                line1="$fore  "
                line2="    "
                for back in 40 41 42 43 44 45 46 47; do
                        line1="${line1}${esc}${back};${fore}m Normal  ${esc}0m"
                        line2="${line2}${esc}${back};${fore};1m Bold    ${esc}0m"
                done
                echo -e "$line1\n$line2"
        done

        echo ""
        echo "# Example:"
        echo "#"                                                                                                                                      echo "# Type a Blinkin TJEENARE in Swedens colours (Yellow on Blue)"
        echo "#"
        echo "#           ESC"
        echo "#            |  CD"
        echo "#            |  | CD2"
        echo "#            |  | | FG"
        echo "#            |  | | |  BG + m"
        echo "#            |  | | |  |         END-CD"
        echo "#            |  | | |  |            |"
        echo "# echo -e '\033[1;5;33;44mTJEENARE\033[0m'"
        echo "#"
        echo "# Sedika Signing off for now ;->"
}

function tpeek()
{
	if [ -z $TMUX ]; then
		echo "not in tmux"
		return;
	fi
	tmux split-window -p 33 "$EDITOR" "$@" || return;
}

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

function install-kitty()
{
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    installer=nightly
}


function alarm_clock()
{
	echo "notify-send --icon=gtk-info Info '$1'" | at "$2"
}

