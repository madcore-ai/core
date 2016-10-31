import redis, sys, os, json, jinja2
from jinja2 import Template
r_server = redis.StrictRedis('127.0.0.1', db=2)
check = r_server.get("need_CSR")
if check == 1:
    i_key = "owner-info"
    app_key = "apps"
    x = r_server.get(i_key)
    y = r_server.get(app_key)
    owner_info = json.loads(x)
    app_info = json.loads(y)
    apps_string = ""

    for app in app_info:
	i = ", DNS:" + app["name"] + "." + owner_info["Hostname"]
        apps_string = apps_string + i

    config_template=open('/opt/controlbox/bin/templates/openssl.conf').read()
    template = Template(config_template)
    config = (template.render(OrganizationName=owner_info['OrganizationName'],OrganizationalUnitName=owner_info['OrganizationalUnitName'],Email=owner_info['Email'],LocalityName=owner_info['LocalityName'],Hostname=owner_info['Hostname'],Country=owner_info['Country'], apps=apps_string))
    open("/opt/certs/openssl.cnf", "w").write(config)

    os.system("openssl req -nodes -newkey rsa:2048 -keyout /opt/certs/server.key -out  /opt/certs/server.csr -config /opt/certs/openssl.cnf -sha256 -batch -reqexts SAN")
else:
    print "Dont need CSR"


