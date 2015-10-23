#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

from abc import ABCMeta
from util import item

class Command(Item):
	__metaclass__ = ABCMeta

	def __init__(self):
		cmd_name = self.commandName()
		self.title = cmd_name[0:1].upperCase() + cmd_name[1:]
		self.arg = self.command_name()
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
