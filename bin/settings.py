"""
Created on April 28, 2016
@author: Peter Styk <peter@styk.tv>
"""


class Struct:
    def __init__(self, **entries):
        self.__dict__.update(entries)


class Settings(object):
    # full arguments object passed
    args = None

    def __init__(self, args):
        """
        Constructor
        """
        self.args = args
        self.instance_list = args.instance_list.split(",")
