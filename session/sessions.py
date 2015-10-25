#!/usr/bin/env python
"""This module defines a utility class for sessions."""

import const
from util.files import listdirs

class Sessions:
	sessions = _get_sessions()
	const.CURRENT_SESSIONS_FILE = "/tmp/%s.current_sessions" % const.WORKFLOW_ID

	@staticmethod
	def is_session(name):
		return name in sessions

	@staticmethod
	def sessions_starting_with(start):
		# TODO
		return

	@staticmethod
	def _get_sessions():
		return listdirs(const.SESSIONS_DIR, names_only=True)
