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

session="$1"
shift

case $session in
	--max-args) echo \-1; exit 0 ;;
	--title) echo "Info"; exit 0 ;;
	--description) echo "Display information about a specific session."; exit 0 ;;
	--usage) echo "$COMMAND_NAME [search query]"; exit 0 ;;
	--valid) echo "NO"; exit 0 ;;
	--complete) echo "$COMMAND_NAME "; exit 0 ;;
	--arg) echo "$COMMAND_NAME <args>"; exit 0 ;;
	--should-list-sessions) echo 1; exit 0 ;;
	--extra-alfred-items)
		active="`get_active_sessions`"
		print_extra_item --valid NO "Active Sessions" "${active:-There are currently no active sessions.}"
		print_extra_item --valid NO "Inactive Sessions" "`get_inactive_sessions`"
		exit 0 ;;
	--session-alt-subtitle)
		session="$1"
		case $modifiers in
			fn) echo ;;
			cmd) get_session_apps "$session" | tr '\n' ',' | sed -e 's/,$//' -e 's/,/, /g' ;;
			ctrl) echo ;;
			alt) echo ;;
			shift) echo ;;
		esac
		exit 0 ;;
esac
