# Changelog

Breaking changes are listed first in each entry. Back up the database (MariaDB service) and the `/data` volume before you apply an update.

## 1.8.251-railway.1 (2026-11-17)

- First release of the template: FreeScout 1.8.251 in `nfrastack/freescout:2.2.25@sha256:0c27d6c21f7f48fb5b53f6302f8e33c97aec75f5f687fe5b19e7b9842d7c59f5` (the image FreeScout's own Docker page points to), with MariaDB 11.8.9 (`mariadb:11.8.9@sha256:d36f18d65a0459510b8b0f643b226a6d299e3206486e2b64ff20754a6d291707`).
- Unattended first start: config, database migrations and the first administrator, whose password is a generated variable. The image's default password `freescout` is refused.
- Health check `/healthz`; listens on `PORT`; queue worker and scheduler (mail fetching) run in the app container.
