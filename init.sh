
if [ -z "$_INIT_SH_LOADED" ]; then
	_INIT_SH_LOADED=1
else
	return
fi

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
	. "${HOME}/.cargo/env"
fi

if [ -f "$HOME/.local/etc/config/bootstrap-gen/config.sh" ]; then
	. "${HOME}/.local/etc/config/bootstrap-gen/config.sh"
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
