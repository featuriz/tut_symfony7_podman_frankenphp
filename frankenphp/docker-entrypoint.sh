#!/bin/sh
set -e

echo "Starting Symfony FrankenPHP container..."
echo "App Environment: $APP_ENV "

# until nc -z -v -w30 mariadb 3306; do
#   echo "Waiting for MariaDB..."
#   sleep 2
# done

if [ ! -d "vendor" ]; then
    echo "Installing Composer dependencies..."
    if [ "$APP_ENV" = "prod" ]; then
    echo "Running production composer install..."
    composer install --no-dev --no-interaction --optimize-autoloader --classmap-authoritative  --no-scripts --prefer-dist;
    else 
    echo "Running development composer install..."
    composer install --prefer-dist --no-progress --no-interaction; 
    fi
fi

# Clear and warmup cache
echo "Warming up cache..."
php bin/console cache:clear --env=$APP_ENV --no-warmup
php bin/console cache:warmup --env=$APP_ENV

php bin/console -V

echo "App ready to use!"

exec docker-php-entrypoint "$@"
