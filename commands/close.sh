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
		session="$1"
		if [[ -z $session ]]; then
			active="`get_active_sessions | tr '\n' ',' | sed 's/,/, /'`"
			echo "Close all active sessions (${active:-No active sessions})."
		else
			echo "Close the specified active session."
		fi
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

# @TODO close all active sessions if $session is not supplied

apps_to_close="$(osascript <<EOT
	tell application "System Events"
		set openApps to (name of every process whose name is in {`get_session_apps "$session" | tr '\n' ',' | sed 's/,$//'`})
	end tell
	set output to ""
	repeat with currentLine in openApps
		set output to output & currentLine & "\n"
	end repeat
	output
EOT
)"

IFS=$'\n'

# close the apps associated with the specified session
# @NOTE apps still get closed even if they're part of another active session
for app in $apps_to_close; do
	run_app_action_for_session "$app" "$COMMAND_NAME" "$session"
	osascript -e "tell application \"$app\" to quit"
	echo "$app" >> "$SESSION_FILE"
done

set_session_inactive "$session"

echo "Closed Session: $session"

unindent_debug
