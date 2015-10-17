#!/bin/bash
source ./util/global.sh

debug "in `basename "$0"`:"
debug "$@"

command="$1"
shift

debug "Processing: ./commands/$command.sh $@"
./commands/$command.sh "$@"
