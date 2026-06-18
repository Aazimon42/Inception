# DEV_DOC

## Overview

This document explains how to set up the Inception environment from scratch, build and launch the project, manage containers and volumes, and identify where project data is stored.

---

## Prerequisites

- Docker installed and running
- Docker Compose available (`docker compose`)
- `make` installed
- A Debian/Ubuntu virtual machine with root/sudo access
- `/etc/hosts` on the host machine must contain: `127.0.0.1 login.42.fr`

---

## Initial setup

1. Clone the repository and enter the project directory:

   ```bash
   git clone git@vogsphere.42angouleme.fr:vogsphere/intra-uuid-fdbe4ab4-a06c-4dc4-8e9b-678a3156caa7-7430617-edi-maio inception
   cd inception
   ```

2. Create a new or copy an environment file:

   ```bash
   touch srcs/.env
   ```
   or
   ```bash
   cp /home/user/.env srcs/
   ```

3. Edit `srcs/.env` and fill in all required values: passwords, usernames, domain name. NEVER commit it to Git (it's in the .gitignore anyway).

4. The Makefile will automatically create the data directories on the VM before starting containers:

   ```
   /home/login/data/wordpress
   /home/login/data/mariadb
   ```

---

## Build and launch

From the repository root:

```bash
make
```

This runs `docker compose up --build -d` after creating the data directories. Docker builds all images from their respective `Dockerfile` and starts the containers in detached mode.

To verify the services are running:

```bash
docker ps
```

All containers should show `Up` in the `STATUS` column.

---

## Managing containers and volumes

### Makefile commands

| Command       | Description                                                                    |
|---------------|--------------------------------------------------------------------------------|
| `make`        | Creates data directories and starts all containers in detached mode            |
| `make stop`   | Stops and removes containers (`docker compose down`), keeps volumes            |
| `make clean`  | Calls `stop` then deletes the `/home/login/data` directory                     |
| `make fclean` | Calls `clean` then runs `docker system prune -af` (removes images, networks)   |
| `make re`     | Calls `fclean` then `make` — full teardown and fresh restart                   |

### Useful Docker commands

```bash
# View logs for a specific service
docker logs <service_name>

# Open a shell in interactive mode inside a running container
docker exec -it <service_name> bash

# List volumes
docker volume ls
```

### Service names

| Container name | Service         |
|----------------|-----------------|
| `nginx`        | Reverse proxy   |
| `wordpress`    | PHP-FPM / CMS   |
| `mariadb`      | Database        |
| `redis`        | Cache           |
| `ftp`          | FTP server      |
| `adminer`      | DB web UI       |
| `portainer`    | Docker UI       |
| `static`       | Static site     |

---

## Data storage and persistence

Project data is persisted by Docker volumes configured in `srcs/docker-compose.yml`. All volumes are bind-mounted to the VM filesystem under `/home/login/data`.

| Volume           | Host path                       | Contains                        |
|------------------|---------------------------------|---------------------------------|
| `wordpress`      | `/home/login/data/wordpress`    | WordPress files and uploads     |
| `mariadb`        | `/home/login/data/mariadb`      | MariaDB data files              |
| `portainer`      | `/home/login/data/portainer`    | Portainer configuration         |

Data in these directories persists across `make stop` / `make` cycles. Running `make clean` or `make fclean` will delete the bind-mounted directories and all stored data.

---

## Environment variables and secrets

All sensitive values (passwords, usernames, domain) are loaded from `srcs/.env` at compose time. They are injected into containers as environment variables and used by entrypoint scripts.

Notable variables:

| Variable              | Used by              |
|-----------------------|----------------------|
| `DOMAIN_NAME`         | Nginx, WordPress     |
| `MYSQL_DB_NAME`       | MariaDB, WordPress   |
| `MYSQL_USER`          | MariaDB, WordPress   |
| `MYSQL_PASSWORD`      | MariaDB, WordPress   |
| `MYSQL_ADMIN_PASS`    | MariaDB              |
| `WP_ADMIN`            | WordPress            |
| `WP_ADMIN_PASS`       | WordPress            |
| `WP_USER`             | WordPress            |
| `WP_ADMIN_PASS`       | WordPress            |
| `FTP_USER`            | ftp                  |
| `FTP_PASS`            | ftp                  |

The `.env` file must NEVER be committed to Git.

---

## Debugging

If a container fails to start or keeps restarting:

```bash
# Check exit reason
docker logs <service_name>

# Check overall container state
docker ps -a

# Verify MariaDB is reachable from WordPress
docker exec -it wordpress mysqladmin ping -h mariadb -u $MYSQL_USER -p $MYSQL_PASSWORD

# Verify Redis is reachable
docker exec -it redis redis-cli ping

# Test HTTPS
curl -k https://login.42.fr
```
