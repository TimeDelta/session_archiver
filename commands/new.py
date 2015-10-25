#!/usr/bin/env python
"""This module defines the new command, which creates a new session."""

from session import session
import subprocess
import const
from util import applications

class New(Command):
	const.CHOOSE_APPS_SCRIPT = const.COMMANDS_DIR + '/choose_apps.applescript'

	def __init__(self):
		super(self)
		self.valid = "NO"

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
		cmd = 'osascript -e "%s" "' % const.CHOOSE_APPS_SCRIPT
		cmd += '" "'.join(Applications.installed_apps()) + '"'
		chosen_apps = subprocess.check_output([cmd]).split('\n')

		sess = Session(name, chosen_apps)
		sess.store_to_file()

Command.register(New)
