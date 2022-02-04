
if [ -z "$_INIT_SH_LOADED" ]; then
	_INIT_SH_LOADED=1
else
	return
fi

if [ -f "$HOME/.local/etc/config/bootstrap-gen/private-env.sh" ]; then
	. "${HOME}/.local/etc/config/bootstrap-gen/private-env.sh"
fi

if [ -f "$HOME/.local/etc/config/config.sh.sh" ]; then
	. "${HOME}/.local/etc/config/config.sh"
fi

if [ -n "$PATH" ]; then
	old_PATH=$PATH:; PATH=
	while [ -n "$old_PATH" ]; do
		x=${old_PATH%%:*}
		case $PATH: in
			*:"$x":*) ;;
			*) PATH=$PATH:$x;;
		esac
		old_PATH=${old_PATH#*:}
	done
	PATH=${PATH#:}
	unset old_PATH x
fi

if [ -f "$HOME/.local/etc/config/function.sh" ]; then
	. "${HOME}/.local/etc/config/function.sh"
fi

if [ -n "$ZSH_VERSION" ]; then
	if [ -f "$HOME/.local/etc/config/zsh.sh" ]; then
		. "${HOME}/.local/etc/config/zsh.sh"
	fi
fi
