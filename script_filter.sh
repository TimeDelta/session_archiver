#!/bin/bash
source ./util/global.sh

# for debugging
[[ $1 == "--debug" ]] && { debugging=' '; shift; } || debugging=''
debug_item() {
	# $1 = title
	# $2 = value
	if [[ -n $debugging ]]; then
		cat <<EOB
		<item arg="debug '$1' '$2'" valid="NO" autocomplete="$2">
			<title>debug: $1</title>
			<subtitle>$2</subtitle>
			<copy>$2</copy>
		</item>
EOB
	fi
}

echo "<?xml version=\"1.0\"?>"
echo "<items>"

IFS=$'\n'
if [[ $# -le 1 ]]; then
	command="$1"
	for item in `find "$COMMANDS_DIR" -iname "$command*.sh"`; do
		arg="`"$item" --arg`"
		valid="`"$item" --valid`"
		complete="`"$item" --complete`"

		echo "	<item uid=\"$WORKFLOW_ID.`basename "$item"`\" arg=\"$arg\" valid=\"$valid\" autocomplete=\"$complete\">"
		echo "		<title>`"$item" --title`</title>"
		echo "		<subtitle mod=\"$DESCRIPTION_MODIFIER\">`"$item" --description`</subtitle>"
		echo "		<subtitle mod=\"$USAGE_MODIFIER\">`"$item" --usage`</subtitle>"
		echo "	</item>"
	done
fi

command="$1"
shift

quoted_args="`quote_args "$@"`"

# @TODO make the create command invalid if the current name argument is the same as an existing session
if [[ -e "$COMMANDS_DIR/$command.sh" ]]; then
	"$COMMANDS_DIR/$command.sh" --extra-alfred-items "$@"
	if [[ `"$COMMANDS_DIR/$command.sh" --should-list-sessions` -eq 1 ]]; then
		query="$@"
		debug_item query "$query"
		for session in `get_all_sessions | egrep "$query.*"`; do
			echo "	<item uid=\"`get_session_uuid "$session"`\""\
				"arg=\"$command $session `echo "$@" | sed "s/^$session//"`\""\
				"valid=\"YES\""\
				"autocomplete=\"$command $session `echo "$@" | sed "s/^$session//"`\">"
			echo "		<title>$session</title>"
			echo "		<subtitle>`get_session_description "$session"`</subtitle>"
			for mod in fn ctrl cmd alt shift; do
				echo "		<subtitle mod=\"$mod\">`"$COMMANDS_DIR/$command.sh" -m $mod --session-alt-subtitle "$session"`</subtitle>"
			done
			echo "	</item>"
		done
	fi
fi

echo "</items>"
