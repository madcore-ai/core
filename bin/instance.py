import boto.ec2
import sys
import json
import argparse
import subprocess
from boto.vpc import VPCConnection

region = "eu-west-1"

try:
    #connect to vpc
    regionObj = boto.ec2.get_region(region)
    conn_vpc = VPCConnection(region=regionObj)
    conn = boto.ec2.connect_to_region(region)
    #vpc = conn_vpc.get_all_vpcs(vpc_ids=vpc_id)[0]
    vpcs = conn_vpc.get_all_vpcs()
    for vpc in vpcs:
        print vpc




    print
    reservations = conn.get_all_instances(instance_ids=['i-fed3d873'])
    #reservations = conn.get_all_instances()
    for reservation in reservations:
        for instance in reservation.instances:
            print instance



#    instance = conn.get_all_instances(
#            filters=({"vpc_id": vpc.id, "key-name": HOSTNAME}))[0]

#    print instance

except boto.exception.EC2ResponseError as e:
    print "ERROR AWS >> ({0}): {1}".format(e.error_code, e.message)
    sys.exit(1)
