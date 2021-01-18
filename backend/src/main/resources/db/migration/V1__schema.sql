CREATE TABLE users
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);

CREATE TABLE tenants
(
    id      SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users (id)
);

CREATE TABLE forums
(
    -- id has two parts. The upper 32 bits duplicate tenant_id, and the lower 32 bits are unique per tenant
    id              BIGINT PRIMARY KEY,
    parent_id       BIGINT       NOT NULL REFERENCES forums (id),

    forum_id        INTEGER      NOT NULL,
    tenant_id       INTEGER      NOT NULL REFERENCES tenants (id),

    parent_forum_id INTEGER      NOT NULL,

    name            VARCHAR(256) NOT NULL,

    CHECK (id >> 32 = tenant_id),
    CHECK (id & x'FFFFFFFF'::INTEGER = forum_id),
    CHECK (parent_id & x'FFFFFFFF'::INTEGER = parent_forum_id),
    CHECK (parent_id >> 32 = tenant_id),
    -- forum 0 must be its own parent, and no other forum may be its own parent
    CHECK (
            (forum_id <> 0 AND (forum_id <> parent_forum_id)) OR
            (forum_id = 0 AND parent_forum_id = 0)
        )
);

CREATE TABLE threads
(
    id           BIGSERIAL PRIMARY KEY,
    forum_id     BIGINT       NOT NULL REFERENCES forums (id),
    title        VARCHAR(256) NOT NULL,
    created_time BIGINT       NOT NULL -- millis since epoch
);

CREATE TABLE posts
(
    id               BIGSERIAL PRIMARY KEY,
    thread_id        BIGINT  NOT NULL REFERENCES threads (id),
    author_id        INTEGER NOT NULL REFERENCES users (id),
    text             TEXT    NOT NULL,
    created_time     BIGINT  NOT NULL, -- millis since epoch
    last_edited_time BIGINT  NOT NULL  -- millis since epoch
);

CREATE TABLE post_old_versions
(
    id      BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL REFERENCES posts (id),
    text    TEXT   NOT NULL
);
