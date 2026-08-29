#!/usr/bin/env bash

harden_ssh() {
    local username="$1"

    echo "=== 20-ssh-hardening ==="

    check_user_ssh_key "$username"
    configure_ssh

    echo "[OK] SSH hardening terminé"
}


check_user_ssh_key() {
    local username="$1"
    local home_dir
    local authorized_keys

    echo "[INFO] Vérification de la clé SSH de $username..."

    if ! id "$username" >/dev/null 2>&1; then
        echo "[ERROR] L'utilisateur $username n'existe pas." >&2
        return 1
    fi

    home_dir="$(getent passwd "$username" | cut -d: -f6)"
    authorized_keys="$home_dir/.ssh/authorized_keys"

    if [[ ! -s "$authorized_keys" ]]; then
        echo "[ERROR] Aucune clé publique trouvée pour $username." >&2
        echo "[ERROR] Impossible de désactiver l'authentification par mot de passe." >&2
        return 1
    fi

    echo "[OK] Clé publique trouvée pour $username"
}


configure_ssh() {
    local config="/etc/ssh/sshd_config.d/99-hardening.conf"

    echo "[INFO] Application du hardening SSH..."

    cat > "$config" <<'EOF'
# Managed by provisioning script

PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

    chmod 644 "$config"

    echo "[INFO] Validation de la configuration SSH..."

    sshd -t

    echo "[INFO] Redémarrage de SSH..."

    systemctl restart ssh

    echo "[OK] Configuration SSH appliquée"
}