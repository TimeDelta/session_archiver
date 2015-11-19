#!/usr/bin/env python
"""This module defines the abstract base class for each command."""
import sys
sys.path.insert(0, '..')

from abc import ABCMeta, abstractmethod
from util.item import Item
from util import const
from util import globals

class Command(Item):
	# make this an abstract base class
	__metaclass__ = ABCMeta

	const.COMMANDS_DIR = const.ROOT_DIR + "/commands"

	def __init__(self):
		super(Command, self).__init__("")
		cmd_name = self.command_name()
		self._title = cmd_name[0:1].upper() + cmd_name[1:]
		self._arg = cmd_name
		self._alt_subtitle = self.usage()

	def command_name(self):
		return __name__

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

Item.register(Command)
