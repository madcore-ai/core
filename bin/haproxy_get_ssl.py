#!/usr/bin/env python  
import redis, sys, os, json, jinja2
from jinja2 import Template

r_server = redis.StrictRedis('127.0.0.1', db=2)
check = r_server.get("need_CSR")
if check == 1:
    i_key = "owner-info"
    data=json.loads (r_server.get(i_key))
    email = data['Email']
    hostname = data['Hostname']
    frontend_conf = ""
    backend_conf = ""


#### get certificate
    os.system("mkdir -p /opt/certs/letsencrypt")
    os.system("cd /opt/certs && openssl req -inform pem -outform der -in server.csr -out ./letsencrypt/server.der")
    os.system("service haproxy stop")
    request = ("cd /opt/certs/letsencrypt && letsencrypt certonly --csr server.der --standalone --non-interactive --agree-tos --email %s --standalone-supported-challenges http-01" % email)
    os.system(request)
    os.system(" cd /opt/certs/letsencrypt && cat 0001_chain.pem ../server.key > ../server.bundle.pem")
    os.system("rm -rf /opt/certs/letsencrypt")


### reconfigure haproxy
    app_key="apps"
    data_apps=r_server.get(app_key)
    os.system("rm -rf /opt/haproxy/haproxy.cfg")
    config_template=open('/opt/controlbox/bin/templates/haproxy.cfg').read()

    if data_apps:
	apps=json.loads(data_apps)
        for app in apps:
		i = "use_backend %s if { hdr_end(host) -i %s }\n    " % (app["name"], app["name"] + "." + data['Hostname']) 
	    frontend_conf = frontend_conf + i
		ii = ("backend %s\n    balance roundrobin\n    server %s 127.0.0.1:%s check\n    " % (app["name"], app["name"], app["port"]))
		backend_conf = backend_conf + ii
        template = Template(config_template)
	config = (template.render(hostname=hostname, crt_path="/opt/certs/server.bundle.pem", subdomain1=frontend_conf, backend2=backend_conf))
    else:
	template = Template(config_template)
        config = (template.render(hostname=hostname, crt_path="/opt/certs/server.bundle.pem"))

    open("/opt/haproxy/haproxy.cfg", "w").write(config)
    os.system("service haproxy start")
else:
    print "Don't need new certificate"
