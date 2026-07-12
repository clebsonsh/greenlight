CREATE TABLE if NOT EXISTS permissions (id bigserial PRIMARY KEY, code text NOT NULL);

CREATE TABLE if NOT EXISTS users_permissions (
  user_id bigserial NOT NULL REFERENCES users ON DELETE cascade,
  permission_id bigserial NOT NULL REFERENCES permissions ON DELETE cascade,
  PRIMARY KEY (user_id, permission_id)
);

INSERT INTO permissions (code)
VALUES
    ('movies:read'),
    ('movies:write');
