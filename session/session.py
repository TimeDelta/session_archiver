#!/usr/bin/env python
"""This module defines an individual session."""

from util import Item

class Session(Item):
	def __init__(self, name):
		"""Construct a new session from scrath."""
		self.name = name

	def __init__(self, directory):
		"""Reconstruct an existing session."""
		self.directory = directory
		# self.name = directory

	def session_name(self):
		return self.name

	def store_to_file(self):
		# TODO
		return
