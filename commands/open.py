#!/usr/bin/env python
"""This module defines the open command, which opens an existing session."""

from session import Sessions

class Open(Command):
	def __init__(self):
		super(self)
		self.valid = "NO"

	def description():
		return "Open an existing session."

	def usage(self):
		return self.command_name() + " name"

	def extra_items(self, *args):
		name = None
		if len(args) > 0:
			name = args[0]

		items = []
		for session in Sessions.sessions_starting_with(name):
			# build comma-separated list of apps in the session
			apps = session.list_apps()
			app_list = apps[0]
			for app in apps[1:]:
				app_list += ', ' + app

			items.append(Item('Open "' + session.name() + '"',
			                  subtitle=session.description(),
			                  cmd_subtitle=app_list,
			                  valid="YES"))

		return items

	def run(self, *args):
		name = args[0]
		session = Sessions.get_session_named(name)
		session.open()

Command.register(Open)
