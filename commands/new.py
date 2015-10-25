#!/usr/bin/env python
"""This module defines the new command, which creates a new session."""

import session

class New(Command):
	def __init__(self):
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
		# TODO
		return

Command.register(New)
