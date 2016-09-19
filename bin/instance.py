import boto.ec2
import sys
import json
import argparse
import subprocess
from boto.vpc import VPCConnection




class Instance(object):

    # full arguments object passed
    args = None

    def __init__(self, settings):
        '''
        Constructor
        '''
        self.settings = settings

    def instances_list(self):
        try:
            #connect to vpc
            #regionObj = boto.ec2.get_region(self.args.region)
            #conn_vpc = VPCConnection(region=regionObj)
            #vpc = conn_vpc.get_all_vpcs(vpc_ids=vpc_id)[0]
            #vpcs = conn_vpc.get_all_vpcs()
            #for vpc in vpcs:
            #    print vpc


            print
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=['i-39dc50dd','i-4d9b3ac7'])
            #reservations = conn.get_only_instances()
            for instance in reservations:
                print instance
                instance.start()

#    instance = conn.get_all_instances(
#            filters=({"vpc_id": vpc.id, "key-name": HOSTNAME}))[0]

#    print instance

        except boto.exception.EC2ResponseError as e:
            print "ERROR AWS >> ({0}): {1}".format(e.error_code, e.message)
            sys.exit(1)

    def instances_start(self):
        try:
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=self.settings.instancelist)
            for instance in reservations:
                print instance
                instance.start()

        except boto.exception.EC2ResponseError as e:
            print "ERROR AWS >> ({0}): {1}".format(e.error_code, e.message)
            sys.exit(1)

    def instances_stop(self):
        try:
            conn = boto.ec2.connect_to_region(self.settings.args.region)
            reservations = conn.get_only_instances(instance_ids=self.settings.instancelist)
            for instance in reservations:
                print instance
                instance.stop()

        except boto.exception.EC2ResponseError as e:
            print "ERROR AWS >> ({0}): {1}".format(e.error_code, e.message)
            sys.exit(1)
