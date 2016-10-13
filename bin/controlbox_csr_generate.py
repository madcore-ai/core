import redis, sys, os, json, jinja2
from jinja2 import Template
r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
x = r_server.get(i_key)
y = json.loads(x)

config_template=open('/opt/controlbox/bin/templates/openssl.conf').read()
template = Template(config_template)
config = (template.render(OrganizationName=y['OrganizationName'],OrganizationalUnitName=y['OrganizationalUnitName'],Email=y['Email'],LocalityName=y['LocalityName'],Hostname=y['Hostname'],Country=y['Country']))
open("/opt/certs/openssl.cnf", "w").write(config)

os.system("openssl req -nodes -newkey rsa:2048 -keyout /opt/certs/server.key -out  /opt/certs/server.csr -config /opt/certs/openssl.cnf -sha256 -batch -reqexts SAN")


