#!/usr/bin/env python  
import redis, sys, os, json, jinja2
from jinja2 import Template

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
data=json.loads (r_server.get(i_key))
email = data['Email']
hostname = data['Hostname']
os.system("cd /opt/certs && openssl req -inform pem -outform der -in server.csr -out server.der")
os.system("service haproxy stop")
request = ("cd /opt/certs && letsencrypt certonly --csr server.der --standalone --non-interactive --agree-tos --email %s --standalone-supported-challenges http-01" % email)
os.system(request)
os.system(" cd /opt/certs && cat 0001_chain.pem server.key > server.bundle.pem")
config_template=open('/opt/controlbox/bin/templates/haproxy.cfg').read()
template = Template(config_template)
os.system("rm -rf /opt/haproxy/haproxy.cfg")
config = (template.render(hostname=hostname, crt_path="/opt/certs/server.bundle.pem"))
open("/opt/haproxy/haproxy.cfg", "w").write(config)
os.system("service haproxy start")