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
	const.CURRENT_SESSIONS_FILE = "/tmp/%s.current_sessions" % const.WORKFLOW_ID

	@staticmethod
	def is_session(name):
		return name in Sessions.sessions

	@staticmethod
	def sessions_starting_with(start):
		matches = []
		for session in Sessions.sessions:
			if (session.name().startswith(start)):
				matches.append(session)
		return matches
