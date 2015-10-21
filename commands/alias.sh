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

command="$1"
shift

case $command in
	--title) echo "`echo "${COMMAND_NAME:0:1}" | tr 'a-z' 'A-Z'`${COMMAND_NAME:1}"; exit 0 ;;
	--description) echo "Create an alias for a command."; exit 0 ;;
	--usage) echo "$COMMAND_NAME {command} {alias}"; exit 0 ;;
	--valid)
		if [[ $# -gt 0 ]]; then
			echo "YES"
		else
			echo "NO"
		fi
		exit 0 ;;
	--complete) echo "$COMMAND_NAME"; exit 0 ;;
	--arg) echo "$COMMAND_NAME"; exit 0 ;;
	--extra-alfred-items)
		command="$1"
		shift
		if [[ $# -lt 1 ]]; then
			print_command_items "$command"
		elif [[ `is_command "$command"` -eq 1 ]]; then
			short="$1"
			if [[ -n $short ]]; then
				print_item --valid YES\
					--complete "$COMMAND_NAME $command; $short"\
					--arg "$COMMAND_NAME '$command' '$short'"\
					"Alias '$command' as '$short'"
			fi
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

# @NOTE currently, a semicolon must be used to separate the command name from the alias. revisit this later.
debug "alias $1='$command'"
alias_command "$1" "$command"

unindent_debug
