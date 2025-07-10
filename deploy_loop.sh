#!/bin/bash

RPC_URL="https://ethereum-sepolia-rpc.publicnode.com"
ENV_FILE=".env"
CSV_FILE="data.csv"

# Make sure the .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found."
  exit 1
fi

# Initialize CSV file if not already present
if [ ! -f "$CSV_FILE" ]; then
  echo "Index,TxHash,ContractAddress,GasUsed" > "$CSV_FILE"
fi

# Loop through PRIVATE_KEY_1 to PRIVATE_KEY_20
for i in $(seq 1 20); do
  KEY_VAR="PRIVATE_KEY_$i"
  PRIVATE_KEY=$(grep "^$KEY_VAR=" "$ENV_FILE" | cut -d '=' -f2-)

  if [ -z "$PRIVATE_KEY" ]; then
    echo "⚠️  $KEY_VAR not found in .env"
    continue
  fi

  echo ""
  echo "=== Deploying with $KEY_VAR ==="

  # Step 1: Remove old vars
  rm -f ~/.config/hardhat-nodejs/vars.json

  # Step 2: Set SEPOLIA_RPC_URL
  echo "$RPC_URL" | npx hardhat vars set SEPOLIA_RPC_URL

  # Step 3: Set PRIVATE_KEY
  echo "$PRIVATE_KEY" | npx hardhat vars set PRIVATE_KEY

  # Step 4: Clear previous deployment
  rm -rf deployments/sepolia

  # Step 5: Deploy and capture output
  DEPLOY_OUTPUT=$(npx hardhat deploy --network sepolia)

  echo "$DEPLOY_OUTPUT"

  # Parse deployment result
  TX_HASH=$(echo "$DEPLOY_OUTPUT" | grep -oP 'tx:\s*\K(0x[a-fA-F0-9]+)')
  ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oP 'deployed at\s*\K(0x[a-fA-F0-9]+)')
  GAS_USED=$(echo "$DEPLOY_OUTPUT" | grep -oP 'with\s*\K([0-9]+)(?=\s*gas)')

  # Append to CSV
  if [ ! -z "$TX_HASH" ] && [ ! -z "$ADDRESS" ]; then
    echo "$i,$TX_HASH,$ADDRESS,$GAS_USED" >> "$CSV_FILE"
    echo "✅ Saved to $CSV_FILE"
  else
    echo "❌ Deployment failed or output parsing error"
  fi
done

echo ""
echo "🚀 All deployments complete."
