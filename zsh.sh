
SHELL_FOLDER=$(dirname "$0")

source $SHELL_FOLDER/tools/antigen.zsh

antigen use oh-my-zsh

antigen bundle command-not-found
antigen use oh-my-zsh
antigen theme robbyrussell

antigen bundle skywind3000/z.lua
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

autoload -Uz compinit
compinit
compdef vman="man"
