#!/usr/bin/env python
"""This module is used for logging purposes."""

import datetime
from sys import stderr

def log(message):
	message = "{ts} {msg}".format(ts=datetime.datetime.now().isoformat(), msg=message)
	print(message, file=sys.stderr)
