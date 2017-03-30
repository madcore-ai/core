import sys, os, json, jinja2, redis
from jinja2 import Template

i_key = "owner-info"
r_server = redis.StrictRedis('127.0.0.1', db=2)
json_data = r_server.get(i_key)
if json_data is not None:
    data = json.loads(json_data)
    email = data['Email']

config_template = open('/opt/plugins/ingress/kub/lego_configmap.template').read()
template = Template(config_template)
config = (template.render(email=email))
open("/opt/plugins/ingress/kub/lego_configmap.yaml", "w").write(config)
