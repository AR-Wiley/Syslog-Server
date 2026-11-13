#!/bin/bash

set -euo pipefail

function validate_root() {

        if [[ $EUID -ne 0 ]]; then
                echo "You must be root to run this script" >&2
                exit 1
        fi
}

function validate_default() {

}

function validate_useradd() {



}

function main() {

        validate_root

        path="/etc/default/useradd"
        values=('HOME' 'INACTIVE' 'EXPIRE' 'SKEL' 'CREATE_MAIL_SPOOL')

        declare -A configs=(
                [HOME]="/home"
                [INACTIVE]=30
                [EXPIRE]=-1
                [SKEL]="/etc/skel"
                [CREATE_MAIL_SPOOL]="no"
        )

        for i in "${values[@]}"; do

                if grep -q "^${i}" "$path"; then
                        sed -i "s/^\(${i}[[:space:]]*\).*/\1 ${configs[$i]}/" "$path"
                else
                        echo "${i} ${configs[$i]}" >> "$path"
                fi
        done

}


main "$@"
