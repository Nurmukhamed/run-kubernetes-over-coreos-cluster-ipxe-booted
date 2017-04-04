#!/bin/bash

#Create a Cluster Root CA
openssl genrsa -out ssl/ca/ca-key.pem 2048
openssl req -x509 -new -nodes -key ssl/ca/ca-key.pem -days 10000 -out ssl/ca/ca.pem -subj "/CN=kube-ca"

cat <<EOF>ssl/worker-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = \$ENV::WORKER_IP
EOF

echo "Generating keys for a-coreos.nurm.local"
#Kubernetes API Server keypair
cat <<EOF>ssl/a/openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
DNS.5 = a-coreos.nurm.local
IP.1 = 10.3.0.1
IP.2 = 192.168.10.18
EOF

openssl genrsa -out ssl/a/apiserver-key.pem 2048
openssl req -new -key ssl/a/apiserver-key.pem -out ssl/a/apiserver.csr -subj "/CN=kube-apiserver" -config ssl/a/openssl.cnf
openssl x509 -req -in ssl/a/apiserver.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/a/apiserver.pem -days 365 -extensions v3_req -extfile ssl/a/openssl.cnf

#Kubernetes Worker Keypair

WORKER_FQDN=a-coreos.nurm.local
WORKER_IP=192.168.10.18
openssl genrsa -out ssl/a/${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP=${WORKER_IP} openssl req -new -key ssl/a/${WORKER_FQDN}-worker-key.pem -out ssl/a/${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config ssl/worker-openssl.cnf
WORKER_IP=${WORKER_IP} openssl x509 -req -in ssl/a/${WORKER_FQDN}-worker.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/a/${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile ssl/worker-openssl.cnf

echo "Generating keys for b-coreos.nurm.local"
echo
#Kubernetes API Server keypair
cat <<EOF>ssl/b/openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
DNS.5 = b-coreos.nurm.local
IP.1 = 10.3.0.1
IP.2 = 192.168.10.19
EOF

openssl genrsa -out ssl/b/apiserver-key.pem 2048
openssl req -new -key ssl/b/apiserver-key.pem -out ssl/b/apiserver.csr -subj "/CN=kube-apiserver" -config ssl/b/openssl.cnf
openssl x509 -req -in ssl/b/apiserver.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/b/apiserver.pem -days 365 -extensions v3_req -extfile ssl/b/openssl.cnf

#Kubernetes Worker Keypair

WORKER_FQDN=b-coreos.nurm.local
WORKER_IP=192.168.10.19
openssl genrsa -out ssl/b/${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP=${WORKER_IP} openssl req -new -key ssl/b/${WORKER_FQDN}-worker-key.pem -out ssl/b/${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config ssl/worker-openssl.cnf
WORKER_IP=${WORKER_IP} openssl x509 -req -in ssl/b/${WORKER_FQDN}-worker.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/b/${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile ssl/worker-openssl.cnf

echo "Generating keys for c-coreos.nurm.local"
echo
#Kubernetes API Server keypair
cat <<EOF>ssl/c/openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
DNS.5 = c-coreos.nurm.local
IP.1 = 10.3.0.1
IP.2 = 192.168.10.20
EOF

openssl genrsa -out ssl/c/apiserver-key.pem 2048
openssl req -new -key ssl/c/apiserver-key.pem -out ssl/c/apiserver.csr -subj "/CN=kube-apiserver" -config ssl/c/openssl.cnf
openssl x509 -req -in ssl/c/apiserver.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/c/apiserver.pem -days 365 -extensions v3_req -extfile ssl/c/openssl.cnf

#Kubernetes Worker Keypair

WORKER_FQDN=c-coreos.nurm.local
WORKER_IP=192.168.10.20
openssl genrsa -out ssl/c/${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP=${WORKER_IP} openssl req -new -key ssl/c/${WORKER_FQDN}-worker-key.pem -out ssl/c/${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config ssl/worker-openssl.cnf
WORKER_IP=${WORKER_IP} openssl x509 -req -in ssl/c/${WORKER_FQDN}-worker.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/c/${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile ssl/worker-openssl.cnf


echo "Generate Admins keys"
echo

openssl genrsa -out ssl/admin/admin-key.pem 2048
openssl req -new -key ssl/admin/admin-key.pem -out ssl/admin/admin.csr -subj "/CN=kube-admin"
openssl x509 -req -in ssl/admin/admin.csr -CA ssl/ca/ca.pem -CAkey ssl/ca/ca-key.pem -CAcreateserial -out ssl/admin/admin.pem -days 365

