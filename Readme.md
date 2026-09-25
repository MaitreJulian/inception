*This project has been created as part of the 42 curriculum by jvenkata.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small, containerized web infrastructure entirely by hand, using Docker and Docker Compose, following a strict set of constraints (no pre-built images except the base OS, one service per container, custom Dockerfiles, persistent named volumes, a dedicated Docker network, TLS-only access, and environment-based secrets).

The infrastructure is composed of three services, each running in its own container:

- **NGINX** — the single entry point to the infrastructure, reachable only on port 443, enforcing TLSv1.2 or TLSv1.3.
- **WordPress + php-fpm** — the WordPress site itself, served through php-fpm, without any embedded web server.
- **MariaDB** — the database backing the WordPress installation, without any embedded web server.

All three containers communicate over a dedicated Docker bridge network (`inception`) and are only reachable from the outside through NGINX on port 443. Two named volumes persist data on the host, under `/home/jvenkata/data/`:

- `mariadb` → the WordPress database
- `wordpress` → the WordPress site files

The domain `jvenkata.42.fr` is configured to resolve to the host machine, and serves as the single point of access to the site.

## Instructions

### Prerequisites

- A Linux virtual machine with Docker and Docker Compose installed.
- `jvenkata.42.fr` resolving to the host (locally via `/etc/hosts`, e.g. `127.0.0.1 jvenkata.42.fr`).

### Setup

1. Clone the repository.
2. Make sure `srcs/ressources.env` contains valid values for all required environment variables (database credentials, WordPress admin/user credentials, domain name — see `DEV_DOC.md` for the full list).
3. From the root of the repository, run:
   ```bash
   make
   ```
   This creates the host data directories, then builds and starts all three containers via Docker Compose.
4. Once the containers are up, open:
   ```
   https://jvenkata.42.fr
   ```
   in a browser (a self-signed certificate warning is expected and can be bypassed).

### Common commands

| Command | Effect |
|---|---|
| `make` | Build and start the full stack |
| `make down` | Stop and remove the containers |
| `make clean` | Stop containers and remove images/volumes |
| `make fclean` | Full cleanup, including host data directories |
| `make re` | `fclean` followed by `make` |

See `USER_DOC.md` for day-to-day usage (accessing the site/admin panel, managing credentials) and `DEV_DOC.md` for developer-oriented details (project layout, Compose internals, data persistence).

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [WP-CLI documentation](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [NGINX documentation](https://nginx.org/en/docs/)
- 42 Inception subject PDF (provided by the school)

### How AI was used

An AI assistant (Claude, by Anthropic) was used during this project as a debugging and learning aid, not as a substitute for understanding the material. Specifically, it was used to:

- Review the Dockerfiles, configuration files, and shell scripts for inconsistencies against the project subject's requirements.
- Diagnose and explain the root cause of several runtime bugs encountered during development, including a Docker named-volume/bind-mount masking issue that prevented WordPress files from being visible inside the container, a race condition in the MariaDB startup script, and an authentication issue in the WordPress startup script's readiness check against MariaDB.
- Help draft this documentation (README, USER_DOC, DEV_DOC) based on the actual configuration of the project.
- Clarify Docker/Docker Compose concepts (networking, volumes, image vs. container, orchestration) ahead of the oral defense.

All Dockerfiles, configuration files, and scripts were written and are understood by the author; the AI was used to catch mistakes and explain *why* something was wrong, so that the fixes could be applied and justified independently during the defense.