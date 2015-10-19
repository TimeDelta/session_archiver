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
	--title) echo "Switch"; exit 0 ;;
	--description) echo "Close all active sessions and restore the chosen session."; exit 0 ;;
	--usage) echo "$COMMAND_NAME {session name}"; exit 0 ;;
	--valid)
		if [[ $# -gt 0 ]]; then
			echo "YES"
		else
			echo "NO"
		fi
		exit 0 ;;
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

IFS=$'\n'
for current in `get_active_sessions`; do
	run_command close "$current"
done

run_command restore "$session"

unindent_debug
