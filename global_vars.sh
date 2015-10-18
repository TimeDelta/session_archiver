#!/bin/bash
# @TODO make this assignment dynamic by parsing info.plist
export WORKFLOW_ID="com.bryanherman.sessionarchiver"

# directory / file paths
export ROOT_DIR="`pwd`"
export COMMANDS_DIR="$ROOT_DIR/commands"
export SESSIONS_DIR="$ROOT_DIR/sessions"
export CURRENT_SESSIONS_FILE="/tmp/$WORKFLOW_ID.current_sessions"
export APPLICATION_ACTIONS_DIR="$ROOT_DIR/application_actions"
export UTIL="$ROOT_DIR/util"

export DESCRIPTION_MODIFIER="" # this is the default
export USAGE_MODIFIER="alt"
