#!/usr/bin/env python
"""This module defines the new command, which creates a new session."""
import sys
sys.path.insert(0, '..')

import subprocess
import re

from session.sessions import Sessions
from session.session import Session
from command import Command
from util import const
from util.applications import Applications
from util.item import Item

class New(Command):
	const.CHOOSE_APPS_SCRIPT = const.COMMANDS_DIR + '/choose_apps.applescript'

	def __init__(self):
		super(New, self).__init__()
		self._valid = "NO"

	def command_name(self):
		return re.sub(r'.*\.', '', __name__)

	def description():
		return "Create a new session."

	def usage(self):
		return self.command_name() + " name; description"

	def autocomplete(self):
		return self.command_name()

	def extra_items(self, args):
		if not args or len(args) == 0 or not args[0]:
			return []

		name = str(args[0])

		if Sessions.is_session(name) == True:
			return [Item('Session named "' + name + '" already exists.')]

		title = 'Create a session named "' + name + '"'
		description = None
		if len(args) > 1:
			description = args[1]
			title += " with description:"

		arg = self.command_name() + ' ' + name + '; ' + description

		return [Item(title,
		             arg=arg,
		             subtitle=description,
		             valid="YES")]

	def run(self, args, modifier):
		name = args[0]
		description = None
		if len(args) > 1:
			description = args[1]

		# let user choose which apps to include
		cmd = ['osascript', const.CHOOSE_APPS_SCRIPT]
		cmd.extend(Applications.installed_apps())
		chosen_apps = subprocess.check_output(cmd, universal_newlines=True).split('\n')

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
	new.run(sys.argv[2:], sys.argv[1])
