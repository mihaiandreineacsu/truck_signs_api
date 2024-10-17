#!/usr/bin/env bash
set -e

# Check if DJANGO_ENV is set
if [ -z "$DJANGO_ENV" ]; then
    echo "Error: DJANGO_ENV is not set. Please set it to 'development' or 'production'."
    exit 1
fi

python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

echo "Postgresql migrations finished"

if [ "$DJANGO_ENV" = "production" ]; then
    gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000
elif [ "$DJANGO_ENV" = "development" ]; then
    python manage.py runserver 0.0.0.0:8000
else
    echo "Error: Invalid DJANGO_ENV value. Please set it to 'development' or 'production'."
    exit 1
fi
