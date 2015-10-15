#!/bin/bash
eval "`cat "$UTIL/global_public.sh"`"

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
		echo >> "$session_apps_file"
	done
}

set_session_uuid() {
	local session="$1"
	local uuid="$2"
	echo "$uuid" > "$SESSIONS_DIR/$session/uuid"
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
	bash -c "cd '$SESSIONS_DIR/$session' && '$UTIL/source_and_run.sh' '$UTIL/global_public.sh' '$APPLICATION_ACTIONS_DIR/$app/$action.sh'"
}
