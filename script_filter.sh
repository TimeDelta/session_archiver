#!/bin/bash
source ./util/global.sh

# for debugging
if [[ $1 == "--debug" ]]; then
	export DEBUG="ON"
	shift
else
	export DEBUG=''
fi
debug_item() {
	# $1 = title
	# $2 = value
	if [[ -n $DEBUG ]]; then
		cat <<EOB
		<item arg="debug '$1' '$2'" valid="NO" autocomplete="$2">
			<title>debug: $1</title>
			<subtitle>$2</subtitle>
			<copy>$2</copy>
		</item>
EOB
	fi
}

echo "<?xml version=\"1.0\"?>"
echo "<items>"

command="$1"
shift

expanded="`get_command_for_alias "$command"`"
command="${expanded:-$command}"

if [[ $# -le 1 && `is_command "$command"` -eq 0 ]]; then
	print_command_items "$command"
fi

# split args based on semicolons
OLD_IFS="$IFS"
IFS=$'\n'
set -- `echo "$@" | tr ';' '\n' | stripws | grep -v '^$'`
IFS="$OLD_IFS"

if [[ `is_command "$command"` -eq 1 ]]; then
	run_command "$command" --extra-alfred-items "$@"
fi

echo "</items>"
