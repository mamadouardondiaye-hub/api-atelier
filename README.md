# Atelier API — Mamadou Ardo Ndiaye (ESP 221)

Reproduction fidèle de l'atelier API du prof (base : [bbabadara/ateliers-pratiques-php](https://github.com/bbabadara/ateliers-pratiques-php)/api),
**adaptée pour PostgreSQL** (le prof avait fait la version MySQL/MariaDB).

Architecture, routes, règles métier, tests : strictement identiques à l'original. Seule la couche
base de données a changé (schéma, DSN PDO, quelques littéraux SQL) — voir le détail plus bas.

## Structure

```
api/            L'API elle-même (mini-framework Core, Exceptions, Controllers, Services,
                Repositories, Middleware, routes, tests fonctionnels)
bibliotheque/   Uniquement ce dont l'API a besoin : le schéma + le seed de la base
                partagée (l'app web complète n'est pas reprise ici, seule l'API l'est)
```

## Lancer et tester

Prérequis : PHP 8.1+ avec l'extension `pdo_pgsql`, PostgreSQL actif.

```bash
# 1. Vérifier les identifiants dans bibliotheque/config/database.php et api/config/database.php
#    (par défaut : host=localhost, port=5432, user=postgres, password=postgres)

# 2. Créer la base + les données de démo
cd bibliotheque && php database/seed.php

# 3. Créer la table des tokens API
cd ../api && php database/seed.php

# 4. Lancer les 47 tests fonctionnels (sans serveur)
php tests/run.php

# 5. Démarrer l'API
php -S localhost:8001 -t public public/index.php
# puis http://localhost:8001/api/books
```

## Ce qui a changé pour PostgreSQL (rien d'autre)

- `schema.sql` / `api_tokens.sql` : `AUTO_INCREMENT` → `SERIAL`, `ENUM` → `CHECK`, retrait de
  `ENGINE = InnoDB` (n'existe pas en PostgreSQL), `DATETIME` → `TIMESTAMP`.
- Plus de `CREATE DATABASE IF NOT EXISTS` / `USE` (PostgreSQL ne les supporte pas) : `seed.php`
  se connecte d'abord à la base de maintenance `postgres` pour créer la base si besoin.
- DSN PDO : `mysql:...` → `pgsql:host=...;port=...;dbname=...`.
- Dans `BorrowRepository`, les littéraux `"en_cours"` / `"retourne"` (guillemets doubles) ont été
  remplacés par `'en_cours'` / `'retourne'` (guillemets simples) — en PostgreSQL les guillemets
  doubles désignent un **identifiant**, pas une chaîne de caractères comme en MySQL.
- `lastInsertId()` reçoit explicitement le nom de la séquence (ex. `'books_id_seq'`) pour un
  fonctionnement fiable avec PostgreSQL.
- `LIKE` → `ILIKE` dans la recherche de livres, pour garder une recherche insensible à la casse
  (comportement équivalent à la collation `utf8mb4_unicode_ci` de MySQL).

Aucune autre ligne (routes, contrôleurs, services, règles métier, middleware, tests) n'a été
modifiée par rapport à l'original du prof.
