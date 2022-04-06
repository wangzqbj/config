export EDITOR=vim
export VISUAL=vim

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/go" ]; then
	export GOPATH="$HOME/.local/go"
	if [ -d "$HOME/.local/go/bin" ]; then
		export PATH="$HOME/.local/go/bin:$PATH"
	fi
fi

export UBUNTU_MIRROR=http://mirrors.aliyun.com/ubuntu/

export PATH="$PATH:$HOME/.vim/plugged/vim-superman/bin"

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ $TERM = "xterm-kitty" ]; then
	alias ls='ls --color=tty --hyperlink=auto'
	alias icat="kitty +kitten icat"
fi
