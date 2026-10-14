#!/bin/bash

validate_root() {
        if [[ $EUID -ne 0 ]]; then
                echo "This script must run as root" >&2
                exit 1
        fi
}

update() {

        echo "Updating and upgrading system"

        if ! sudo apt update -y; then
                echo "Update Failed"
                exit 1
        fi

        echo "Update Completed"

        if ! sudo apt upgrade -y; then
                echo "Upgrade failed"
                exit 1
        fi

        echo "Upgrade Completed"

}

snmp_install() {

        installations=("snmpd", "snmp", "snmp-mibs-downloader")

        for i in "${installations[@]}"; do

                echo "Checking if $i is installed..."

                if command -v $i >/dev/null 2>&1; then
                        echo "$i is installed"
                else
                        echo "Installing $i"

                        if ! apt-get install -y $i; then
                                echo "$i failed to install"
                                exit 1
                        fi

                        echo "$i installation compelted"
                        $i --version
                fi
        done

}

validate_root
update
snmp_install      

