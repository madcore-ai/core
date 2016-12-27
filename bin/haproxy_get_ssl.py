#!/usr/bin/env python  
from StringIO import StringIO

import json
import os
import pycurl
import redis
import sys
from jinja2 import Template

r_server = redis.StrictRedis('127.0.0.1', db=2)
check = r_server.get("need_CSR")
if check == None:
    print "need run registration job"

if len(sys.argv) > 1:
    need_haproxy = sys.argv[1]
else:
    need_haproxy = 'no'

#### get hostname
try:
    buffer = StringIO()
    c = pycurl.Curl()
    c.setopt(c.URL, 'http://169.254.169.253/latest/meta-data/public-hostname')
    c.setopt(pycurl.CONNECTTIMEOUT, 5)
    c.setopt(c.WRITEDATA, buffer)
    c.perform()
    c.close()
    hostname = buffer.getvalue()
except:
    hostname = "localhost"

i_key = "owner-info"
json_data = r_server.get(i_key)
if json_data != None:
    data = json.loads(json_data)
    email = data['Email']
    hostname = data['Hostname']
frontend_conf = ""
backend_conf = ""
acl = ""
redirect = ""

if check == "1":
    #### get certificate
    if os.environ["ENV"] == 'AWS':
        os.system("mkdir -p /opt/certs/letsencrypt")
        os.system("cd /opt/certs && openssl req -inform pem -outform der -in server.csr -out ./letsencrypt/server.der")
        request = (
        "cd /opt/certs/letsencrypt && letsencrypt certonly --csr server.der --standalone --non-interactive --agree-tos --email %s --standalone-supported-challenges http-01" % email)
        os.system(request)
        os.system(" cd /opt/certs/letsencrypt && cat 0001_chain.pem ../server.key > ../server.bundle.pem")
        os.system("rm -rf /opt/certs/letsencrypt")
        r_server.set("need_CSR", "0")
        r_server.bgsave
else:
    print "Don't need new certificate"

### reconfigure haproxy
if (check == "1") or (need_haproxy == "yes"):

    app_key = "apps"
    data_apps = r_server.get(app_key)
    os.system("rm -rf /opt/haproxy/haproxy.cfg")
    config_template = open('/opt/madcore/bin/templates/haproxy.cfg').read()
    if os.environ["ENV"] == 'AWS':
        crt_path = "/opt/certs/server.bundle.pem"
    else:
        crt_path = "/etc/pki/tls/certs/server.bundle.pem"

    if data_apps:
        apps = json.loads(data_apps)
        for app in apps:
            if app["name"] == 'kubedash':
                ai = "acl is_%s hdr_end(host) -i %s.%s \n    " % (app["name"], app["name"], data["Hostname"])
                acl = acl + ai
                ri = "redirect  code 301 location https://kubeapi.%s/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/ if is_%s \n    " % (
                data["Hostname"], app["name"])
                redirect = redirect + ri
            elif app["name"] == 'grafana':
                ai = "acl is_%s hdr_end(host) -i %s.%s \n    " % (app["name"], app["name"], data["Hostname"])
                acl = acl + ai
                ri = "redirect  code 301 location https://kubeapi.%s/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana/ if is_%s \n    " % (
                data["Hostname"], app["name"])
                redirect = redirect + ri
            elif app["name"] == 'spark':
                ai = "acl is_%s hdr_end(host) -i %s.%s \n    " % (app["name"], app["name"], data["Hostname"])
                acl = acl + ai
                ri = "redirect  code 301 location https://kubeapi.%s:8080/api/v1/proxy/namespaces/spark-cluster/services/spark-master:8080/ if is_%s \n    " % (
                data["Hostname"], app["name"])
                redirect = redirect + ri
            elif app["name"] == 'zeppelin':
                ai = "acl is_%s hdr_end(host) -i %s.%s \n    " % (app["name"], app["name"], data["Hostname"])
                acl = acl + ai
                ri = "redirect  code 301 location https://kubeapi.%s:8080/api/v1/proxy/namespaces/spark-cluster/services/zeppelin/ if is_%s \n    " % (
                data["Hostname"], app["name"])
                redirect = redirect + ri
            else:
                i = "use_backend %s if { hdr_end(host) -i %s }\n    " % (
                app["name"], app["name"] + "." + data['Hostname'])
                frontend_conf = frontend_conf + i
                i = ("backend %s\n    balance roundrobin\n    server %s 127.0.0.1:%s check\n  " % (
                app["name"], app["name"], app["port"]))
                backend_conf = backend_conf + i
        template = Template(config_template)
        config = (
        template.render(hostname=hostname, crt_path=crt_path, subdomain=frontend_conf, backend=backend_conf, acl=acl,
                        redirect=redirect))
    else:
        template = Template(config_template)
        config = (template.render(hostname=hostname, crt_path=crt_path))

    open("/opt/haproxy/haproxy.cfg", "w").write(config)
    os.system("haproxy -f /opt/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)")

else:
    print "Don't need reconfigure HAproxy"
