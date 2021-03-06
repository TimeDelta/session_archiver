#!/bin/bash
source "$1"
shift

debug "`basename "$0"` `quote_args "$@"`"
indent_debug

if [[ $1 == "--indir" ]]; then
	cd "$2"
	shift 2
fi

# if the command to run is a script, then we have to source it
do_source=''
if [[ $1 == "--script" ]]; then
	do_source=source
	shift
fi

$do_source "$@"

unindent_debug
