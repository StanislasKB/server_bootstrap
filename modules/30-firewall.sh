#!/usr/bin/env bash

configure_firewall() {
    echo "=== 30-firewall ==="

    install_ufw
    configure_ufw

    echo "[OK] Firewall configuré"
}


install_ufw() {
    if command -v ufw >/dev/null 2>&1; then
        echo "[INFO] UFW est déjà installé"
        return 0
    fi

    echo "[INFO] Installation de UFW..."

    apt-get update
    apt-get install -y ufw

    echo "[OK] UFW installé"
}


configure_ufw() {
    echo "[INFO] Configuration du firewall..."

    ufw default deny incoming
    ufw default allow outgoing

    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp

    ufw --force enable

    echo "[OK] Règles UFW appliquées"

    ufw status verbose
}