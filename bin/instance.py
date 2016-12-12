from __future__ import print_function
import boto.ec2
import sys
import argparse
from settings import Settings

EC2_actions = ['start', 'stop']


def parse_args():
    """
    Parse arguments for input params
    """

    parser = argparse.ArgumentParser(prog="AWS EC2 instances management")

    parser.add_argument('-r', '--region', required=True, help='AWS region')
    parser.add_argument('-il', '--instance_list', required=True, help='AWS list of instances, comma separated')
    parser.add_argument('-a', '--action', required=True, choices=EC2_actions, help='EC2 instance action')
    parser.add_argument('-d', '--debug', default=True, action='store_true')

    return parser.parse_args()


class Instance(object):
    def __init__(self, settings):
        self.settings = settings

    def log(self, msg):
        if self.settings.args.debug:
            print(msg)

    def instances_list(self):
        try:
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=self.settings.instance_list)
            for instance in reservations:
                self.log(instance)

        except boto.exception.EC2ResponseError as e:
            self.log("ERROR AWS >> ({0}): {1}".format(e.error_code, e.message))
            sys.exit(1)

    def instances_start(self):
        try:
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=self.settings.instance_list)
            for instance in reservations:
                self.log("Starting: {0}...".format(instance))
                instance.start()
                self.log('OK')

        except boto.exception.EC2ResponseError as e:
            self.log("ERROR AWS >> ({0}): {1}".format(e.error_code, e.message))
            sys.exit(1)

    def instances_stop(self):
        try:
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=self.settings.instance_list)
            for instance in reservations:
                self.log("Stopping: {0}...".format(instance))
                instance.stop()
                self.log('OK')

        except boto.exception.EC2ResponseError as e:
            self.log("ERROR AWS >> ({0}): {1}".format(e.error_code, e.message))
            sys.exit(1)

    def instance_action(self):
        if self.settings.args.action in ['start']:
            self.instances_start()
        elif self.settings.args.action in ['stop']:
            self.instances_stop()


if __name__ == '__main__':
    args = parse_args()
    settings = Settings(args)
    inst = Instance(settings)
    inst.instance_action()
