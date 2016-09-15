import settings
import instance
import os
import argparse
import sys





class Struct:
    def __init__(self, **entries):
        self.__dict__.update(entries)

class MyParser(argparse.ArgumentParser):

    def error(self, message):

        sys.stderr.write('ERROR: %s\n' % message)
        self.print_help()
        sys.exit(2)



print
print "Devops Factory Controlbox CLI (c) 2015-2016 Peter Styk"
print

parser = MyParser(prog="./df.py", description="Devops Factory Controlbox")
group = parser.add_mutually_exclusive_group()
group.add_argument('-i', '--instance', help='Operations on AWS instance', action='store_true')
requiredNamed = parser.add_argument_group('required arguments')
parser.add_argument("region", help='AWS region')
parser.add_argument("instancelist", help='Array of instances for AWS filter')
args = parser.parse_args()

# Render all settings from various places also collect and program proper environment variables for CLI modules.
settings = settings.Settings(args)

if args.instance:
    i = instance.Instance(settings)
    i.get_all_instances()
