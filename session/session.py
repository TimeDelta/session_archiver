#!/usr/bin/env python
"""This module defines an individual session."""
import sys
sys.path.insert(0, '..')

from util.item import Item
from util import const
from util import globals
from util.applications import Applications
from uuid import uuid4

class Session(Item):
	const.SESSIONS_DIR = const.ROOT_DIR + "/sessions"

	def __init__(self, name, description, apps):
		"""Construct a new session from scrath."""
		super(Command, self).__init__("")
		self._name = name
		self._apps = apps
		self._uid = uuid4()
		self._description = description
		self.directory = const.SESSIONS_DIR + '/' + name

	def __init__(self, directory):
		"""Reconstruct an existing session."""
		self.directory = directory
		self._name = directory[directory.rfind('/') + 1:]

	def name(self):
		return self._name

	def description(self):
		return self._description

	def list_apps(self):
		return self._apps

	def store_to_file(self):
		with open(self.directory + '/session', 'w') as f:
			f.write(self._name)
			f.write(self._description)
			for app in self._apps:
				f.write(app)

	def open(self):
		Applications.open_apps(self._apps)
		for app in self._apps:
			Applications.run_app_action_for_session(app, "open", self._name)

Item.register(Session)
