#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

from abc import ABCMeta
from util import item

class Command(Item):
	# make this an abstract base class
	__metaclass__ = ABCMeta

	const.COMMANDS_DIR = const.ROOT_DIR + "/commands"

	def __init__(self):
		cmd_name = self.command_name()
		self.title = cmd_name[0:1].upperCase() + cmd_name[1:]
		self.arg = cmd_name
		return self

	def command_name(self):
		return self.__name__

	@abstractmethod
	def description(self):
		return

	@abstractmethod
	def usage(self):
		return

	@abstractmethod
	def run(self, *args):
		return

	@abstractmethod
	def extra_items(self, *args):
		return
