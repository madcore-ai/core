import redis

r_server = redis.StrictRedis('127.0.0.1', db=2)







r_server.set(i_key,i_data)


x = r_server.get(i_key)

r_server.delete(i_key)

keys = r_server.keys('*')

