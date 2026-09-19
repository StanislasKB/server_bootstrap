# Server Bootstrap

> Transforme une instance Ubuntu vierge en serveur de production Laravel
> en une commande, de façon idempotente et auditable.


## Le problème

Chaque nouveau serveur client me coûtait 2 à 3 heures de configuration
manuelle, et aucun serveur n'était jamais identique au précédent : versions
de PHP différentes, durcissement SSH oublié une fois sur trois, scheduler
Laravel configuré de quatre façons selon la date. Résultat : impossible de
déboguer un serveur sans le redécouvrir entièrement.


## Le résultat

Sur une instance Ubuntu 24.04 vierge : serveur prêt en ~6 minutes, HTTPS
actif avec renouvellement automatique, note A sur SSL Labs, aucun accès
root par mot de passe, worker de queue et scheduler opérationnels.
Relançable autant de fois que voulu sans rien casser.


```bash
./bootstrap.sh --domain exemple.com --deploy-user deploy
```


## Structure / Architecture

server_bootstrap/
│
├── main.sh
│
└── modules/
    ├── 00-preflight.sh
    ├── 10-users.sh
    ├── 20-ssh-hardening.sh
    ├── 30-firewall.sh
    ├── 40-php.sh
    └── 50-nginx-tls.sh

Le script exécute les modules dans cet ordre, chacun idempotent :
 
| # | Module | Rôle |
|---|---|---|
| 00 | preflight | Vérifie l'OS, l'architecture, la connectivité |
| 10 | users | Crée l'utilisateur de déploiement, clés SSH |
| 20 | ssh-hardening | Désactive root et l'auth par mot de passe |
| 30 | firewall | UFW : 22/80/443 uniquement |
| 40 | php | PHP 8.4 + FPM + extensions Laravel, pool dédié |
| 50 | nginx-tls | Reverse proxy, certificat Let's Encrypt, en-têtes |


## Décisions et arbitrages

| Décision | Alternative écartée | Pourquoi |
|---|---|---|
| Dépôt Sury pour PHP | PPA ondrej | Le PPA ne suit plus les dernières
versions d'Ubuntu ; Sury est le dépôt maintenu en amont |




## Utilisation

```bash
# prérequis
# puis la ou les commandes
```

## Limites connues

- Ce que ça ne fait pas, et qui pourrait surprendre
- Ce que tu ferais différemment avec plus de temps ou de budget
- Ce qui est volontairement hors périmètre, et pourquoi

## Ce que j'en ai retiré

Trois lignes maximum. Techniques, pas émotionnelles.
