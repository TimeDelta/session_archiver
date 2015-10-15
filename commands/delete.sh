#!/bin/bash
if [[ $1 == "--max-args" ]]; then
	echo 1
	exit 0
fi

debug() {
	echo "$@" >&2
}

debug "in create.sh:"
debug "$@"

modifiers=""
while [[ $1 == "-m" ]]; do
	modifiers="$modifiers $2"
	shift 2
done

name="$1"

rm -f ./sessions/"$name".{session,uuid,description}
