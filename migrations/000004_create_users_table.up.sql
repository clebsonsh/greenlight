CREATE TABLE IF NOT EXISTS users (
    id            bigserial        PRIMARY KEY,
    created_at    timestamp(0)     WITH TIME ZONE NOT NULL DEFAULT NOW(),
    name          text             NOT NULL,
    email         citext           NOT NULL UNIQUE,
    password_hash bytea            NOT NULL,
    activated     boolean          NOT NULL,
    version       integer          NOT NULL DEFAULT 1
);
