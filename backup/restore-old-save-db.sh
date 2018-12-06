#!/bin/sh

set -e

cd ../docker

docker-compose run --rm mango-tools 'mongorestore --host=mango -d centralefitness old_db_save/'