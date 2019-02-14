
#RSA KEY

# Generate an RSA private key and convert it to PKCS8 wraped in PEM
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform pem -outform pem -nocrypt -out rsa.key

# Generate a certificate signing request with the private key
openssl req -new -key rsa.key -out rsa.csr

# Sign request with private key
openssl x509 -req -days 10000 -in rsa.csr -signkey rsa.key -out rsa.crt -set_serial 12345



SSH

ssh-keygen -t rsa -b 4096 -C "marvindaviddiaz@diaz-hp"
ssh-copy-id root@192.168.1.100

#Different Storage

ssh-keygen -t rsa -b 4096 -C "mediaserver" -f /home/marvin/Downloads/id_rsa
ssh-copy-id -i /home/marvin/Downloads/id_rsa root@91.218.115.139
ssh -i /home/marvin/Downloads/id_rsa root@91.218.115.139

#Your Id will be storage on ~/.ssh/authorized_keys in the remote server.
