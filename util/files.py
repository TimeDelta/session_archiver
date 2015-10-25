#!/usr/bin/env python
"""This module defines some utility functions for interacting with the file system"""

from os.path import isfile, isdir, join
import re
from os import listdir

def _join(directory, f, names_only):
	if names_only:
		return f
	return join(directory, f)

def listfiles(directories, recursive=None, regex=None, names_only=None):
	if type(directories) != list:
		directories = [directories]
	if type(regex) == str:
		regex = re.compile(regex)
	for directory in directories:
		if not recursive:
			if regex:# non-recursive, regex
				files = [ _join(directory, f, names_only) for f in listdir(directory) if isfile(join(directory, f)) and regex.search(f) ]
			else:# non-recursive, no regex
				files = [ _join(directory, f, names_only) for f in listdir(directory) if isfile(join(directory, f))]
		elif regex:# recursive, regex
			files = []
			for dir, subfolders, dir_files in os.walk(directory):
				files.extend( [ _join(dir, file, names_only) for file in dir_files if regex.search(file) ] )
		else:# recursive, no regex
			files = []
			for dir, subFolders, dir_files in os.walk(directory):
				files.extend( [ _join(dir, file, names_only) for file in dir_files ] )
	return files

def listdirs(directories, recursive=None, regex=None, names_only=None):
	if type(directories) != list:
		directories = [directories]
	if type(regex) == str:
		regex = re.compile(regex)
	for directory in directories:
		if not recursive:
			if regex:# non-recursive, regex
				dirs = [ _join(directory, f, names_only) for f in listdir(directory) if isdir(join(directory, f)) and regex.search(f) ]
			else:# non-recursive, no regex
				dirs = [ _join(directory, f, names_only) for f in listdir(directory) if isdir(join(directory, f))]
		elif regex:# recursive, regex
			dirs = []
			for dir, subfolders, dir_files in os.walk(directory):
				dirs.extend( [ _join(dir, file, names_only) for file in dir_files if regex.search(file) ] )
		else:# recursive, no regex
			dirs = []
			for dir, subFolders, dir_files in os.walk(directory):
				dirs.extend( [ _join(dir, file, names_only) for file in dir_files ] )
	return dirs

# generator version (light weight when compared to other version)
def yieldfiles(directories, recursive=None, regex=None, names_only=None):
	if type(directories) != list:
		directories = [directories]
	if type(regex) == str:
		regex = re.compile(regex)
	for directory in directories:
		if not recursive:
			if regex:# non-recursive, regex
				for f in listdir(directory):
					if isfile(join(directory, f)) and regex.search(f):
						yield _join(directory, f, names_only)
			else:# non-recursive, no regex
				for f in listdir(directory):
					if isfile(join(directory, f)):
						yield _join(directory, f, names_only)
		elif regex:# recursive, regex
			for dir, subfolders, dir_files in os.walk(directory):
				for file in dir_files:
					if regex.search(file):
						yield _join(dir, file, names_only)
		else:# recursive, no regex
			for dir, subFolders, dir_files in os.walk(directory):
				for file in dir_files:
					yield _join(dir, file, names_only)
