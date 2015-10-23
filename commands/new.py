#!/usr/bin/env python
"""This module defines the new command, which creates a new session."""

class New(Command):
	def __init__(self):
		self.valid = False
		return self

	def description():
		return "Create a new session."

	def usage(self):
		return self.command_name() + " name; description"

	def extra_items(self, *args):
		items = []
		if
		items.add(Item(""))
		return

	def run(self, *args):
		return

Command.register(New)
