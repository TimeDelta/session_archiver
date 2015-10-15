#!/bin/bash

# close the current Sublime project
# NOTE: this will only work if you add this keyboard shortcut in the system preferences panel:
#       cmd+alt+shift+ctrl-w
osascript -e '
	tell application "Sublime Text" to activate
	tell application "System Events" to keystroke "w" using {command down, option down, shift down, control down}
'
