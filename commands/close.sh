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
	--title) echo "Close"; exit 0 ;;
	--description)
		active="`get_active_sessions | tr '\n' ',' | sed 's/,$//;s/,/, /'`"
		echo "Close all active sessions (${active:-No active sessions})."
		exit 0 ;;
	--usage) echo "$COMMAND_NAME {session name}"; exit 0 ;;
	--valid) echo "YES"; exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME"; exit 0 ;;
	--extra-alfred-items)
		query="$*"
		print_session_items "`get_active_sessions | grep "$query.*"`"
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

# if $session is not supplied, close all active sessions
if [[ -z $session ]]; then
	IFS=$'\n'
	for session in `get_active_sessions`; do
		"$0" "$session"
	done
	exit 0
fi

debug "Getting apps that need closed"
apps_to_close="$(osascript <<EOT
	tell application "System Events"
		set openApps to (name of every process)
	end tell
	set output to ""
	repeat with currentLine in openApps
		set output to output & currentLine & "\n"
	end repeat
	output
EOT
)"
apps_to_close="`echo "$apps_to_close" | grep -f <(get_session_apps "$session")`"
debug "$apps_to_close"

IFS=$'\n'

debug "closing apps"
# close the apps associated with the specified session
# @NOTE apps still get closed even if they're part of another active session
for app in $apps_to_close; do
	run_app_action_for_session "$app" "$COMMAND_NAME" "$session"
	osascript -e "tell application \"$app\" to quit"
done

set_session_inactive "$session"

echo "Closed Session: $session"

unindent_debug
