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
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME <args>"; exit 0 ;;
	--should-list-sessions) echo 1; exit 0 ;;
	--extra-alfred-items)
		if [[ $# -eq 0 ]]; then
			active="`get_active_sessions`"
			print_extra_item --valid NO "Active Sessions" "${active:-There are currently no active sessions.}"
			print_extra_item --valid NO "Inactive Sessions" "`get_inactive_sessions`"
		else
			session="$1"
			shift

			matching_sessions="`get_all_sessions | grep "^$session$"`"
			if [[ -n $matching_sessions ]]; then
				session_apps="`get_session_apps "$session"`"
				app="$*"
				if [[ -n `echo "$session_apps" | grep "^$app$"` ]]; then
					run_app_action_for_session "$app" "$COMMAND_NAME" "$session"
				else
					IFS=$'\n'
					for app in `get_session_apps "$session"`; do
						description="Show this session's info about the saved state of $app"
						autocomplete="$COMMAND_NAME $session $app"
						print_extra_item --valid NO --complete "$autocomplete" "$app" "$description"
					done
				fi
			fi
		fi
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
