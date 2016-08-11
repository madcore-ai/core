mkdir -p /etc/pki/tls/certs
echo "
[ req ]
default_bits = 2048 # Size of keys
default_keyfile = key.pem # name of generated keys
default_md = md5 # message digest algorithm
string_mask = nombstr # permitted characters
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
# Variable name   Prompt string
0.organizationName = Organization Name (company)
organizationalUnitName = Organizational Unit Name (department, division)
emailAddress = Email Address
emailAddress_max = 40
localityName = Locality Name (city, district)
stateOrProvinceName = State or Province Name (full name)
countryName = Country Name (2 letter code)
countryName_min = 2
countryName_max = 2
commonName = Common Name (hostname, IP, or your name)
commonName_max = 64

countryName_default = GB
localityName_default = London
0.organizationName_default = Rona Animation Studios
organizationalUnitName_default = Development
commonName_default = $SERVER" > /etc/pki/tls/certs/openssl.cnf

pushd /etc/pki/tls/certs
    sudo openssl genrsa -des3 -passout pass:TasWq -out serverPAS.key 2048
    sudo openssl req -new -key serverPAS.key -passin pass:TasWq -out server.csr -config openssl.cnf -batch
    sudo openssl x509 -req -days 365 -in server.csr -signkey serverPAS.key -passin pass:TasWq -out server.crt
    sudo openssl rsa -passin pass:TasWq -in serverPAS.key -out server.key
    cat server.crt server.key > server.bundle.pem
popd
