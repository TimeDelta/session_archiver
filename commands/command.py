#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

from abc import ABCMeta
from util import item

class Command(Item):
	__metaclass__ = ABCMeta

	def __init__(self):
		return self

	def title():
		return self.__name__[0:1].upperCase() + self.__name__[1:]

	def command_name():
		return self.__name__
