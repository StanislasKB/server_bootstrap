#!/usr/bin/env bash

install_php() {
    echo "=== 40-php ==="


    install_sury_repository
    install_php_packages
    configure_php_pool

    echo "[OK] PHP 8.4 configuré"
}


install_sury_repository() {
    echo "[INFO] Installation des prérequis pour le dépôt Sury..."

    apt-get update

    apt-get install -y \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        wget

    echo "[INFO] Ajout du dépôt Sury..."

    wget -qO /tmp/debsuryorg-archive-keyring.deb \
        https://packages.sury.org/debsuryorg-archive-keyring.deb

    dpkg -i /tmp/debsuryorg-archive-keyring.deb

    echo "[INFO] Ajout de la source Sury..."

    wget -qO /etc/apt/sources.list.d/php.sources \
        https://packages.sury.org/php/apt.gpg

    apt-get update

    echo "[OK] Dépôt Sury configuré"
}

install_php_packages() {
    echo "[INFO] Installation de PHP 8.4 et des extensions Laravel..."

    apt-get install -y \
        php8.4 \
        php8.4-fpm \
        php8.4-cli \
        php8.4-common \
        php8.4-mysql \
        php8.4-pgsql \
        php8.4-mbstring \
        php8.4-xml \
        php8.4-curl \
        php8.4-zip \
        php8.4-bcmath \
        php8.4-intl \
        php8.4-gd \
        php8.4-opcache

    systemctl enable php8.4-fpm
    systemctl start php8.4-fpm

    echo "[OK] PHP 8.4 et extensions installés"
}


configure_php_pool() {
    local pool_name="laravel"
    local pool_file="/etc/php/8.4/fpm/pool.d/${pool_name}.conf"
    local socket="/run/php/php8.4-${pool_name}.sock"

    echo "[INFO] Configuration du pool PHP-FPM : $pool_name"

    cat > "$pool_file" <<EOF
[$pool_name]

user = www-data
group = www-data

listen = $socket

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 5

clear_env = no

catch_workers_output = yes
EOF

    chmod 644 "$pool_file"

    echo "[INFO] Vérification de la configuration PHP-FPM..."

    php-fpm8.4 -t

    echo "[INFO] Redémarrage de PHP-FPM..."

    systemctl restart php8.4-fpm

    echo "[OK] Pool $pool_name configuré"
}