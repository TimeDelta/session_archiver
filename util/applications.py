#!/usr/bin/env python
"""This module defines a utility class for getting information about applications."""

import subprocess
import re

class Applications:
	lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
	installed_apps_command = lsregister + ' | grep --only-matching "/.*\.app"'
	ignored_apps_regex = re.compile(r'//|^/System|/Library/|^/Resources|/Xcode\.app/Contents|/com\\?\.[^/.]+.*\.app|\.app/|^/Users/[^/]+/\.Trash/')

	@staticmethod
	def installed_apps():
		"""List the names of installed apps on this machine"""
		output = subprocess.check_output([installed_apps_command])

		# ignore apps that don't exist

		# pull out just the app name

		# sort alphabetically

		# get rid of duplicates

		return
