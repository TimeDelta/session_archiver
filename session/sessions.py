#!/usr/bin/env python
"""This module defines a utility class for sessions."""

class Sessions:
	sessions = _get_sessions()

	@staticmethod
	def is_session(name):
		return name in sessions

	@staticmethod
	def sessions_starting_with(start):
		# TODO
		return

	@staticmethod
	def _get_sessions():
		# TODO
		return []
