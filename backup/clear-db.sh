#!/bin/sh

set -e

cd ../docker

docker-compose run --rm mango-tools 'mongo -host mango centralefitness --eval "db.dropDatabase()"'