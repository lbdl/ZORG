#!/bin/bash

# The Objective of this script is to log the owner of a token to a file. 
# This way we can check if the token is transferred to the correct account

# Initial u256 value
U256_VALUE=1  # Starting token ID for the owner_of call

# Log file path
LOG_FILE="starkli_owner_log.txt"

# Ensure the log file exists, create it if not
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Log file not found. Creating $LOG_FILE..."
    touch "$LOG_FILE"
fi

echo "Logging owner_of calls to $LOG_FILE"

for ((i=1; i<=50; i++))
do
    echo "Iteration $i: Checking owner of token u256:$U256_VALUE..."

    # Run the starkli call command and capture the output
    OWNER=$(starkli call 0x00e42c26b017863c5ad0b97373269398b9bc8bdbd6121d9c3705b644ffa29fe9 owner_of u256:$U256_VALUE --rpc https://api.cartridge.gg/x/theoruggintrail/katana | jq -r '.[0]')

    # Check if OWNER is empty (in case of an error)
    if [[ -z "$OWNER" ]]; then
        OWNER="ERROR: No response"
    fi

    # Append result to log file
    echo "id: $U256_VALUE owner: $OWNER" | tee -a "$LOG_FILE"

    # Increase the token ID for the next iteration
    ((U256_VALUE++))

    echo "Waiting for next check..."
    sleep 5  # Adjust the delay as needed
done

echo "Process completed. Log file saved at $LOG_FILE"