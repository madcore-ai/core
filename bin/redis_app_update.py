import os, sys, redis, json

r_server = redis.StrictRedis('127.0.0.1', db=2)
app_key = "apps"
x = r_server.get(app_key)
app_info = json.loads(x)
app = 'test'

element = '[{"name":"%s", "port":"8880"}]' % app
el = json.loads(element)

app_info = app_info + el

print "\n\n"

z = json.dumps(app_info)


print z




#for app in app_info:
#    i = ", DNS:" + app["name"] + "." + owner_info["Hostname"]
#    apps_string = apps_string + i





#r_server.set(i_key,i_data)
#r_server.bgsave
