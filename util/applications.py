#!/usr/bin/env python
"""This module defines a utility class for getting information about applications."""

import subprocess
import re
import const
import globals
from os.path import isdir

class Applications:
	const.APPLICATION_ACTIONS_DIR = const.ROOT_DIR + "/application_actions"

	lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
	ignored_apps_regex = re.compile(r'//|^/System|/Library/|^/Resources|/Xcode\.app/Contents|/com\\?\.[^/.]+.*\.app|\.app/|^/Users/[^/]+/\.Trash/')
	app_name_regex = re.compile(r'/([^/]*)\.app')

	@staticmethod
	def installed_apps():
		"""List the names of installed apps on this machine"""
		lsreg = subprocess.Popen([Applications.lsregister, '-dump'],
			stdout=subprocess.PIPE,
			universal_newlines=True)
		output = subprocess.check_output(['grep', '--only-matching', '/.*\.app'],
			stdin=lsreg.stdout,
			universal_newlines=True)

		# convert into list
		_apps = output.split('\n')

		# filter out useless lines and apps that don't exist
		apps = []
		for app in _apps:
			if Applications.ignored_apps_regex.search(app) == None:
				# ignore apps that don't exist
				if isdir(app) == True:
					# pull out just the app name
					apps.append(Applications.app_name_regex.search(app).group(1))

		# get rid of duplicates and sort alphabetically
		apps = sorted(list(set(apps)))

		return apps

	@staticmethod
	def app_path(app_name):
		return subprocess.check_output([lsregister + ' -dump | grep "$*.app" | sed -E "s/.*path: +//"'], universal_newlines=True)

if __name__ == '__main__':
	import sys
	if sys.argv[1] == '--app_path':
		print(Applications.app_path(sys.argv[2]))
	elif sys.argv[1] == '--installed-apps':
		for app in Applications.installed_apps():
			print(app)
