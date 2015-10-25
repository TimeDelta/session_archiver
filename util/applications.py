#!/usr/bin/env python
"""This module defines a utility class for getting information about applications."""

import subprocess
import re
import const
from os.path import isdir

class Applications:
	const.APPLICATION_ACTIONS_DIR = const.ROOT_DIR + "/application_actions"

	lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
	installed_apps_command = lsregister + ' | grep --only-matching "/.*\.app"'
	ignored_apps_regex = re.compile(r'//|^/System|/Library/|^/Resources|/Xcode\.app/Contents|/com\\?\.[^/.]+.*\.app|\.app/|^/Users/[^/]+/\.Trash/')
	app_name_regex = re.compile(r'/([^/]*)\.app')

	@staticmethod
	def installed_apps():
		"""List the names of installed apps on this machine"""
		output = subprocess.check_output([installed_apps_command])

		# convert into list
		_apps = output.split('\n')

		# filter out useless lines and apps that don't exist
		apps = []
		for app in _apps:
			if ignored_apps_regex.search(app) == None:
				# ignore apps that don't exist
				if isdir(app) == True:
					# pull out just the app name
					apps.append(app_name_regex.search(app).group(1))

		# get rid of duplicates and sort alphabetically
		apps = sorted(list(set(apps)))

		return apps
