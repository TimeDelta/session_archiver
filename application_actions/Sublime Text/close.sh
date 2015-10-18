#!/bin/bash

# close the current Sublime project
subl="`get_app_path "Sublime Text"`/Contents/SharedSupport/bin/subl"
debug "subl: $subl"
"$subl" --command close_project
"$subl" --command close_workspace
