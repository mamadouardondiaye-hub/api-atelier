-- =============================================================
-- API Bibliothèque — table des tokens d'accès
-- A exécuter sur la base 'bibliotheque' (déjà créée par le projet web).
-- Adapté pour PostgreSQL.
-- =============================================================

CREATE TABLE IF NOT EXISTS api_tokens (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    token_hash CHAR(64) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
