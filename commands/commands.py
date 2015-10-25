#!/usr/bin/env python
"""This module defines common utility functions for interacting with commands"""

from commands import new
from commands import delete
from commands import open
from commands import close
from commands import switch
from commands import info

class Commands:
	command_list = ["new", "delete", "open", "close", "switch", "info"]
	commands = {
		"new" : New(),
		"delete" : Delete(),
		"open": Open(),
		"close": Close(),
		"switch": Switch(),
		"info": Info()
	}

	@staticmethod
	def command_list():
		return command_list

	@staticmethod
	def is_command(command_name):
		return commands[command_name] != None

	@staticmethod
	def commands_starting_with(start):
		matching_commands = []
		for (command_name, command) in commands:
			# NOTE make sure that python does short-circuiting here
			if start == None or command_name.startswith(start):
				matching_commands.append(command)
		return matching_commands

	@staticmethod
	def run(command_name, *args):
		commands[command_name].run(args)
