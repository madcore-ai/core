import os, sys, redis, json

r_server = redis.StrictRedis('127.0.0.1', db=2)
app_key = "apps"
x = r_server.get(app_key)
app_info = json.loads(x)
#appname=sys.argv[1]
appname="test"
#app_port=sys.argv[2]
app_port="2222"

for app in app_info:
    if app["name"] == appname:
	check = True


if not check:
    element = '[{"name":"%s", "port":"%s"}]' % (appname, app_port)
    el = json.loads(element)
    app_info.extend(el)
    app_data=json.dumps(app_info)
    r_server.set(app_key, app_data)
    r_server.set("need_CSR", "1")
    r_server.bgsave
    
else:
    r_server.set("need_CSR", "0")
    r_server.bgsave