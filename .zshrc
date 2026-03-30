source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

if [[ -z "$TMUX" && -n "$STARTUP_TMUX" ]] ;then
	ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
	if [[ -z "$ID" ]] ;then # if not available create a new one
		tmux new-session
	else
		tmux attach-session -t "$ID" # if available attach to it
	fi
fi 

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/Users/mju/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install


eval "$(starship init zsh)"
# autoload -Uz promptinit
# promptinit
# prompt adam1
