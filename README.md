<!--
====================================================================
MODÈLE DE README — un par dépôt de phase.

À remplir PENDANT le projet, pas à la fin : les arbitrages s'oublient
en quelques jours.

Chaque section répond à une question que se pose le lecteur (client,
recruteur, lead technique) qui accorde ~90 secondes à ton dépôt :

  Titre + accroche  → « C'est quoi, en une phrase ? »
  Le problème       → « Ça sert à quoi ? Quel problème réel ? »
  Le résultat       → « Qu'est-ce que ça produit concrètement ? »
  Structure         → « Comment c'est fait ? »
  Décisions         → « Est-ce que ce type réfléchit, ou a-t-il suivi un tuto ? »

La section « Décisions et arbitrages » est celle qui fait la différence.
Si tu ne dois en soigner qu'une, c'est celle-là.

--------------------------------------------------------------------
CE QUE « STRUCTURE / ARCHITECTURE » VEUT DIRE SELON LA PHASE :

  Phase 1 — script bootstrap : liste ordonnée des étapes + état final
            du serveur (composants et versions). Pas de diagramme.
  Phase 2 — stack Docker : schéma des conteneurs et de leurs liens +
            tableau des étapes du build multi-étapes.
  Phase 3 — architecture AWS : vrai diagramme avec icônes AWS
            (VPC, zones, sous-réseaux, flux).
  Phase 4 — Terraform : arbre des modules et dépendances + diagramme
            de l'infrastructure produite.
  Phase 5 — CI/CD : diagramme du pipeline (déclencheurs, étapes,
            portes d'approbation, chemin de rollback).
  Phase 6 — EKS : schéma du cluster (namespaces, deployments, ingress,
            chemin IRSA).
  Phase 7 — observabilité : flux de télémétrie
            (source → collecte → stockage → visualisation → alerte).

Outils : Mermaid (rendu nativement par GitHub, le plus maintenable),
Excalidraw, diagrams.net + AWS Architecture Icons.
====================================================================
-->

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
    └── 10-users.sh

## Décisions et arbitrages

| Décision | Alternative écartée | Pourquoi |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

Trois à cinq lignes. Chaque ligne doit contenir une alternative réelle, pas un
homme de paille.

> **Si rien ne te vient :** relis ton `journal.md` de la phase. Chaque ligne
> « Bloqué » est une décision déguisée — tu as buté, cherché, choisi.

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
