#!/usr/bin/env bash
set -e

python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

echo "Postgresql migrations finished"

# gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000
python manage.py runserver 0.0.0.0:8000
