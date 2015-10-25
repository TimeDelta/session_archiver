#!/usr/bin/env python
"""This module defines an individual session."""

from util import Item
from util import const

class Session(Item):
	const.SESSIONS_DIR = const.ROOT_DIR + "/sessions"

	def __init__(self, name):
		"""Construct a new session from scrath."""
		self.name = name

	def __init__(self, directory):
		"""Reconstruct an existing session."""
		self.directory = directory
		# self.name = directory

	def session_name(self):
		return self.name

	def description(self):
		return self.description

	def list_apps(self):
		# TODO
		return

	def store_to_file(self):
		# TODO
		return
