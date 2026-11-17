#!/bin/bash
# Railway wrapper for nfrastack/freescout: maps Railway's variables onto the
# image's settings, then hands over to the image's own init (/init, s6-overlay).
set -e

# Listen on Railway's PORT (the public domain targets it).
export NGINX_LISTEN_PORT="${PORT:-8080}"

# Public URL: APP_URL wins, else the service's Railway domain.
if [ -z "${APP_URL}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN}" ]; then
    export APP_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

# The first administrator (created on an empty database only).
if [ -z "${ADMIN_PASS}" ] || [ "${ADMIN_PASS}" = "freescout" ]; then
    echo "ADMIN_PASS is empty or the image's default; set a strong password (the template generates one)." >&2
    exit 1
fi
if [ -z "${ADMIN_EMAIL}" ]; then
    export ADMIN_EMAIL="admin@${RAILWAY_PUBLIC_DOMAIN:-example.com}"
    echo "ADMIN_EMAIL is empty; the first administrator (if created now) is ${ADMIN_EMAIL}." >&2
fi

# Railway's edge proxy terminates TLS and sends X-Forwarded-* headers.
export FREESCOUT_APP_TRUSTED_PROXIES="${FREESCOUT_APP_TRUSTED_PROXIES:-**}"

export DB_TYPE="${DB_TYPE:-mysql}"
export DB_PORT="${DB_PORT:-3306}"
export TIMEZONE="${TIMEZONE:-UTC}"
# Queue worker and per-minute scheduler (mail fetching) run inside this container.
export SCHEDULER_TYPE="${SCHEDULER_TYPE:-service}"
# When a newer image starts on an existing volume, run FreeScout's migrations.
export ENABLE_AUTO_UPDATE="${ENABLE_AUTO_UPDATE:-TRUE}"

exec /init "$@"
