#!/usr/bin/env python
"""This module defines an individual session."""

from util import Item
from util import const
from util import globals
from util import applications
from uuid import uuid4

class Session(Item):
	const.SESSIONS_DIR = const.ROOT_DIR + "/sessions"

	def __init__(self, name, description, apps):
		"""Construct a new session from scrath."""
		self.name = name
		self.apps = apps
		self.uid = uuid4()
		self.description = description
		self.directory = const.SESSIONS_DIR + '/' + name

	def __init__(self, directory):
		"""Reconstruct an existing session."""
		self.directory = directory
		self.name = directory[directory.rfind('/') + 1:]

	def name(self):
		return self.name

	def description(self):
		return self.description

	def list_apps(self):
		return self.apps

	def store_to_file(self):
		with open(self.directory + '/session', 'w') as f:
			f.write(self.name)
			f.write(self.description)
			for app in self.apps:
				f.write(app)

	def open(self):
		Applications.open_apps(self.apps)
		for app in self.apps:
			Applications.run_app_action_for_session(app, "open", self.name)
