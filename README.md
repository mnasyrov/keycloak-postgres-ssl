# keycloak-postgres-ssl

_NOTE: For testing purposes, not production ready._

This docker image extends Keycloak for using with PostgreSQL 9.6 over SSL connection.
It is bundled with `postgresql-42.1.1.jre7.jar` JDBC driver.

Dockerfile was forked from [jboss/keycloak-postgres](1) repository.

[1]: https://github.com/jboss-dockerfiles/keycloak/tree/master/server-postgres


## Configuration

Docker container can be run with following environment variables:
* `KEYCLOAK_POSTGRES_HOST` - a hostname of Postgres database (optional, default is `postgres`).
    If SSL is used it must be a true domain name or IP address to validate a certificate, not linked docker container.
* `KEYCLOAK_POSTGRES_PORT` - a port of Postgres database (optional, default is `5432`).
* `KEYCLOAK_POSTGRES_DATABASE` - a database name (optional, default is `keycloak`).
* `KEYCLOAK_POSTGRES_USER` - a database user (optional, default is `keycloak`).
* `KEYCLOAK_POSTGRES_PASSWORD` - a database password (required).
* `KEYCLOAK_POSTGRES_SSL` - enables SSL connection (optional, default is `false`). Values: `true`, `false`.


## Usage examples

### Simple case

First start a PostgreSQL instance using the PostgreSQL docker image:

    docker run --name postgres -e POSTGRES_DATABASE=keycloak -e POSTGRES_USER=keycloak -e POSTGRES_PASSWORD=password -e POSTGRES_ROOT_PASSWORD=root_password -d postgres


Start a Keycloak instance and connect to the PostgreSQL instance:

    docker run --name keycloak --link postgres:postgres mnasyrov/keycloak-postgres-ssl


### Connecting to an external database

    docker run --name keycloak \
      -e KEYCLOAK_POSTGRES_HOST=db.example.com \
      -e KEYCLOAK_POSTGRES_SSL=true \
      -e KEYCLOAK_POSTGRES_USER=user \
      -e KEYCLOAK_POSTGRES_PASSWORD=password \
      mnasyrov/keycloak-postgres-ssl


## Building the image

    docker build -t mnasyrov/keycloak-postgres-ssl .


Push to a registry:

    docker push mnasyrov/keycloak-postgres-ssl
