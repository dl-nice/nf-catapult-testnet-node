#!/bin/bash

# NODE_IP defaults to 'api-node-0' in local environment
ADDRESSES_PATH=$1
CONFIG_PATH=$2
NODE_IP=${3:-api-node-0}

# read private keys
PRIVKEY_API_NODE=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 1 'private key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PRIVKEY_PEER_NODE=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 2 'private key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PRIVKEY_HARVEST=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 3 'private key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PRIVKEY_REST=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 4 'private key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`

# read public keys
PUBKEY_API_NODE=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 1 'public key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PUBKEY_PEER_NODE=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 2 'public key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PUBKEY_HARVEST=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 3 'public key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`
PUBKEY_REST=`/bin/cat ${ADDRESSES_PATH}/raw-addresses.txt | /bin/grep -m 4 'public key:' | /usr/bin/awk '{print $3}' | /usr/bin/tail -1`

# configure api-node-0
## 1) change NODE_IP if not local
## 2) set bootKey
## 3) register neighboor peer node
## 4) register neighboor api node (self)
/bin/sed -i -e "s/api-node-0/${NODE_IP}/" ${CONFIG_PATH}/api-node-0/userconfig/resources/config-node.properties
/bin/sed -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_API_NODE}/" ${CONFIG_PATH}/api-node-0/userconfig/resources/config-user.properties
/bin/sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" ${CONFIG_PATH}/api-node-0/userconfig/resources/peers-p2p.json
/bin/sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/api-node-0/userconfig/resources/peers-api.json

# configure peer-node-1
## 1) set harvestKey
## 2) set bootKey
## 3) register neighboor peer node (self)
## 4) register neighboor api node
/bin/sed -i -e "s/harvestKey =.*/harvestKey = ${PRIVKEY_HARVEST}/" ${CONFIG_PATH}/peer-node-1/userconfig/resources/config-harvesting.properties
/bin/sed -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_PEER_NODE}/" ${CONFIG_PATH}/peer-node-1/userconfig/resources/config-user.properties
/bin/sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" ${CONFIG_PATH}/peer-node-1/userconfig/resources/peers-p2p.json
/bin/sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/peer-node-1/userconfig/resources/peers-api.json

# configure rest-gateway-0
## 1) set harvestKey (clientPrivateKey)
## 2) set NODE_IP if not local
## 3) register neighboor api node
/bin/sed -i -e "s/\"clientPrivateKey\": \"\"/\"clientPrivateKey\": \"${PRIVKEY_HARVEST}\"/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json
/bin/sed -i -e "s/api-node-0/${NODE_IP}/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json
/bin/sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json

