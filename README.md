# Zama FHE Protocol Technical Guides


## Environment
**Linux Ubuntu OS**
* **VPS**: You can use a linux VPS to follow the guide
* **Windows**: Install Linux Ubuntu using WSL by following this [guide](https://github.com/0xmoei/Install-Linux-on-Windows)
* **Codespace**: If you don't have VPS or Windows WSL, you can use [Github Codespace](https://github.com/codespaces), create a blank template and run your codes.

##Features
- Deploys a contract (FHECounter) to the Sepolia network for each private key.
- Reuses compile artifacts unless code has changed.
- Displays full transaction hash and deployed contract address.
- If a key is missing or .env has issues, the script skips the iteration safely and proceeds.
- Avoids redundant compilation or deployment if contract already exists.
- Accepts interactive `npx hardhat vars` set input via automated echo piping or subprocess input streams.


## Install Dependecies
```console
# Packages:
sudo apt update && sudo apt upgrade -y
sudo apt install screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev  -y

# Install Nodejs, npm, yarn
sudo apt update
sudo curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm install -g yarn
yarn -v

# Install Hardhat
sudo npm install -g hardhat
```

## Deploy FHECounter contract
```
git clone https://github.com/zama-ai/fhevm-hardhat-template
cd fhevm-hardhat-template
```

Install:
```
npm install
```

Replace `hardhat.config.ts` file:
```
curl -o hardhat.config.ts https://raw.githubusercontent.com/0xmoei/zama-fhe/refs/heads/main/hardhat.config.ts
```
Compile :
```
# Compile
npx hardhat compile
```
Edit ENV file
```
nano .env
```
Store your private keys without 0x in it.

#Make it executable:
```
chmod +x deploy_loop.sh
```
```
./deploy_loop.sh
```
