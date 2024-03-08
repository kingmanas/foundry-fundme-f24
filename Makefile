# If we wantbto make shortcuts for our commands
-include .env

build:; forge build

deploy_sepolia:
   forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPCURL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_APIKEY) -vvvv