#!/bin/bash

set -euo pipefail

log_dir="/var/log/SysAdmin-Logs"
log_file=("updates.log" "install.log" "users.log" "software.log")

function validate_root() {
        if [[ $EUID -ne 0 ]]; then
                echo "This script must run as root" >&2
                exit 1
        fi
}

function validate_path() {
        if [[ ! -d "log_dir" ]]; then
                echo "Path does not exist"
                echo "Creating path"
                mkdir -v -p "$log_dir"
        fi        
}

function validate_files() {
        for i in "${log_file[@]}"; do
                if [[ ! -e "$log_dir/$i" ]]; then
                        echo "File $i does not exist"
                        echo "Creating file $i"
                        touch "$log_dir/$i"
                fi
        done
}

validate_root
validate_path
validate_files

