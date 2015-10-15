#!/bin/bash
source ./util/global.sh

debug "in `basename "$0"`:"
debug "$@"

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
	--max-args)
		echo \-1
		exit 0 ;;
	--should-list-sessions)
		echo 1
		exit 0 ;;
	--extra-alfred-items)
		active="`active_sessions`"
		print_extra_item --valid NO "Active Sessions" "${active:-There are currently no active sessions.}"
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
