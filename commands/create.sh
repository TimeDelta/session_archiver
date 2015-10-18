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
	--title) echo "Create"; exit 0 ;;
	--description) echo "Create a session with the specified name and description."; exit 0 ;;
	--usage) echo "$COMMAND_NAME {name} {description}"; exit 0 ;;
	--valid) echo "NO"; exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME <args>"; exit 0 ;;
	--should-list-sessions) echo 0; exit 0 ;;
	--extra-alfred-items)
		shift
		name="$1"
		shift
		description="$@"
		if [[ -n $name ]]; then
			title="Create a session named \"$name\""
			if [[ -n $description ]]; then
				title="$title with description:"
			fi
			print_extra_item --valid YES --arg "create '$name' '$description'" "$title" "$description"
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

name="$1"
shift
description="$@"
debug "description: $description"

debug "getting installed apps"
installed_apps="`get_installed_apps`"
debug "$installed_apps"

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
IFS=$'\n'
for app in $chosen_apps; do
	debug "	$app"
	mkdir -p "$SESSIONS_DIR/$name/$app"
	run_app_action_for_session "$app" "$COMMAND_NAME" "$name"
done

echo "$chosen_apps" | set_session_apps "$name"
set_session_uuid "$name" "`uuidgen`"
set_session_description "$name" "$description"

echo -n "Created Session $name"
if [[ -n $description ]]; then
	echo " ($description)"
fi
