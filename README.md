[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/freescout-1?utm_medium=integration&utm_source=button&utm_campaign=freescout)

# FreeScout on Railway

A Railway template for [FreeScout](https://freescout.net) **1.8.251**, the free, self-hosted help desk and shared inbox (an open-source Help Scout / Zendesk alternative): shared mailboxes, conversations, collision detection, saved replies, notes, customer profiles, a mobile-friendly web app and modules.

## What the template deploys

| Service | Source | Volume | What it does |
|---|---|---|---|
| `FreeScout` | this repo (`Dockerfile`) | `/data` | Web app (nginx + PHP-FPM 8.5), queue worker and scheduler, on the public domain |
| `MariaDB` | `mariadb:11.8.9`, pinned by digest | `/var/lib/mysql` | FreeScout's database, private network only |

- `Dockerfile`: `nfrastack/freescout:2.2.25` (FreeScout 1.8.251), pinned by digest. It's the image FreeScout's [Docker page](https://freescout.net/docker/) links to. The Dockerfile adds a `/healthz` health check and `railway-start.sh`.
- `railway-start.sh`: listens on `PORT`, sets `APP_URL` from the Railway domain, trusts Railway's proxy headers (HTTPS), refuses an empty or default admin password, then starts the image's own init. On the first start that init writes the config (with a generated `APP_KEY`), creates the tables and the first administrator.
- The `/data` volume keeps the config and `APP_KEY`, attachments, sessions, cache and installed modules. MariaDB keeps its data in `/var/lib/mysql/data` on its own volume.

## Variables

| Service | Variable | Default | What it does |
|---|---|---|---|
| FreeScout | `ADMIN_EMAIL` | asked at deploy | Email (login) of the first administrator |
| FreeScout | `ADMIN_PASS` | generated secret | Password of the first administrator. Read it in the service's Variables tab |
| FreeScout | `APP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL. Change it if you add a custom domain |
| FreeScout | `PORT` | `8080` | Port nginx listens on; the domain points at it |
| FreeScout | `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS` | references to `MariaDB` | Database connection over the private network |
| MariaDB | `MARIADB_DATABASE`, `MARIADB_USER` | `freescout` | Database and user created on the first start |
| MariaDB | `MARIADB_PASSWORD`, `MARIADB_ROOT_PASSWORD` | generated secrets | Database passwords |

`ADMIN_EMAIL` and `ADMIN_PASS` are used once, when the database is empty. Change them later in FreeScout (your profile). Other settings from FreeScout's [`.env` reference](https://github.com/freescout-help-desk/freescout/blob/dist/.env.example) can be added as `FREESCOUT_<KEY>` variables on the FreeScout service, for example `FREESCOUT_APP_LOCALE=de`. Set `TIMEZONE` (for example `Europe/Berlin`) to change the time zone.

## After deploy

1. Open the FreeScout service's domain and sign in with `ADMIN_EMAIL` and the generated `ADMIN_PASS`.
2. Under **Manage → Mailboxes**, add a mailbox with its incoming (IMAP) and outgoing (SMTP) settings. FreeScout fetches mail every minute.
3. Invite your team under **Manage → Users**.

## Updates

Version bumps are merged to `main` here. Railway shows deployers of this template an "update available" notice, and they choose when to apply it. On start, a newer image runs FreeScout's database migrations by itself. Each version is listed in [CHANGELOG.md](CHANGELOG.md), breaking changes first. FreeScout's built-in web updater is off in this image: updates come through this repo.
