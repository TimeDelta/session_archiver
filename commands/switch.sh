#!/bin/bash
source ./util/global.sh

debug "in `basename "$0"`:"
debug "$@"

COMMAND_NAME="`basename "${0%.*}"`"

modifiers=""
while [[ $1 == "-m" ]]; do
	if [[ -n $modifiers ]]; then
		modifiers="$modifiers "
	fi
	modifiers="$modifiers$2"
	shift 2
done

case $1 in
	--max-args)
		echo \-1
		exit 0 ;;
	--should-list-sessions)
		echo 1
		exit 0 ;;
	--extra-alfred-items)
		exit 0 ;;
	--session-alt-subtitle)
		case $modifiers in
			fn) echo ;;
			cmd) echo ;;
			ctrl) echo ;;
			alt) echo ;;
			shift) echo ;;
		esac
		exit 0 ;;
esac

session="$1"
shift

IFS=$'\n'
for current in `get_active_sessions`; do
	"$COMMANDS_DIR"/close.sh "$current"
done

"$COMMANDS_DIR/"/restore.sh "$session"
