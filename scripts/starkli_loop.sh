#!/bin/bash

# The Objective of this script is to mint a batch of tokens to the Katana account 
# and then transfer them to the tal-valdar's account 
# this is for the Katana/Slot

# Initial u256 value
U256_VALUE=2

# Number of iterations (set to infinite loop if needed)
ITERATIONS=50  # Change this to the number of times you want to run

for ((i=1; i<=ITERATIONS; i++))
do
    echo "Iteration $i: Running mint command..."
    starkli invoke 0x01dc981317c9b40a04229c3e48724704a428aa9582c29dabc41233cc564f1706 mint 0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfcec --rpc https://api.cartridge.gg/x/theoruggintrail/katana --account katana0
    
    echo "Mint command completed. Running transfer_from command with u256:$U256_VALUE..."
    starkli invoke 0x01dc981317c9b40a04229c3e48724704a428aa9582c29dabc41233cc564f1706 transfer_from 0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfcec 0x34ae3f2ba263ab26cce840e78c4b0b314f9412b40e78491c14846d58ae712c7 u256:$U256_VALUE --rpc https://api.cartridge.gg/x/theoruggintrail/katana --account katana0
    
    # Increase the u256 value for the next iteration
    ((U256_VALUE++))

    echo "Iteration $i completed. Waiting for next cycle..."
    sleep 5  # Adjust sleep time if needed to avoid rate limits
done