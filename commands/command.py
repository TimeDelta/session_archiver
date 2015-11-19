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
		super(Item)
		cmd_name = self.command_name()
		self.title = cmd_name[0:1].upperCase() + cmd_name[1:]
		self.arg = cmd_name
		self.alt_subtitle = self.usage()

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
