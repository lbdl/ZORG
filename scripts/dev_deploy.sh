#!/bin/bash

set -euo pipefail

# Change the current working directory to the parent directory of the script
pushd "$(dirname "$0")/.." >/dev/null

# Function to check if a program exists
check_program() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: $1 is not installed."
    return 1
  else
    echo "Found $1"
    return 0
  fi
}

run_command() {
  if check_program "$1"; then
    if [ "$#" -gt 2 ] || [ "$#" -eq 2 ]; then
      echo "run cmd: -- $1 ${@:2} --"
      $1 ${@:2}
    fi
  else
    echo "$1 does not exist"
  fi
}

run_background_command() {
  if check_program "$1"; then
    log_file="log_$(date +%Y%m%d%H%M%S)_$$.log"
    pid_file="pid_$(date +%Y%m%d%H%M%S)_$$.log"
    log_path="$PWD/local_log/$log_file"
    pid_path="$PWD/local_log/$pid_file"
    $1 ${@:2} >"$log_path" &
    pid=$!
    echo "$pid" >> $pid_path
    echo "$1 backgrounded with pid:$pid p_pth: $pid_path l_path: $log_path"
  else
    echo "$1 not found"
  fi
}

get_world_address() {
  out=$()
}

# run_command "sozo"

# Function to run the build chain
run_build_chain() {
  echo "Starting build..."
  run_command "sozo" "build"
  run_background_command "katana" "--disable-fee"
  addr=get_world_address
  # Call other functions or commands here
}

run_build_chain
# Check if the program exists
# check_program "sozo"

# Run the program
# echo "Running sozo build..."

# sozo build

# Test the return code of the program
if [ $? -ne 0 ]; then
  echo "Error: Failed to run the program."
  exit 1
fi

# Run the build chain if the program ran successfully
# run_build_chain

echo "Script completed successfully."

# Restore the original working directory
popd >/dev/null
