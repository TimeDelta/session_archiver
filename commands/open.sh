#!/bin/bash
source ./util/global.sh

debug "`basename "$0"` `quote_args "$@"`"
indent_debug

COMMAND_NAME="`basename "${0%.*}"`"

modifiers=""
while [[ $1 == "-m" ]]; do
	if [[ -n $modifiers ]]; then
		modifiers="$modifiers "
	fi
	modifiers="$modifiers$2"
	shift 2
done

session="$1"
shift

case $session in
	--title) echo "`echo "${COMMAND_NAME:0:1}" | tr 'a-z' 'A-Z'`${COMMAND_NAME:1}"; exit 0 ;;
	--description) echo "Restore the specified session."; exit 0 ;;
	--usage) echo "$COMMAND_NAME {session name}"; exit 0 ;;
	--valid) echo "YES"; exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME"; exit 0 ;;
	--extra-alfred-items)
		query="$*"
		print_session_items "`get_inactive_sessions | grep "$query.*"`"
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

unindent_debug
