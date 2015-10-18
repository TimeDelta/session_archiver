#!/bin/bash
export WORKFLOW_ID="$(grep -A 1 bundleid info.plist \
	| sed -nE 's:</?string>::g; 2p' \
	| sed -E "s/^( |`echo -e '\t'`)*//;s/( |`echo -e '\t'`)*$//")"
export DEBUG_INDENTATION=""

# directory / file paths
export ROOT_DIR="`pwd`"
export COMMANDS_DIR="$ROOT_DIR/commands"
export SESSIONS_DIR="$ROOT_DIR/sessions"
export CURRENT_SESSIONS_FILE="/tmp/$WORKFLOW_ID.current_sessions"
export APPLICATION_ACTIONS_DIR="$ROOT_DIR/application_actions"
export UTIL="$ROOT_DIR/util"

# modifiers
export DESCRIPTION_MODIFIER="" # this is the default
export USAGE_MODIFIER="alt"
