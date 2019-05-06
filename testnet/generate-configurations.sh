#!/bin/bash

# NODE_IP defaults to 'api-node-0' in local environment
NODE_IP=${1:-api-node-0}

# read private keys
PRIVKEY_API_NODE=`cat build/generated-addresses/raw-addresses.txt | grep -m 1 'private key:' | awk '{print $3}' | tail -1`
PRIVKEY_PEER_NODE=`cat build/generated-addresses/raw-addresses.txt | grep -m 2 'private key:' | awk '{print $3}' | tail -1`
PRIVKEY_HARVEST=`cat build/generated-addresses/raw-addresses.txt | grep -m 3 'private key:' | awk '{print $3}' | tail -1`
PRIVKEY_REST=`cat build/generated-addresses/raw-addresses.txt | grep -m 4 'private key:' | awk '{print $3}' | tail -1`

# read public keys
PUBKEY_API_NODE=`cat build/generated-addresses/raw-addresses.txt | grep -m 1 'public key:' | awk '{print $3}' | tail -1`
PUBKEY_PEER_NODE=`cat build/generated-addresses/raw-addresses.txt | grep -m 2 'public key:' | awk '{print $3}' | tail -1`
PUBKEY_HARVEST=`cat build/generated-addresses/raw-addresses.txt | grep -m 3 'public key:' | awk '{print $3}' | tail -1`
PUBKEY_REST=`cat build/generated-addresses/raw-addresses.txt | grep -m 4 'public key:' | awk '{print $3}' | tail -1`

# configure api-node-0
## 1) change NODE_IP if not local
## 2) set bootKey
## 3) register neighboor peer node
## 4) register neighboor api node (self)
sed -i -e "s/api-node-0/${NODE_IP}/" build/catapult-config/api-node-0/userconfig/resources/config-node.properties
sed -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_API_NODE}/" build/catapult-config/api-node-0/userconfig/resources/config-user.properties
sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" build/catapult-config/api-node-0/userconfig/resources/peers-p2p.json
sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" build/catapult-config/api-node-0/userconfig/resources/peers-api.json

# configure peer-node-1
## 1) set harvestKey
## 2) set bootKey
## 3) register neighboor peer node (self)
## 4) register neighboor api node
sed -i -e "s/harvestKey =.*/harvestKey = ${PRIVKEY_HARVEST}/" build/catapult-config/peer-node-1/userconfig/resources/config-harvesting.properties
sed -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_PEER_NODE}/" build/catapult-config/peer-node-1/userconfig/resources/config-user.properties
sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" build/catapult-config/peer-node-1/userconfig/resources/peers-p2p.json
sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" build/catapult-config/peer-node-1/userconfig/resources/peers-api.json

# configure rest-gateway-0
## 1) set harvestKey (clientPrivateKey)
## 2) set NODE_IP if not local
## 3) register neighboor api node
sed -i -e "s/\"clientPrivateKey\": \"\"/\"clientPrivateKey\": \"${PRIVKEY_HARVEST}\"/" build/catapult-config/rest-gateway-0/userconfig/rest.json
sed -i -e "s/api-node-0/${NODE_IP}/" build/catapult-config/rest-gateway-0/userconfig/rest.json
sed -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" build/catapult-config/rest-gateway-0/userconfig/rest.json

