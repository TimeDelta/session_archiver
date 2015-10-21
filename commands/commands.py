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
	def get_command_list():
		return self.command_list

	@staticmethod
	def run(command_name, *args):
		commands[command_name].run(args)
