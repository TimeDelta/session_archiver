#!/bin/bash
source ./global_vars.sh

debug() {
	echo -ne "$DEBUG_INDENTATION" >&2
	echo "$@" >&2
}

indent_debug() {
	export DEBUG_INDENTATION="${DEBUG_INDENTATION}	"
}

unindent_debug() {
	export DEBUG_INDENTATION="$(echo "$DEBUG_INDENTATION" | sed "s/`echo -e '\t'`//")"
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

print_item() {
	# after options:
	# 	$1 = title
	# 	$2 = subtitle
	fn= ctrl= cmd= shift= alt=
	local title subtitle uuid arg complete copy valid='YES'
	local num_shifts
	while [[ $# -gt 0 && -z $title ]]; do
		case $1 in
			--arg) arg="$2" ;;
			--complete) complete="autocomplete=\"$2\"" ;;
			--copy) copy="$2" ;;
			--valid) valid="$2" ;;
			--uuid) uid="uid=\"$2\"" ;;
			--fn) export fn="$2" ;;
			--ctrl) export ctrl="$2" ;;
			--cmd) export cmd="$2" ;;
			--shift) export shift="$2" ;;
			--alt) export alt="$2" ;;
			*) title="$1"; num_shifts=1 ;;
		esac
		shift ${num_shifts:-2}
	done
	subtitle="$1"
	arg="${arg:-$title}"
	copy="${copy:-$subtitle}"

	echo "	<item $uid arg=\"$arg\" valid=\"$valid\" $complete>"
	echo "		<title>$title</title>"
	echo "		<subtitle>$subtitle</subtitle>"
	for mod in fn ctrl cmd shift alt; do
		local mod_sub="`env | grep "^$mod=" | sed 's/.*=//'`"
		if [[ -n $mod_sub ]]; then
			echo "		<subtitle mod=\"$mod\">$mod_sub</subtitle>"
		fi
	done
	echo "		<copy>$copy</copy>"
	echo "	</item>"
	unset fn ctrl cmd shift alt
}

print_session_items() {
	indent_debug
	debug "printing session items:"
	indent_debug

	mod_sub() {
		local mod="$1" session="$2"
		run_command "$COMMAND_NAME" -m $mod --session-alt-subtitle "$session"
	}

	local sessions="$1"
	shift

	local session OLD_IFS="$IFS"
	IFS=$'\n'
	for session in $sessions; do
		debug "$session"
		print_item\
			--uuid "$COMMAND_NAME.`get_session_uuid "$session"`"\
			--arg "$COMMAND_NAME $session `quote_args "$@"`"\
			--complete "$COMMAND_NAME $session `echo "$@" | sed "s/^$session//"`"\
			--valid "`run_command "$COMMAND_NAME" --valid "$@"`"\
			--fn "`mod_sub fn "$session"`"\
			--ctrl "`mod_sub ctrl "$session"`"\
			--cmd "`mod_sub cmd "$session"`"\
			--alt "`mod_sub alt "$session"`"\
			--shift "`mod_sub shift "$session"`"\
			"$session"\
			"`get_session_description "$session"`"
	done
	IFS="$OLD_IFS"
	unset mod_sub

	unindent_debug
	unindent_debug
}

run_command() {
	local command="$1"
	shift
	"$COMMANDS_DIR/$command.sh" "$@"
}

get_app_path() {
	local lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'
	$lsregister -dump | grep "$*.app" | sed -E 's/.*path: +//'
}

get_installed_apps() {
	/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump \
	| grep --only-matching "/.*\.app" \
	| egrep -v '//|^/System|/Library/|^/Resources|/Xcode.app/Contents|/com\\?\.[^/.]+.*\.app|\.app/|^/Users/[^/]/\.Trash/' \
	| {
		local line
		while read -s line; do
			if [[ -e "$line" ]]; then
				echo "$line"
			fi
		done
	} | tr '\n' '\0' \
	| xargs -0L 1 basename \
	| sort \
	| uniq \
	| sed -e 's/.app$//' -e 's/^/\"/' -e 's/$/\"/' \
	| tr '\n' ',' \
	| sed 's/,$//'
}

get_active_sessions() {
	cat "$CURRENT_SESSIONS_FILE"
}

get_inactive_sessions() {
	indent_debug
	debug "getting inactive sessions:"

	get_all_sessions | {
		local active="`get_active_sessions`"
		if [[ -n $active ]]; then
			grep -vFxf <(echo "$active")
		else
			tr '\n' '\0' | xargs -0L 1 echo
		fi
	}

	unindent_debug
}

is_session_active() {
	if [[ -n `get_active_sessions | grep -fx "$1" 2> /dev/null` ]]; then
		echo 1
	else
		echo 0
	fi
}

set_session_active() {
	echo "$1" > "$CURRENT_SESSIONS_FILE"
}

set_session_inactive() {
	# remove the session from the current sessions file
	sed -i "" "/$1/d" "$CURRENT_SESSIONS_FILE"
}

get_all_sessions() {
	ls -1 "$SESSIONS_DIR"
}

get_session_apps() {
	indent_debug

	local session="$1"
	debug "Getting session apps for: $session"
	cat "$SESSIONS_DIR/$session/apps"

	unindent_debug
}

# read apps from stdin (one per line)
# $1 = session name
set_session_apps() {
	local session="$1"
	local session_apps_file="$SESSIONS_DIR/$session/apps"

	# make sure the apps file for the specified session exists
	touch "$session_apps_file"

	# delete any existing apps
	: > "$session_apps_file"

	# write the new set of apps to file
	local line
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
	# touch the file to make sure it gets created even if uuid is empty
	touch "$SESSIONS_DIR/$session/uuid"
	echo "$uuid" > "$SESSIONS_DIR/$session/uuid"
}

get_session_description() {
	local session="$1"
	cat "$SESSIONS_DIR/$session/description"
}

set_session_description() {
	local session="$1"
	local description="$2"
	# touch the file to make sure it gets created even if description is empty
	touch "$SESSIONS_DIR/$session/description"
	echo "$description" > "$SESSIONS_DIR/$session/description"
}

run_app_action_for_session() {
	local app="$1" action="$2" session="$3"
	indent_debug
	debug "$APPLICATION_ACTIONS_DIR/$app/$action.sh"
	if [[ -e "$APPLICATION_ACTIONS_DIR/$app/$action.sh" ]]; then
		indent_debug
		debug Running
		"$UTIL/source_and_run.sh"\
			"$UTIL/global.sh"\
			--indir "$SESSIONS_DIR/$session/$app"\
			--script "$APPLICATION_ACTIONS_DIR/$app/$action.sh"
		unindent_debug
	fi
	unindent_debug
}
