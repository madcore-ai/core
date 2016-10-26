import os, sys, redis, json
appname=sys.argv[1]

r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "apps"

i_data='{"apps":["%s"]}' % (appname)
r_server.set(i_key,i_data)
r_server.bgsave
