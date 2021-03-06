#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

. ../../images.env

# TODO: return health checks
docker-compose up -d
docker-compose exec mariadb make check-ready max_try=12 wait_seconds=3 -f /usr/local/bin/actions.mk
docker-compose exec php make check-ready -f /usr/local/bin/actions.mk
docker-compose exec --user=0 php chown -R www-data:www-data /var/www/html
docker-compose exec php ./test.sh
docker-compose down
