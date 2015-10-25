on run(installed_apps)
	choose from list installed_apps with prompt "Which applications would you like to include in this session?" with multiple selections allowed
	set chosenApps to result
	set output to ""
	repeat with currentLine in chosenApps
		set output to output & currentLine & "\n"
	end repeat
	output
end run
