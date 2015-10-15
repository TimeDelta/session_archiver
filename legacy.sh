query="{query}"

SESSION_FILE="./${query}.session"

# store and close current session
appsToClose="$(osascript <<EOT
	tell application "System Events"
		set openApps to (name of every process whose background only is false and name is not "Finder" and name is not "JavaApplicationStub")

		-- IBM and Java-based apps don't work well
		set theresult to (do shell script "ps -Ao command | grep -i dbvisualizer | grep -v grep || true")
		if length of theresult > 0 then
			set openApps to openApps & "DbVisualizer"
		end if
		set theresult to (do shell script "ps -Ao command | grep -i '^/Applications/Sametime' | grep -v grep || true")
		if length of theresult > 0 then
			set openApps to openApps & "Sametime"
		end if
		set theresult to (do shell script "ps -Ao command | grep -i '^/Applications/IBM Notes' | grep -v grep || true")
		if length of theresult > 0 then
			set openApps to openApps & "IBM Notes"
		end if

		set openApps to sortlist openApps with remove duplicates
		tell me to set selectedApps to choose from list openApps with multiple selections allowed
	end tell
	if selectedApps is not false then
		set closedApps to []
		repeat with appName in openApps
			if appName is not in selectedApps then
				if appName is "iTerm2" then
					set appName to "iTerm"
				else if appName is "DbVisualizer" then
					set appName to "JavaApplicationStub"
				end if
				if appName is not in closedApps then
					set closedApps to closedApps & appName
				end if
			end if
		end repeat
		set previousSessionApps to closedApps
		set output to ""
		repeat with currentLine in previousSessionApps
			set output to output & currentLine & "\n"
		end repeat
		output
	end if
EOT
)"

IFS=$'\n'

if [[ -z $appsToClose ]]; then
	exit 0
fi

# clear the contents of the session file
: > "$SESSION_FILE"

for app in $appsToClose; do
	osascript -e "tell application \"$app\" to quit"
	echo "$app" >> "$SESSION_FILE"
done
