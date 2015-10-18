#!/bin/bash
source ./global_vars.sh

debug() {
	# @TODO add debug indentation tracking using global var
	echo "$@" >&2
}

quote_args() {
	local args=""
	for arg in "$@"; do
		if [[ -n $args ]]; then
			args="$args "
		fi
		args="$args'$arg'"
	done
	echo "$args"
}

print_extra_item() {
	# after options:
	# 	$1 = title
	# 	$2 = subtitle
	local title subtitle uuid arg complete copy valid='YES'
	local num_shifts
	while [[ $# -gt 0 && -z $title ]]; do
		case $1 in
			--arg) arg="$2" ;;
			--complete) complete="$2" ;;
			--copy) copy="$2" ;;
			--valid) valid="$2" ;;
			--uuid) uuid="uid=\"$2\"" ;;
			*) title="$1"; num_shifts=1 ;;
		esac
		shift ${num_shifts:-2}
	done
	subtitle="$1"
	arg="${arg:-$title}"
	complete="${complete:-$arg}"
	copy="${copy:-$subtitle}"
	cat <<EOB
		<item $uid arg="$arg" valid="$valid" autocomplete="$complete">
			<title>$title</title>
			<subtitle>$subtitle</subtitle>
			<copy>$copy</copy>
		</item>
EOB
}

get_active_sessions() {
	cat "$CURRENT_SESSIONS_FILE"
}

get_inactive_sessions() {
	get_all_sessions | grep -vFxf <(get_active_sessions)
}

is_session_active() {
	if [[ -n `get_active_sessions | grep -fx "$session" 2> /dev/null` ]]; then
		echo 1
	else
		echo 0
	fi
}

set_session_active() {
	echo "$session" > "$CURRENT_SESSIONS_FILE"
}

set_session_inactive() {
	# remove the session from the current sessions file
	sed -i "" "/$session/d" "$CURRENT_SESSIONS_FILE"
}

get_all_sessions() {
	ls -1 "$SESSIONS_DIR"
}

get_session_apps() {
	local session="$1"
	debug "Getting session apps from: '$SESSIONS_DIR/$session/apps'"
	cat "$SESSIONS_DIR/$session/apps"
}

# read apps from stdin (one per line)
# $1 = session name
set_session_apps() {
	local session="$1"
	local session_apps_file="$SESSIONS_DIR/$session/apps"

	# make sure the apps file for the specified session exists exists
	touch "$session_apps_file"

	# delete any existing apps
	: > "$session_apps_file"

	# write the new set of apps to file
	while read -s line; do
		echo "$line" >> "$session_apps_file"
	done
}

get_session_uuid() {
	local session="$1"
	cat "$SESSIONS_DIR/$session/uuid"
}

set_session_uuid() {
	local session="$1"
	local uuid="$2"
	echo "$uuid" > "$SESSIONS_DIR/$session/uuid"
}

get_session_description() {
	local session="$1"
	cat "$SESSIONS_DIR/$session/description"
}

set_session_description() {
	local session="$1"
	local description="$2"
	echo "$description" > "$SESSIONS_DIR/$session/description"
}

run_app_action_for_session() {
	local app="$1"
	local action="$2"
	local session="$3"
	debug "$APPLICATION_ACTIONS_DIR/$app/$action.sh"
	if [[ -e "$APPLICATION_ACTIONS_DIR/$app/$action.sh" ]]; then
		debug Running
		bash -c "'$UTIL/source_and_run.sh' \
			'$UTIL/global.sh' \
			'cd \"$SESSIONS_DIR/$session/$app\" && \"$APPLICATION_ACTIONS_DIR/$app/$action.sh\"'"
	fi
}
