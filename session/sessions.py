#!/usr/bin/env python
"""This module defines a utility class for sessions."""

from util import const
from util import globals
from util.files import listdirs

class Sessions:
	session_dirs = listdirs(const.SESSIONS_DIR)
	sessions = []
	for dir in session_dirs:
		sessions.append(Session(dir))

	# get a list of open sessions
	const.CURRENT_SESSIONS_FILE = "/tmp/%s.current_sessions" % const.WORKFLOW_ID
	open_sessions = []
	with open(const.CURRENT_SESSIONS_FILE, 'r') as f:
		for line in f:
			open_sessions.append(Sessions.get_session_named(line))

	# get list of closed sessions
	closed_sessions = list(set(sessions) - set(open_sessions))

	@staticmethod
	def is_session(name):
		return name in Sessions.sessions

	@staticmethod
	def get_session_named(name):
		for session in Sessions.sessions:
			if session.name() == name:
				return session

	@staticmethod
	def sessions_starting_with(start):
		matches = []
		for session in Sessions.sessions:
			if (session.name().startswith(start)):
				matches.append(session)
		return matches

	@staticmethod
	def get_open_sessions():
		return open_sessions

	@staticmethod
	def get_closed_sessions():
		return closed_sessions
