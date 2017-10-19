CREATE USER "keycloak-user" WITH PASSWORD 'keycloak';
CREATE DATABASE "keycloak-db";
GRANT ALL PRIVILEGES ON DATABASE "keycloak-db" TO "keycloak-user";
