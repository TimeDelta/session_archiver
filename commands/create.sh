#!/bin/bash
source ./util/global.sh

debug "in `basename "$0"`:"
debug "$@"

modifiers=""
while [[ $1 == "-m" ]]; do
	if [[ -n $modifiers ]]; then
		modifiers="$modifiers "
	fi
	modifiers="$modifiers$2"
	shift 2
done

case $1 in
	--max-args)
		echo \-1
		exit 0 ;;
	--should-list-sessions)
		echo 0
		exit 0 ;;
	--extra-alfred-items)
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

name="$1"
shift
description="$@"
debug "description: $description"

installed_apps="`\
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump \
	| grep --only-matching "/.*\.app" \
	| egrep -v '//|^/System|/Library/|^/Resources|/Xcode.app/Contents|/com\\?\.[^/.]+.*\.app|\.app/|^/Users/[^/]/\.Trash/' \
	| {
		while read -s line; do
			if [[ -e "$line" ]]; then
				echo "$line"
			fi
		done
	} | tr '\n' '\0' \
	| xargs -0L 1 basename \
	| sort \
	| uniq \
	| sed -e 's/.app$//' -e 's/^/\"/' -e 's/$/\"/' \
	| tr '\n' ',' \
	| sed 's/,$//'`"
debug "$installed_apps"
debug "getting chosen apps"

chosen_apps="$(osascript <<EOT
	choose from list {$installed_apps} with prompt "Which applications would you like to include in this session?" with multiple selections allowed
	set chosenApps to result
	set output to ""
	repeat with currentLine in chosenApps
		set output to output & currentLine & "\n"
	end repeat
	output
EOT
)"
debug "$chosen_apps"
debug "storing chosen apps"

IFS=$'\n'
for app in $chosen_apps; do

done

echo "$chosen_apps" | set_session_apps "$name"
set_session_uuid "$name" "`uuidgen`"
set_session_description "$name" "$description"
