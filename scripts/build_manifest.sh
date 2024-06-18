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
        err_handler "$0" "$1 not found"
    fi
}

run_background_command() {
    if check_program "$1"; then
        log_file="log_$1_$(date +%Y%m%d%H%M%S)_$$.log"
        pid_file="pid_$1_$(date +%Y%m%d%H%M%S)_$$.log"
        log_path="$PWD/local_log/$log_file"
        pid_path="$PWD/local_log/$pid_file"
        $1 ${@:2} >"$log_path" &
        pid=$!
        echo "$pid" >>$pid_path
        echo "$1 backgrounded with pid:$pid p_pth: $pid_path l_path: $log_path"
    fi
}

wait_for_server() {
    local retries=5
    local wait_time=3 # wait 5 seconds between tries

    echo "Waiting for server to start on port "$1"..."
    until nc -z localhost $1; do
        retries=$((retries - 1))
        if [ $retries -le 0 ]; then
            echo "Server failed to start in time."
            exit 1
        fi
        sleep $wait_time
    done
    echo "Server is up and running on port $1."
}

comment_toml() {
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' '/^world_address/s/^/#/' "$1" #we need the '' for BSD sed
    else
        sed -i '/^world_address/s/^/#/' "$1"
    fi
}

uncomment_toml() {
    if [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' 's/^#world_address/world_address/' "$1" #we need the '' for BSD sed
    else
        sed -i '/^#world_address/world_address/' "$1"
    fi
}

# called with 2 params
# toml_path in $1
# wrld_addr in #2 where the addr_str is the new world_address
#add_new_address() {
#local filename="$1"
#local new_hex_string="$2"
#local new_line_content="world_address = \"$2\""
#if [[ "$(uname)" == "Darwin" ]]; then
#sed -i "" "/^world_address/s/.*/$new_line_content/" $filename
#else
#sed -i "/^world_address/s/.*/$new_line_content/" $filename
#fi
#}

#get_world_address() {
    #out=$(sozo migrate apply)
    #local status=$?

    #if [ $status -eq 0 ]; then
        #addr=$(echo "$out" | grep "Successfully migrated World" | awk '{print $NF}')
        #echo -n $addr
    #else
        #err_handler "$0" "$?"
    #fi
#}

cleanup() {
    local processes=("katana" "torii") # Example process names
    for process in "${processes[@]}"; do
        echo "PKILL $process..."
        pkill "$process" || echo "Failed to kill $process e: $?, continuing..."
    done
}

generate_manifest {
    echo "Compiling cairo files"
    run_command "sozo" "build"
    echo "Testing for local katana"
    if ! pgrep -x "katana" >/dev/null; then
        echo "Starting katana"
        comment_toml Scarb.toml
        run_background_command "katana" "--disable-fee"
        wait_for_server 5050
    fi
    echo "Generating manifest files"
    out=$(sozo migrate apply)
    local status=$?
    uncomment_toml Scarb.toml
    if [ $status -eq 0 ]; then
        echo "Generated manifest files"
        echo "$out"
        echo "Killing background processes"
        cleanup
    else
        err_handler "$0" "$?"
    fi
}

# Function to run the build chain
#run() {
    #echo "Starting build..."
    #run_command "sozo" "build"
    #echo "Testing for local katana"
    #if ! pgrep -x "katana" >/dev/null; then
        #echo "Starting katana"
        #comment_toml Scarb.toml
        #run_background_command "katana" "--disable-fee"
        #wait_for_server 5050
    #fi
    #echo "Getting world address"
    #ad=$(get_world_address)
    #echo "Found World Addr: $ad"
    #uncomment_toml Scarb.toml
    #echo "Amending Scarb.toml"
    #add_new_address Scarb.toml "$ad"
    #echo "Testing for torii"
    #if ! pgrep -x "torii"; then
        #echo "Starting torii with world $ad"
        #run_background_command "torii" "--world" "$ad"
        #wait_for_server 8080
    #fi
    #echo "build complete..."
    #popd >/dev/null
#}

err_handler() {
    popd >/dev/null
    echo "Command $1 \n\tfailed: $2"
    exit 1
}

# main entry point of script
generate_manifest 
