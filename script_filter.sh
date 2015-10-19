#!/bin/bash
source ./util/global.sh

# for debugging
if [[ $1 == "--debug" ]]; then
	export DEBUG="ON"
	shift
else
	export DEBUG=''
fi
debug_item() {
	# $1 = title
	# $2 = value
	if [[ -n $DEBUG ]]; then
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

		echo "	<item uid=\"$WORKFLOW_ID.`basename "$item" | sed 's/\.sh$//'`\""\
			"arg=\"$arg\""\
			"valid=\"$valid\""\
			"autocomplete=\"$complete\">"
		echo "		<title>`"$item" --title`</title>"
		echo "		<subtitle mod=\"$DESCRIPTION_MODIFIER\">`"$item" --description`</subtitle>"
		echo "		<subtitle mod=\"$USAGE_MODIFIER\">`"$item" --usage`</subtitle>"
		echo "	</item>"
	done
fi

command="$1"
shift

if [[ -e "$COMMANDS_DIR/$command.sh" ]]; then
	"$COMMANDS_DIR/$command.sh" --extra-alfred-items "$@"
fi

echo "</items>"
