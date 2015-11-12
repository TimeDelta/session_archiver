#!/usr/bin/env python
"""This module defines the info command, which creates a new session."""

from session import session
import subprocess
import const
from util import applications

class Info(Command):
	def __init__(self):
		super(self)
		self.valid = "NO"

	def description():
		return "Get informatin about sessions."

	def usage(self):
		return self.command_name() + " [session name[; app name]]"

	def extra_items(self, *args):
		name = None
		if len(args) > 0:
			name = args[0]

		items = []
		if name:
			if len(args) > 1 and Sessions.is_session(name):
				Applications.run_app_action_for_session(args[1],
					self.command_name(),
					matching_sessions[0])
			else:
				# TODO override Item portion of these sessions
				items.extend(Sessions.sessions_starting_with(name))
		else:
			# display comma-separated list of open sessions
			session_list = ', '.join([s.name() for s in Sessions.get_open_sessions()])
			if not session_list:
				session_list = 'There are no open sessions.'
			items.append(Item('Open Sessions',
			                  subtitle=session_list,
			                  valid="NO"))

			# display comma-separated list of closed sessions
			session_list = ', '.join([s.name() for s in Sessions.get_closed_sessions()])
			if not session_list:
				session_list = 'There are no closed sessions.'
			items.append(Item('Closed Sessions',
			                  subtitle=session_list,
			                  valid="NO"))
		return items

	def run(self, *args):
		# TODO
		return

Command.register(Info)

if __name__ == '__main__':
	import sys
	info = Info()
	info.run(sys.argv)
