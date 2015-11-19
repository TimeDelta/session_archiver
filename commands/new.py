#!/usr/bin/env python
"""This module defines the new command, which creates a new session."""
import sys
sys.path.insert(0, '..')

from session.session import Session
from command import Command
import subprocess
from util import const
from util.applications import Applications

class New(Command):
	const.CHOOSE_APPS_SCRIPT = const.COMMANDS_DIR + '/choose_apps.applescript'

	def __init__(self):
		super(Command)
		self._valid = "NO"

	def description():
		return "Create a new session."

	def usage(self):
		return self.command_name() + " name; description"

	def extra_items(self, *args):
		if len(args) == 0:
			return []

		name = args[0]

		if Sessions.is_session(name) == True:
			return [Item('Session named "' + name + '" already exists.')]

		title = 'Create a session named "' + name + '"'
		description = None
		if len(args) > 1:
			description = args[1]
			title += " with description:"

		return [Item(title,
		             subtitle=description,
		             valid="YES")]

	def run(self, *args):
		name = args[0]
		description = None
		if len(args) > 1:
			description = args[1]

		# let user choose which apps to include
		cmd = 'osascript -e "%s" "' % const.CHOOSE_APPS_SCRIPT
		cmd += '" "'.join(Applications.installed_apps()) + '"'
		chosen_apps = subprocess.check_output([cmd], universal_newlines=True).split('\n')

		# create the session
		sess = Session(name, description, chosen_apps)
		sess.store_to_file()

		# each chosen app should have its own directory for application actions
		for app in chosen_apps:
			dir = const.SESSIONS_DIR + '/' + name + '/' + app
			subprocess.call(['mkdir', '-p', dir], universal_newlines=True)
			Applications.run_app_action_for_session(app, 'new', name)

Command.register(New)

if __name__ == '__main__':
	import sys
	new = New()
	new.run(sys.argv)
