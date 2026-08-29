#!/usr/bin/env bash

create_user() {
    local username="$1"

    echo "=== 10-users ==="
    echo "[INFO] Configuration de l'utilisateur : $username"

    if id "$username" >/dev/null 2>&1; then
        echo "[INFO] L'utilisateur $username existe déjà"
    else
        echo "[INFO] Création de l'utilisateur..."

        useradd \
            --create-home \
            --shell /bin/bash \
            "$username"

        echo "[OK] Utilisateur $username créé"
    fi

    setup_ssh "$username"
}


setup_ssh() {
    local username="$1"
    local home_dir

    home_dir="$(getent passwd "$username" | cut -d: -f6)"

    echo "[INFO] Configuration SSH..."

    install -d \
        -m 700 \
        -o "$username" \
        -g "$username" \
        "$home_dir/.ssh"

    touch "$home_dir/.ssh/authorized_keys"

    chmod 600 "$home_dir/.ssh/authorized_keys"
    chown "$username:$username" "$home_dir/.ssh/authorized_keys"

    echo "[OK] SSH configuré pour $username"
}