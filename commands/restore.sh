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
	--max-args) echo \-1; exit 0 ;;
	--title) echo "Restore"; exit 0 ;;
	--description) echo "Restore the specified session."; exit 0 ;;
	--usage) echo "$COMMAND_NAME [search query]"; exit 0 ;;
	--valid)
		shift
		if [[ -z $1 ]]; then
			echo "YES"
		else
			echo "NO"
		fi
		exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME <args>"; exit 0 ;;
	--should-list-sessions) echo 1; exit 0 ;;
	--extra-alfred-items) exit 0 ;;
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

# @TODO if no sesion is specified restore the most recently archived session
IFS=$'\n'
debug "`get_session_apps "$session"`"
for app in `get_session_apps "$session"`; do
	debug "launching: $app"
	osascript -e "tell application \"$app\" to launch"
	run_app_action_for_session "$app" "$COMMAND_NAME" "$session"
done

set_session_active "$session"

echo "Restored Session: $session"
