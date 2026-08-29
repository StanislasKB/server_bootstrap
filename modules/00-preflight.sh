#!/usr/bin/env bash

preflight() {
    echo "=== 00-preflight ==="

    check_os
    check_architecture
    check_connectivity

    echo "[OK] Preflight terminé"
}


check_os() {
    echo "[INFO] Vérification du système..."

    if [[ ! -f /etc/os-release ]]; then
        echo "[ERROR] Impossible de déterminer l'OS." >&2
        return 1
    fi

    source /etc/os-release

    echo "[INFO] OS : $PRETTY_NAME"

    case "$ID" in
        ubuntu|debian)
            echo "[OK] OS supporté"
            ;;
        *)
            echo "[ERROR] OS non supporté : $ID" >&2
            return 1
            ;;
    esac
}


check_architecture() {
    echo "[INFO] Vérification de l'architecture..."

    local arch
    arch="$(uname -m)"

    echo "[INFO] Architecture : $arch"

    case "$arch" in
        x86_64|aarch64)
            echo "[OK] Architecture supportée"
            ;;
        *)
            echo "[ERROR] Architecture non supportée : $arch" >&2
            return 1
            ;;
    esac
}


check_connectivity() {
    echo "[INFO] Vérification de la connectivité..."

    if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
        echo "[OK] Connectivité réseau disponible"
    else
        echo "[ERROR] Pas de connectivité réseau." >&2
        return 1
    fi
}