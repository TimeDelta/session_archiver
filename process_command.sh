#!/bin/bash
command="$1"
shift

./commands/$command.sh "$@"
