#!/usr/bin/env python
# borrowed from: http://codeyarns.com/2014/12/23/how-to-define-constant-in-python/
"""This module allows variables to be made constant."""

# Usage:
# import const
# const.magic = 23 # First binding is fine
# const.magic = 88 # Second binding raises const.ConstError

class _const:
	class ConstError(TypeError):
		pass

	def __setattr__(self,name,value):
		if name in self.__dict__.keys():
			raise(self.ConstError, "Can't rebind const(%s)" % name)
		self.__dict__[name] = value

import sys
sys.modules[__name__] = _const()
