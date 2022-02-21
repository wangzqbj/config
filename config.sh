
export EDITOR=vim

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
	. "${HOME}/.cargo/env"
fi

export UBUNTU_MIRROR=http://mirrors.aliyun.com/ubuntu/

export PATH="$PATH:$HOME/.vim/plugged/vim-superman/bin"

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
