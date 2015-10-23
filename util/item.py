#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

class Item:
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
		self.fn_subtitle = fn_subtitle
		self.shift_subtitle = shift_subtitle
		self.cmd_subtitle = cmd_subtitle
		self.ctrl_subtitle = ctrl_subtitle
		self.alt_subtitle = alt_subtitle
		return self

	def uid(self):
		return self.uid

	def arg(self):
		return self.arg

	def valid(self):
		return self.valid

	def autocomplete(self):
		return self.autocomplete

	def title(self):
		return self.title

	def subtitle(self):
		return self.subtitle

	def fn_subtitle(self):
		return self.fn_subtitle

	def shift_subtitle(self):
		return self.shift_subtitle

	def cmd_subtitle(self):
		return self.cmd_subtitle

	def ctrl_subtitle(self):
		return self.ctrl_subtitle

	def alt_subtitle(self):
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
