<?php
// Railway health check. nginx and PHP-FPM start only after the image's init has
// written the config, run the database migrations and created the admin, so a
// 200 here means FreeScout is ready. It skips Laravel on purpose: Laravel's
// trusted-hosts check answers 403 to Railway's health-check host name.
header('Content-Type: text/plain');
header('Cache-Control: no-store');
echo "ok\n";
