#!/usr/bin/env python
import sys
from commands.commands import Commands

Commands.run(sys.argv[2], ' '.join(sys.argv[3:]).split(';'), sys.argv[1])
