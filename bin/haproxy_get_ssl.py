#!/usr/bin/env python  
import redis, sys, os, json, jinja2
from jinja2 import Template

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
data=json.loads (r_server.get(i_key))
email = data['Email']
hostname = data['Hostname']

#### get certificate
#os.system("cd /opt/certs && openssl req -inform pem -outform der -in server.csr -out server.der")
#os.system("service haproxy stop")
#request = ("cd /opt/certs && letsencrypt certonly --csr server.der --standalone --non-interactive --agree-tos --email %s --standalone-supported-challenges http-01" % email)
#os.system(request)
#os.system(" cd /opt/certs && cat 0001_chain.pem server.key > server.bundle.pem")


### reconfigure haproxy
app_key="apps"
data_r=r_server.get(app_key)
os.system("rm -rf /opt/haproxy/haproxy.cfg")
config_template=open('/opt/controlbox/bin/templates/haproxy.cfg').read()

if data_r:
    apps=json.JSONDecoder().decode(data_r)
    app=apps["apps"]
    frontend_conf="use_backend %s if { hdr_end(host) -i %s }" % (app[0], app[0]+"."+data['Hostname'])
    backend_conf=("backend %s\n    balance roundrobin\n    server %s 127.0.0.1:%s check" % (app[0], app[0], "9001"))
    template = Template(config_template)
    config = (template.render(hostname=hostname, crt_path="/opt/certs/server.bundle.pem", subdomain1=frontend_conf, backend2=backend_conf))
else:
    template = Template(config_template)
    config = (template.render(hostname=hostname, crt_path="/opt/certs/server.bundle.pem"))

open("/opt/haproxy/haproxy.cfg", "w").write(config)
os.system("service haproxy start")
