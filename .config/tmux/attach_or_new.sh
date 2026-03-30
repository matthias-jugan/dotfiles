if [[ -z "$TMUX" ]] ;then
	ID="$( /opt/homebrew/bin/tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
	if [[ -z "$ID" ]] ;then # if not available create a new one
		/opt/homebrew/bin/tmux new-session
	else
		/opt/homebrew/bin/tmux attach-session -t "$ID" # if available attach to it
	fi
fi 
