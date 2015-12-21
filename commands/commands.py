#!/usr/bin/env python
"""This module defines common utility functions for interacting with commands"""
import sys
sys.path.insert(0, '..')

from new import New
# from delete import Delete
from open import Open
# from close import Close
# from switch import Switch
from info import Info

class Commands:
	command_list = [
		"new",
		# "delete",
		"open",
		# "close",
		# "switch",
		"info"
	]
	commands = {
		"new": New(),
		# "delete" : Delete(),
		"open": Open(),
		# "close": Close(),
		# "switch": Switch(),
		"info": Info()
	}

	@staticmethod
	def command_list():
		return command_list

	@staticmethod
	def is_command(command_name):
		return Commands.commands[command_name] != None

	@staticmethod
	def commands_starting_with(start):
		if start:
			return [c for c in Commands.commands.values() if c.command_name().startswith(start)]
		else:
			return Commands.commands.values()

	@staticmethod
	def run(command_name, args, modifier=None):
		Commands.commands[command_name].run(args, modifier)
