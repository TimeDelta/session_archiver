export GLOBAL_VARS=set
export WORKFLOW_ID="com.bryanherman.sessionarchiver"
export ROOT_DIR="`pwd`"
export COMMANDS_DIR="$ROOT_DIR/commands"
export SESSIONS_DIR="$ROOT_DIR/sessions"
export CURRENT_SESSIONS_FILE="$SESSIONS_DIR/.current_sessions"
export APPLICATION_ACTIONS_DIR="$ROOT_DIR/application_actions"
export UTIL="$ROOT_DIR/util"

unset_global_vars() {
	local this_file="./global_vars.sh"
	egrep --only-matching '^[^= ]*=' "$this_file" \
		| sed 's/=$//' \
		| {
			while read -s var; do
				unset var
			done
		}
	unset unset_global_vars
}
