#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

from abc import ABCMeta

class Item:
	__metaclass__ = ABCMeta

	def __init__(self,
		title,
		subtitle=None,
		arg=None,
		autocomplete=None,
		copy=None,
		valid=None,
		fn_subtitle=None,
		shift_subtitle=None,
		cmd_subtitle=None,
		ctrl_subtitle=None,
		alt_subtitle=None
	):
		self.subtitle = subtitle
		self.arg = arg
		self.autocomplete = autocomplete
		self.copy = copy
		self.valid = valid
		return self

	def uid():
		return self.uid

	def arg():
		return self.arg

	def valid():
		return self.valid

	def autocomplete():
		return self.autocomplete

	def title():
		return self.title

	def subtitle():
		return self.subtitle

	def fn_subtitle():
		return self.fn_subtitle

	def shift_subtitle():
		return self.shift_subtitle

	def cmd_subtitle():
		return self.cmd_subtitle

	def ctrl_subtitle():
		return self.ctrl_subtitle

	def alt_subtitle():
		return self.alt_subtitle

	def print_xml(self):
		tag = '	<item'
		if self.uid():
			tag += ' uid="' + self.uid() + '"'
		if self.arg():
			tag += ' arg="' + self.arg() + '"'
		if self.valid():
			tag += ' valid="' + self.valid() + '"'
		if self.autocomplete():
			tag += ' autocomplete="' + self.autocomplete() + '"'
		tag += '>\n'
		if self.title():
			tag += '		<title>' + self.title() + '</title>'
		if self.subtitle():
			tag += '		<subtitle>' + self.subtitle() + '</subtitle>'

		tag += '	</item>'
		print(tag)
