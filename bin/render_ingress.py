import sys, os, json, jinja2
from jinja2 import Template

config_template = open('/opt/madcore/bin/templates/ingress.template').read()
template = Template(config_template)
config = (template.render(HOST=sys.argv[1], SERVICE_NAME=sys.argv[2], SERVICE_PORT=sys.argv[3]))
open("/opt/ingress/" + sys.argv[2] + ".yaml", "w").write(config)
