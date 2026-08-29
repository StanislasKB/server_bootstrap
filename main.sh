#!/bin/bash

set -euo pipefail

#traps
trap 'echo "[ERROR] Erreur à la ligne $LINENO: $BASH_COMMAND" >&2' ERR
trap 'echo "[INFO] Script Terminé..."' EXIT

#fonctions
usage(){
    echo "Usage: $0 --deploy-user USERNAME"
}

main(){
    local deploy_user=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --deploy-user)
                if [[ $# -lt 2 ]]; then
                    echo "[ERROR] --deploy-user nécessite un nom d'utilisateur." >&2
                    exit 1
                fi

                deploy_user="$2"
                shift 2
                ;;

            -h|--help)
                usage
                exit 0
                ;;

            *)
                echo "[ERROR] Argument inconnu : $1" >&2
                usage
                exit 1
                ;;
        esac
    done
    if [[ -z "$deploy_user" ]]; then
        echo "[ERROR] --deploy-user est obligatoire." >&2
        usage
        exit 1
    fi

    echo "=== Début de l'installation ==="
    echo "[INFO] Deploy user : $deploy_user"

    preflight
    create_user "$deploy_user"
    harden_ssh
    configure_firewall

    echo "=== Installation terminée ==="
    
}

#chargement de modules
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/00-preflight.sh"
source "$SCRIPT_DIR/modules/01-users.sh"
source "$SCRIPT_DIR/modules/20-ssh-hardening.sh"
source "$SCRIPT_DIR/modules/30-firewall.sh"

#execution
main "$@"
