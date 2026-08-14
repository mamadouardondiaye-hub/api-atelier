<?php

declare(strict_types=1);

/**
 * Base de données : la même base 'bibliotheque' que le projet web.
 * Le tableau (users, categories, books, borrows, roles) est créé par
 * bibliotheque/database/schema.sql (ou seed.php).
 *
 * Adapte 'user' et 'password' à ton installation PostgreSQL locale.
 */
return [
    'host'     => 'localhost',
    'port'     => 5432,
    'dbname'   => 'bibliotheque',
    'user'     => 'postgres',
    'password' => 'postgres',
];
