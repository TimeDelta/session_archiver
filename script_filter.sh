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

command="$1"
shift

quoted_args="`quote_args "$@"`"

echo "<?xml version=\"1.0\"?>"
echo "<items>"

IFS=$'\n'
# TODO make the create command invalid if the current name argument is the same as an existing session
for item in `find $COMMANDS_DIR -iname "$command*.alfred_item"`; do
	max_args=$(`echo "$item" | sed 's/alfred_item$/sh/'` --max-args)
	if [[ $# -le $(($max_args + 1)) || $max_args -eq -1 ]]; then
		command_name="`basename "$item" | sed 's/.alfred_item$//'`"
		debug_item "$command_name.sh --max-args" "$max_args"
		cat "$item" | sed "s/alfred_command_name/$command_name/g" | sed -E "s/(arg=\"[^ ]*)\"/\1 $quoted_args\"/"
	fi
done

if [[ -e "$COMMANDS_DIR/$command.sh" ]]; then
	"$COMMANDS_DIR/$command.sh" --extra-alfred-items
	if [[ `"$COMMANDS_DIR/$command.sh" --should-list-sessions` -eq 1 ]]; then
		query="$@"
		debug_item query "$query"
		for session in `get_all_sessions | egrep "$query.*"`; do
			echo "<item uid=\"`get_session_uuid "$session"`\" arg=\"$session\" valid=\"YES\" autocomplete=\"$session\">"
			echo "	<title>$session</title>"
			echo "	<subtitle>`get_session_description "$session"`</subtitle>"
			for mod in fn ctrl cmd alt shift; do
				echo "	<subtitle mod=\"$mod\">`"$COMMANDS_DIR/$command.sh" -m $mod --session-alt-subtitle "$session"`</subtitle>"
			done
			echo "</item>"
		done
	fi
fi

echo "</items>"
