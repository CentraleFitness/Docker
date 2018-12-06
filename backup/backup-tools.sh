#!/bin/sh

set -e

cd ../docker

docker-compose run --rm mango-tools 'mongorestore --host=mango -d centrale-fitness dase_db_save/'