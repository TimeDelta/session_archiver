#!/bin/bash

subl="`get_app_path "Sublime Text"`/Contents/SharedSupport/bin/subl"
debug "subl: $subl"
"$subl" "`cat ./workspace_file_path`"
