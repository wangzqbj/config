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

export PATH="$PATH:$HOME/.vim/plugged/vim-superman/bin"

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{node_modules/*,.git/*}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ $TERM = "xterm-kitty" ]; then
	alias ls='ls --color=tty --hyperlink=auto'
	alias icat="kitty +kitten icat"
	alias ssh="kitty +kitten ssh"
fi

if [ x$OPENBMC_SDK = x"Enabled" ]; then
	source /usr/local/oecore-x86_64/environment-setup-armv7ahf-vfpv4d16-openbmc-linux-gnueabi
fi

#z.lua
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"
export _ZL_HYPHEN=1
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -i'      # cd with interactive selection
alias zf='z -I'      # use fzf to select in multiple matches
alias zb='z -b'      # quickly cd to the parent directory
export ZLUA_SCRIPT="$HOME/.antigen/bundles/skywind3000/z.lua/z.lua"
