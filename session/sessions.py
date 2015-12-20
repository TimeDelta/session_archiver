#!/usr/bin/env python
"""This module defines a utility class for sessions."""
import sys
sys.path.insert(0, '..')

from os.path import isfile

from util import const
from util import globals
from util.files import listdirs
from session import Session

class Sessions:
	session_dirs = listdirs(const.SESSIONS_DIR)
	sessions = []
	for dir in session_dirs:
		sessions.append(Session(dir))

	# if the current sessions temp file doesn't exist, create it
	const.CURRENT_SESSIONS_FILE = "/tmp/%s.current_sessions" % const.WORKFLOW_ID
	if not isfile(const.CURRENT_SESSIONS_FILE):
		f = open(const.CURRENT_SESSIONS_FILE, 'w')
		f.close()

	# get a list of open sessions
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
		return None

	@staticmethod
	def sessions_starting_with(start):
		if start:
			return [s for s in Sessions.sessions if s.name().startswith(start)]
		else:
			return Sessions.sessions

	@staticmethod
	def get_open_sessions():
		return open_sessions

	@staticmethod
	def get_closed_sessions():
		return closed_sessions
