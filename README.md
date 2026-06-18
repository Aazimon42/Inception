*This project has been created as part of the 42 curriculum by edi-maio*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small but complete infrastructure using Docker and Docker Compose, deployed inside a virtual machine.

Each service runs in its own dedicated container, built from scratch using either Debian or Alpine base images. No pre-built application images allowed. The stack includes a web server, a database, a CMS, a cache layer, and several bonus services, all communicating over an isolated Docker network.

### Services included

| Service    | Role                                         |
|------------|----------------------------------------------|
| Nginx      | HTTPS reverse proxy (TLSv1.2/1.3)            |
| MariaDB    | Relational database for WordPress            |
| WordPress  | CMS with PHP-FPM                             |
| Redis      | Object cache for WordPress *(bonus)*         |
| vsftpd     | FTP access to WordPress files *(bonus)*      |
| Adminer    | Web-based database management UI *(bonus)*   |
| Portainer  | Docker dashboard *(bonus)*                   |
| Website    | Static site served by Apache *(bonus)*       |

### Design choices

#### Virtual Machines vs Docker

A virtual machine emulates a full hardware stack and runs a complete OS, strong isolation but heavy on resources and slow to start. Docker containers share the host kernel and isolate only at the process level, which makes them lightweight and fast. For this project, Docker lets us define and reproduce the entire infrastructure as code, with each service cleanly separated in its own container.

#### Secrets vs Environment Variables

Environment variables (`.env` file) are convenient for configuration but are visible in the container environment and can leak through `docker inspect` or process listings. Docker Secrets (Swarm feature) store sensitive data in memory only and mount them as files inside containers, never exposed as env vars. In this project we use a `.env` file loaded by Docker Compose, suitable for a local/learning setup, but a production environment would use proper secrets management.

#### Docker Network vs Host Network

With host networking, a container shares the host's network namespace directly — no isolation, any port the container opens is exposed on the host. With a Docker bridge network (used here), containers get their own network namespace and communicate by service name via Docker's internal DNS. Only explicitly published ports reach the outside. This project uses a custom bridge network (`inception`) so services can reach each other by name (`wordpress` -> `mariadb`) while remaining isolated from the host.

#### Docker Volumes vs Bind Mounts

Bind mounts map a specific host path directly into the container, straightforward but tied to the host's filesystem layout. Docker volumes are managed by Docker and abstracted from the host path, making them more portable and easier to back up. This project uses bind mounts configured as local volumes pointing to `/home/login/data/`, which satisfies the 42 subject constraint of storing data on the VM's filesystem.

---

## Instructions

### Prerequisites

- Docker and Docker Compose
- `make`
- A running Debian/Ubuntu VM
- `/etc/hosts` on your host machine must contain: `127.0.0.1 login.42.fr`

### Setup

```bash
git clone git@vogsphere.42angouleme.fr:vogsphere/intra-uuid-fdbe4ab4-a06c-4dc4-8e9b-678a3156caa7-7430617-edi-maio inception
cd inception
cp /home/edi-maio/.env srcs/.env
# Edit srcs/.env with your passwords and configuration
make
```

### Makefile commands

| Command       | Description                                                    |
|---------------|----------------------------------------------------------------|
| `make`        | Creates data directories and starts all containers             |
| `make stop`   | Stops and removes containers, keeps volumes                    |
| `make clean`  | Stops containers and deletes `/home/login/data`                |
| `make fclean` | Full cleanup: containers, data, images, networks               |
| `make re`     | `fclean` + full rebuild                                        |

### Access

| Service      | URL                              |
|--------------|----------------------------------|
| WordPress    | `https://login.42.fr`            |
| Adminer      | `https://login.42.fr/adminer`    |
| Portainer    | `https://login.42.fr:9443`       |
| Static site  | `https://login.42.fr/static`     |
| FTP          | `ftp://login.42.fr:21`           |

---

## Resources

### Documentation

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Nginx documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [vsftpd manual](https://security.appspot.com/vsftpd.html)
- [Redis documentation](https://redis.io/docs/)
- [Adminer](https://www.adminer.org/)
- [Portainer documentation](https://docs.portainer.io/)

### AI usage

AI was used during this project for the following tasks:

- Reviewing code and design choices
- Improve this documentation (README, USER_DOC, DEV_DOC)
- Find and explain precise informations from documentations

AI was used as a debugging and explanation tool, not to write the core Docker or shell code directly.
