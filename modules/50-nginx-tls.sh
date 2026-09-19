#!/usr/bin/env bash

install_nginx() {
    echo "[INFO] Installation de Nginx..."

    if command -v nginx >/dev/null 2>&1; then
        echo "[INFO] Nginx est déjà installé"
    else
        apt-get update
        apt-get install -y nginx
    fi

    systemctl enable nginx
    systemctl start nginx

    echo "[OK] Nginx installé"
}


install_certbot() {
    echo "[INFO] Installation de Certbot..."

    if command -v certbot >/dev/null 2>&1; then
        echo "[INFO] Certbot est déjà installé"
    else
        apt-get update
        apt-get install -y certbot python3-certbot-nginx
    fi

    echo "[OK] Certbot installé"
}


configure_nginx_http() {
    local domain="$1"
    local upstream="$2"
    local config="/etc/nginx/sites-available/$domain"
    local enabled="/etc/nginx/sites-enabled/$domain"

    echo "[INFO] Configuration HTTP de Nginx..."

    cat > "$config" <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name $domain;

    location / {
        proxy_pass http://$upstream;

        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

    ln -sf "$config" "$enabled"

    rm -f /etc/nginx/sites-enabled/default

    nginx -t
    systemctl reload nginx

    echo "[OK] Configuration HTTP créée"
}


obtain_certificate() {
    local domain="$1"
    local email="$2"

    echo "[INFO] Obtention du certificat TLS..."

    certbot \
        --nginx \
        --non-interactive \
        --agree-tos \
        --redirect \
        --no-eff-email \
        --email "$email" \
        -d "$domain"

    echo "[OK] Certificat TLS installé"
}


configure_security_headers() {
    local domain="$1"
    local config="/etc/nginx/sites-available/$domain"

    echo "[INFO] Ajout des headers de sécurité..."

    if ! grep -q 'X-Content-Type-Options' "$config"; then

        sed -i '/server_name '"$domain"';/a\
\
    add_header X-Content-Type-Options "nosniff" always;\
    add_header X-Frame-Options "SAMEORIGIN" always;\
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;\
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;' "$config"

    else
        echo "[INFO] Les headers de sécurité sont déjà présents"
    fi

    nginx -t
    systemctl reload nginx

    echo "[OK] Headers de sécurité configurés"
}


test_certificate_renewal() {
    echo "[INFO] Test du renouvellement automatique..."

    certbot renew --dry-run

    echo "[OK] Test de renouvellement terminé"
}


configure_nginx_tls() {
    local domain="$1"
    local upstream="$2"
    local email="$3"

    echo "=== 50-nginx-tls ==="

    install_nginx
    install_certbot

    configure_nginx_http "$domain" "$upstream"

    obtain_certificate "$domain" "$email"

    configure_security_headers "$domain"

    test_certificate_renewal

    echo "[OK] Nginx + TLS configurés"
}