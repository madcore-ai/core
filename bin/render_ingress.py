import sys, os, json, jinja2, redis
from jinja2 import Template

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
json_data = r_server.get(i_key)
if json_data is not None:
    data = json.loads(json_data)
    main_domain = data['Hostname']

fqdn = sys.argv[1] + "ext." + main_domain

config_template = open('/opt/madcore/bin/templates/ingress.template').read()
template = Template(config_template)
config = (template.render(HOST=fqdn, SERVICE_NAME=sys.argv[2], SERVICE_PORT=sys.argv[3], NAMESPACE=sys.argv[4]))
open("/opt/ingress/" + sys.argv[2] + ".yaml", "w").write(config)
