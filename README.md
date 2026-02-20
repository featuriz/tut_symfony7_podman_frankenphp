# **FZ CMS**

## Overview

This is a DEMO project for https://github.com/dunglas/symfony-docker

## Technologies Used

| Technology     | Version | Purpose          |
| -------------- | ------- | ---------------- |
| Symfony        | 7.4     | Web framework    |
| FrankenPHP     | 1.11.2  | PHP runtime      |
| PHP            | 8.5     | PHP              |
| Podman Compose | 5.7.1   | Containerization |

## BEFORE using FrankenPHP

- https://symfony.com/doc/7.4/setup.html
- `symfony check:requirements`
- `symfony new fz_cms --version="7.4.*" --webapp`
- `cd fz_cms`
- `symfony server:start`
- `php bin/console about`

## FrankenPHP

- https://github.com/dunglas/symfony-docker/blob/main/README.md
- https://github.com/dunglas/symfony-docker/blob/main/docs/existing-project.md

### What I have done

- Copied files/folders
  - frankenphp # folder
  - .dockerignore
  - .editorconfig
  - .gitattributes
  - Dockerfile
  - compose.override.yaml
  - compose.prod.yaml
  - compose.yaml
- Modified files to run
  - Removed MERCURE
  - Removed SSL auto certificate
    - In frankenphp/Caddyfile: `auto_https off`
  - ports
    - Removed HTTPS(443), HTTP3
      - I use Traefik in my VPS. so no need for https
      - Traefik also provide auto SSL certificate
  - Removed Database
    - I have a container running **mariadb**
    - Connects throught Network **podman_network** - Check compose.yaml file

### DATABASE

`DATABASE_URL="mysql://fz_root:MARIADB_USER_fz_root_PASSWORD@mariadb:3306/DATABASE_NAME?serverVersion=12.1.2&charset=utf8mb4"`

Create databases and users for each website:

```sql
CREATE DATABASE fz_dphs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'fz_root'@'%' IDENTIFIED BY 'strong_password_here';
GRANT ALL PRIVILEGES ON featuriz_dphs.* TO 'fz_root'@'%';
FLUSH PRIVILEGES;
EXIT;
```

## PROJECT COMMANDS

### DEV

`podman-compose -p fzcms_f-dev --env-file .env.dev -f compose.yaml -f compose.override.yaml up -d --build --no-start`

- http://localhost:8080/

### PROD

`podman-compose -p fzcms_f-prod --env-file .env.prod -f compose.yaml -f compose.prod.yaml up -d --build --no-start`

- http://localhost:9090/

## ALL COMMANDS

- `podman ps -a`
- `podman start fzcms_frankenphp_dev`
- `podman start fzcms_frankenphp_prod`
- `podman logs -f fzcms_frankenphp_prod`
- `podman logs -f fzcms_frankenphp_dev`
- `podman stop fzcms_frankenphp_dev`
- `podman stop fzcms_frankenphp_prod`

## CHECK

- `podman ps -a` # Show all containers
- `podman images -a` # Show all images
- `podman system df` # Show complete resource summary

## WARNING: To clean everything

- !IMPORTANT: First run all the required containers
- `podman system prune -a` # This wont remove the running containers and images.

## WORKER

- https://github.com/dunglas/symfony-docker/commit/330ea245a1e0cb7390adde68167b922d393ba25a
- frankenphp/Caddyfile : worker {}
- compose.override.yaml : FRANKENPHP_WORKER_CONFIG: watch
- Dockerfile : FRANKENPHP_WORKER_CONFIG=watch
