import redis, sys, os
r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
Hostname = sys.argv[1]
Email = sys.argv[2]
OrganizationName = sys.argv[3]
OrganizationalUnitName = sys.argv[4]
LocalityName = sys.argv[5]
Country  = sys.argv[6]
i_data='{"Hostname":"%s", "Email":"%s", "OrganizationName":"%s", "OrganizationalUnitName":"%s", "LocalityName":"%s", "Country":"%s"}' % (Hostname, Email, OrganizationName, OrganizationalUnitName, LocalityName, Country)
r_server.set(i_key,i_data)
r_server.set("need_CSR", "1")
r_server.bgsave