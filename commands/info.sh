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
	--title) echo "Info"; exit 0 ;;
	--description) echo "Display information about a specific session."; exit 0 ;;
	--usage) echo "$COMMAND_NAME [session name]"; exit 0 ;;
	--valid) echo "NO"; exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME"; exit 0 ;;
	--extra-alfred-items)
		session="$1"
		shift

		print_session_items "`get_all_sessions | grep "$session.*"`"

		if [[ -z $session ]]; then
			active="`get_active_sessions`"
			print_item --valid NO "Active Sessions" "${active:-There are currently no active sessions.}"
			print_item --valid NO "Inactive Sessions" "`get_inactive_sessions`"
		else
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
						print_item --valid NO --complete "$autocomplete" "$app" "$description"
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

unindent_debug
