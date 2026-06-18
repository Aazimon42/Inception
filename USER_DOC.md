# USER_DOC

## Overview

This document is intended for end users and administrators who need to run, access, and monitor the Inception stack. No Docker knowledge is required to follow these instructions.

The stack provides the following services:

| Service      | Description                                          | Access                          |
|--------------|------------------------------------------------------|---------------------------------|
| WordPress    | Main website and CMS                                 | `https://login.42.fr`           |
| Adminer      | Web interface to manage the database                 | `https://login.42.fr/adminer`   |
| Portainer    | Dashboard to monitor Docker containers               | `https://login.42.fr:9443`      |
| Static site  | Personal portfolio served by Apache                  | `https://login.42.fr/static`    |
| FTP          | File access to WordPress uploads and content         | `ftp://login.42.fr:21`          |

---

## Starting and stopping the project

From the repository root:

```bash
# Start all services
make

# Stop all services (volumes are preserved)
make stop

# Full cleanup (removes containers, images, and all stored data)
make fclean
```

After `make`, all services start in the background.

---

## Accessing the website and administration panel

### WordPress site

Open your browser and go to:

```
https://login.42.fr
```

The SSL certificate is self-signed. Your browser will show a security warning — click **Advanced** then **Accept the risk and continue** (or equivalent).

### WordPress admin panel

```
https://login.42.fr/wp-admin
```

Use the credentials defined in `srcs/.env` under `WP_USER` and `WP_USER_PASS`.

### Adminer (database)

```
https://login.42.fr/adminer
```

| Field    | Value                              |
|----------|------------------------------------|
| System   | MySQL / MariaDB                    |
| Server   | `mariadb`                          |
| Username | value of `MYSQL_USER` in `.env`    |
| Password | value of `MYSQL_PASSWORD` in `.env`|
| Database | value of `MYSQL_DB_NAME` in `.env` |

### Portainer (Docker dashboard)

```
https://login.42.fr:9443
```

On first access, create a local admin account. Portainer lets you view container status, logs, volumes, and networks without using the command line.

### FTP access

Use any FTP client (FileZilla, lftp, etc.):

```
Host     : login.42.fr
Port     : 21
Username : value of FTP_USER in .env
Password : value of FTP_PASS in .env
```

The FTP root points to the WordPress files directory (`/var/www/html`).

---

## Credentials

All credentials are stored in `srcs/.env`. This file is NEVER committed to Git.

```bash
# View current credentials
cat srcs/.env
```

Key variables:

| Variable            | Used by                         |
|---------------------|---------------------------------|
| `MYSQL_USER`        | MariaDB / WordPress / Adminer   |
| `MYSQL_PASSWORD`    | MariaDB / WordPress / Adminer   |
| `MYSQL_ADMIN_PASS`  | MariaDB root access             |
| `WP_ADMIN`          | WordPress admin login           |
| `WP_ADMIN_PASS`     | WordPress admin login           |
| `WP_USER`           | WordPress second user (author)  |
| `FTP_USER`          | FTP login                       |
| `FTP_PASS`          | FTP login                       |

---

## Checking that services are running

```bash
# Quick overview of all containers and their status
docker ps
```

All containers should show `Up` in the `STATUS` column. If a container shows `Restarting` or `Exited`, check its logs:

```bash
docker logs <container_name>
```

You can also open **Portainer** (`https://login.42.fr:9443`) for a visual overview of container health, uptime, and resource usage.

### Basic connectivity checks

```bash
# WordPress is reachable
curl -k https://login.42.fr

# MariaDB is responding
docker exec -it mariadb mysqladmin ping -u$MYSQL_USER -p$MYSQL_PASSWORD

# Redis is responding
docker exec -it redis redis-cli -a $REDIS_PASSWORD ping
```
