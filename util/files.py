#!/usr/bin/env python
"""This module defines some utility functions for interacting with the file system"""

from os.path import isfile, join
import re
from os import listdir

def listfiles(directories, recursive=None, regex=None):
	if type(directories) != list:
		directories = [directories]
	if type(regex) == str:
		regex = re.compile(regex)
	for directory in directories:
		if not recursive:
			if regex:# non-recursive, regex
				files = [ join(directory, f) for f in listdir(directory) if isfile(join(directory, f)) and regex.search(f) ]
			else:# non-recursive, no regex
				files = [ join(directory, f) for f in listdir(directory) if isfile(join(directory, f))]
		elif regex:# recursive, regex
			files = []
			for dir, subfolders, dir_files in os.walk(directory):
				files.extend( [ join(dir, file) for file in dir_files if regex.search(file) ] )
		else:# recursive, no regex
			files = []
			for dir, subFolders, dir_files in os.walk(directory):
				files.extend( [ join(dir, file) for file in dir_files ] )
	return files

# generator version (light weight when compared to other version)
def yieldfiles(directories, recursive=None, regex=None):
	if type(directories) != list:
		directories = [directories]
	if type(regex) == str:
		regex = re.compile(regex)
	for directory in directories:
		if not recursive:
			if regex:# non-recursive, regex
				for f in listdir(directory):
					if isfile(join(directory, f)) and regex.search(f):
						yield join(directory, f)
			else:# non-recursive, no regex
				for f in listdir(directory):
					if isfile(join(directory, f)):
						yield join(directory, f)
		elif regex:# recursive, regex
			for dir, subfolders, dir_files in os.walk(directory):
				for file in dir_files:
					if regex.search(file):
						yield join(dir, file)
		else:# recursive, no regex
			for dir, subFolders, dir_files in os.walk(directory):
				for file in dir_files:
					yield join(dir, file)
