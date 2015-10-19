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

name="$1"
shift

case $name in
	--title) echo "Create"; exit 0 ;;
	--description) echo "Create a session with the specified name and description."; exit 0 ;;
	--usage) echo "$COMMAND_NAME {name} {description}"; exit 0 ;;
	--valid) echo "NO"; exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME"; exit 0 ;;
	--extra-alfred-items)
		name="$1"
		shift
		description="$*"
		complete="$COMMAND_NAME '$name'"
		if [[ -n $name ]]; then
			if [[ -n `get_all_sessions | grep "^$name$"` ]]; then
				title="Session named \"$name\" already exists."
				complete="`echo "$complete" | sed "s/'//g"`"
				valid=NO
			else
				title="Create a session named \"$name\""
				valid=YES
				if [[ -n $description ]]; then
					title="$title with description:"
					complete="$complete '$description'"
				fi
			fi
			print_item\
				--valid $valid\
				--arg "$COMMAND_NAME '$name' '$description'"\
				--complete "$complete"\
				"$title"\
				"$description"
		fi
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

description="$*"
debug "description: $description"

debug "getting installed apps"
indent_debug
installed_apps="`get_installed_apps`"
debug "$installed_apps"
unindent_debug

debug "getting chosen apps"
chosen_apps="$(osascript <<EOT
	choose from list {$installed_apps} with prompt "Which applications would you like to include in this session?" with multiple selections allowed
	set chosenApps to result
	set output to ""
	repeat with currentLine in chosenApps
		set output to output & currentLine & "\n"
	end repeat
	output
EOT
)"
debug "$chosen_apps"

debug "Running application action '$COMMAND_NAME' for chosen apps"
indent_debug
IFS=$'\n'
for app in $chosen_apps; do
	debug "	$app"
	mkdir -p "$SESSIONS_DIR/$name/$app"
	run_app_action_for_session "$app" "$COMMAND_NAME" "$name"
done
unindent_debug

echo "$chosen_apps" | set_session_apps "$name"
set_session_uuid "$name" "`uuidgen`"
set_session_description "$name" "$description"

echo -n "Created Session $name"
if [[ -n $description ]]; then
	echo " ($description)"
fi

unindent_debug
