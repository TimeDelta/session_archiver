#!/usr/bin/env python
"""This is the main entry point for the workflow"""
import sys
import logging
from commands.commands import Commands

def main():
	command = None
	args = None
	if len(sys.argv) > 1:
		command = sys.argv[1]
		if len(sys.argv) > 2:
			# split args on semicolons
			args = ' '.join(sys.argv[2:]).split(';')

	cmds = Commands.commands_starting_with(command)
	for cmd in cmds:
		cmd.print_xml()

	if len(cmds) == 1:
		for item in cmds[0].extra_items(args):
			item.print_xml()

if __name__ == '__main__':
	main()
