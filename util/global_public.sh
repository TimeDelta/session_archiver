#!/bin/bash

debug() {
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

get_active_sessions() {
	[[ -n $GLOBAL_VARS ]] && local is_private=yes || local is_private=''
	cat "$CURRENT_SESSIONS_FILE"
	[[ -n $is_private ]] && unset_global_vars || return 0
}

get_all_sessions() {
	[[ -n $GLOBAL_VARS ]] && local is_private=yes || local is_private=''
	ls -1 "$SESSIONS_DIR"
	[[ -n $is_private ]] && unset_global_vars || return 0
}

get_session_uuid() {
	[[ -n $GLOBAL_VARS ]] && local is_private=yes || local is_private=''
	local session="$1"
	cat "$SESSIONS_DIR/$session/uuid"
	[[ -n $is_private ]] && unset_global_vars || return 0
}

get_session_description() {
	[[ -n $GLOBAL_VARS ]] && local is_private=yes || local is_private=''
	local session="$1"
	cat "$SESSIONS_DIR/$session/description"
	[[ -n $is_private ]] && unset_global_vars || return 0
}

get_session_apps() {
	[[ -n $GLOBAL_VARS ]] && local is_private=yes || local is_private=''
	local session="$1"
	cat "$SESSIONS_DIR/$session/apps"
	[[ -n $is_private ]] && unset_global_vars || return 0
}
