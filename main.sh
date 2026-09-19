#!/bin/bash

set -euo pipefail

#traps
trap 'echo "[ERROR] Erreur à la ligne $LINENO: $BASH_COMMAND" >&2' ERR
trap 'echo "[INFO] Script Terminé..."' EXIT

#fonctions
usage() {
    echo "Usage:"
    echo "  $0 --deploy-user USER --domain DOMAIN --upstream HOST:PORT --email EMAIL"
    echo
    echo "Options:"
    echo "  --deploy-user USER     Utilisateur de déploiement"
    echo "  --domain DOMAIN        Nom de domaine"
    echo "  --upstream HOST:PORT   Backend vers lequel Nginx proxy"
    echo "  --email EMAIL          Email utilisé par Certbot"
    echo "  -h, --help             Afficher cette aide"
}

main(){
    local deploy_user=""
    local domain=""
    local upstream=""
    local email=""
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

    --domain)
        if [[ $# -lt 2 ]]; then
            echo "[ERROR] --domain nécessite un nom de domaine." >&2
            exit 1
        fi

        domain="$2"
        shift 2
        ;;

    --upstream)
        if [[ $# -lt 2 ]]; then
            echo "[ERROR] --upstream nécessite une adresse upstream." >&2
            exit 1
        fi

        upstream="$2"
        shift 2
        ;;

    --email)
        if [[ $# -lt 2 ]]; then
            echo "[ERROR] --email nécessite une adresse email." >&2
            exit 1
        fi

        email="$2"
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
    harden_ssh "$deploy_user"
    configure_firewall
    install_php
    configure_nginx_tls "$domain" "$upstream" "$email"

    echo "=== Installation terminée ==="
    
}

#chargement de modules
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/00-preflight.sh"
source "$SCRIPT_DIR/modules/01-users.sh"
source "$SCRIPT_DIR/modules/20-ssh-hardening.sh"
source "$SCRIPT_DIR/modules/30-firewall.sh"
source "$SCRIPT_DIR/modules/40-php.sh"
source "$SCRIPT_DIR/modules/50-nginx-tls.sh"

#execution
main "$@"
