#!/usr/bin/env python
"""This module defines the abstract base class for each command."""

from abc import ABCMeta

class Item:
	# make this an abstract base class
	__metaclass__ = ABCMeta

	def __init__(self,
		title,
		subtitle=None,
		uid=None,
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
		self._subtitle = subtitle
		self._uid = uid
		self._arg = arg
		self._autocomplete = autocomplete
		self._copy = copy
		self._valid = valid
		self._fn_subtitle = fn_subtitle
		self._shift_subtitle = shift_subtitle
		self._cmd_subtitle = cmd_subtitle
		self._ctrl_subtitle = ctrl_subtitle
		self._alt_subtitle = alt_subtitle

	def uid(self):
		return self._uid

	def arg(self):
		return self._arg

	def valid(self):
		return self._valid

	def autocomplete(self):
		return self._autocomplete

	def title(self):
		return self._title

	def subtitle(self):
		return self._subtitle

	def fn_subtitle(self):
		return self._fn_subtitle

	def shift_subtitle(self):
		return self._shift_subtitle

	def cmd_subtitle(self):
		return self._cmd_subtitle

	def ctrl_subtitle(self):
		return self._ctrl_subtitle

	def alt_subtitle(self):
		return self._alt_subtitle

	def print_xml(self):
		tag = '	<item'
		if self.uid():
			tag += ' uid="' + str(self.uid()) + '"'
		if self.arg():
			tag += ' arg="' + str(self.arg()) + '"'
		if self.valid():
			tag += ' valid="' + str(self.valid()) + '"'
		if self.autocomplete():
			tag += ' autocomplete="' + str(self.autocomplete()) + '"'
		tag += '>\n'
		if self.title():
			tag += '		<title>' + str(self.title()) + '</title>\n'
		if self.subtitle():
			tag += '		<subtitle>' + str(self.subtitle()) + '</subtitle>\n'

		tag += '	</item>\n'
		print(tag)
