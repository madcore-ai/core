import json
import sys

import redis

r_server = redis.StrictRedis('127.0.0.1', db=2)
app_key = "apps"
app_info = json.loads(r_server.get(app_key))
app_name = sys.argv[1]
app_port = sys.argv[2]
check = False

for app in app_info:
    if app["name"] == app_name:
        check = True
        break

if not check:
    element = '[{"name":"%s", "port":"%s"}]' % (app_name, app_port)
    el = json.loads(element)
    app_info.extend(el)
    app_data = json.dumps(app_info)
    r_server.set(app_key, app_data)
    r_server.set("need_CSR", "1")
    r_server.bgsave()

else:
    r_server.set("need_CSR", "0")
    r_server.bgsave()
