# FreeScout 1.8.251 in the image FreeScout's own Docker page points to
# (nfrastack/container-freescout 2.2.25), pinned by version and digest.
FROM nfrastack/freescout:2.2.25@sha256:0c27d6c21f7f48fb5b53f6302f8e33c97aec75f5f687fe5b19e7b9842d7c59f5

# Health check for Railway: GET /healthz answers 200 once nginx and PHP-FPM run,
# which the image starts only after config, migrations and the admin are done.
# The image copies its install tree into the web root (/www/html) on every start.
COPY --chown=nginx:nginx healthz.php /container/data/freescout/install/public/healthz.php
COPY healthz.conf /container/data/nginx/sites.available/freescout/location/10-healthz.conf
COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 0755 /usr/local/bin/railway-start.sh

# All state (config with APP_KEY, attachments, sessions, modules, version marker)
# lives in /data, which the template puts on a Railway volume.
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
