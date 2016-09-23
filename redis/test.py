import redis, sys

r_server = redis.StrictRedis('127.0.0.1', db=15)
ans = 0
while ans != 5:

	print 'choise operartions: \n 1. Write \n 2. Read \n 3. Delete \n 4. Show all keys \n 5. Exit'

	ans = int(input())



	if ans == 1:
		print ('enter key name')
		i_key = sys.stdin.readline()
		print 'enter data'
		i_data = sys.stdin.readline()
		r_server.set(i_key,i_data)
	

	if ans == 2:
		print ('enter key name')
		i_key = sys.stdin.readline()
		x = r_server.get(i_key)
		print x

	if ans == 3:
		print ('enter key name')
	        i_key = sys.stdin.readline()
		r_server.delete(i_key)

	if ans == 4:
		keys = r_server.keys('*')
		print keys

	if ans == 5:
		break
