import redis, sys, os, json
r_server = redis.StrictRedis('127.0.0.1', db=2)
i_key = "owner-info"
x = r_server.get(i_key)
y = json.loads(x)
f=open('/etc/pki/tls/certs/openssl.cnf', 'wb')

f.write("[ req ]\ndefault_bits = 2048\ndefault_keyfile = key.pem \ndefault_md = md5 \nstring_mask = nombstr \ndistinguished_name = req_distinguished_name \nreq_extensions = v3_req\n\n")
f.write("[ req_distinguished_name ]\n0.organizationName = Organization Name (company)\norganizationalUnitName = Organizational Unit Name (department, division)\nemailAddress = Email Address\nemailAddress_max = 40\nlocalityName = Locality Name (city, district)\nstateOrProvinceName = State or Province Name (full name)\ncountryName = Country Name (2 letter code)\ncountryName_min = 2\ncountryName_max = 2\ncommonName = Common Name (hostname, IP, or your name)\ncommonName_max = 64\n")
f.write("O={0}\nOU={1}\nemailAddress={2}\nL={3}\nCN={4}\nC={5}\n\n".format(y['OrganizationName'], y['OrganizationalUnitName'] ,y['Email'], y['LocalityName'], y['Hostname'], y['Country']))
f.write("[ v3_req ]\nbasicConstraints = CA:FALSE\nkeyUsage = nonRepudiation, digitalSignature, keyEncipherment\nsubjectAltName = @SAN\n\n")
f.write("[ SAN ]\nsubjectAltName=DNS:controlbox.{0}, DNS:grafana.{0}, DNS:influxdb.{0}, DNS:jenkins.{0}, DNS:kubeapi.{0}, DNS:kubedash.{0}".format(y['Hostname']))
f.close

os.system("openssl req -nodes -newkey rsa:2048 -keyout /etc/pki/tls/certs/server.key -out  /etc/pki/tls/certs/server.csr -config /etc/pki/tls/certs/openssl.cnf -sha256 -batch -reqexts SAN")


