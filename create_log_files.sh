#!/bin/bash

set -euo pipefail

log_dir="/var/log/SysAdmin-Logs"
log_files=("updates.log" "installs.logs" "removals.log"  "users.log" "software.log" "services.log" "firewall.log" "security.log" "network.log" "backups.log")

function validate_root() {

        if [[ $EUID -ne 0 ]]; then
                echo "This script must run as root" >&2
                exit 1
        fi
}

function validate_path() {

        local dir="$1"
        
        if [[ ! -d "$dir" ]]; then
                echo "Path does not exist"
                echo "Creating path"
                mkdir -v -p "$dir"
        fi        
}

function validate_files() {

        local dir="$1"
        shift
        local -a files=("$@")
        
        for i in "${files[@]}"; do
                if [[ ! -e "$dir/$i" ]]; then
                        echo "File $i does not exist"
                        echo "Creating file $i"
                        touch "$dir/$i"
                fi
        done
}

function main() {
    validate_root
    validate_path "$log_dir"
    validate_files "$log_dir" "${log_files[@]}"
}

main "$@"


