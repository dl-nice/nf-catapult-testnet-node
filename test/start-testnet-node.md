
## Starting a nf-testnet node

There is a new cmds/ folder that has all the "commands" to run, this includes the previous original `clean-all` and `clean-data` commands

## Test Case 1

### Steps for Setup and Run

 1) ./cmds/setup-testnet-node
 2) ./cmds/start-catapult-peers
 3) ./cmds/start-api-db
 4) ./cmds/start-catapult-api-broker
 5) ./cmds/start-catapult-api

### Steps for Stop and Restart of API/Broker

 1) ctrl-c gracefull stop of the broker
 2) ctrl-c gracefull stop of the api + rest gateway
 3) `ls data/api-node-0` to verify there is no server.lock or broker.lock file, which means services shut down okay
 4) ./cmds/start-catapult-api-broker
 5) ./cmds/start-catapult-api

NOTE: observe the output of the broker log/console, see if it processes any new messages, in testing it appears 2 log messages about processing will be emitted and that is all, no new data written to mongo so is not accessible via the REST gateway
