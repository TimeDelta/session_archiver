#!/bin/bash

workspace_file="$(osascript <<EOT
	choose file with prompt "Where is the Sublime Text workspace file?"
	set output to POSIX path of result
	output
EOT
)"

echo "$workspace_file" > ./workspace_file_path
