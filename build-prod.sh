#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build --build-arg CURRENT_APP=site_vitrine -t "nginx-prod-site-vitrine" -f ${DIR}/nginx/prod/Dockerfile .
docker build --build-arg CURRENT_APP=intra_gerant -t "nginx-prod-intra-gerant" -f ${DIR}/nginx/prod/Dockerfile .
docker build --build-arg CURRENT_APP=intra_admin -t "nginx-prod-intra-admin" -f ${DIR}/nginx/prod/Dockerfile .

docker build -t "java-prod-server" -f ${DIR}/java/prod/Dockerfile .

#build de relay-services Dockerfile, changement en perspective pour ajouter les autres projets python
docker build -t "python-prod-relay-service" \
        --build-arg APP=relay-services \
        --build-arg REQUIREMENT_FOLDER=client \
        --build-arg ENTRYPOINT_APP=api_main.py \
        -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-api-manager-email" \
        --build-arg APP=api-manager \
        --build-arg REQUIREMENT_FOLDER=email \
        --build-arg ENTRYPOINT_APP=runserver.py \
        -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-api-manager-showcase" \
        --build-arg APP=api-manager \
        --build-arg REQUIREMENT_FOLDER=showcase \
        --build-arg ENTRYPOINT_APP=runserver.py \
        -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-backoffice-relais" \
        --build-arg APP=backoffice-relais \
        --build-arg REQUIREMENT_FOLDER=backoffice/backoffice \
        --build-arg ENTRYPOINT_APP=manage.py \
        -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-backoffice-server" \
        --build-arg APP=backoffice-server \
        --build-arg REQUIREMENT_FOLDER=. \
        --build-arg ENTRYPOINT_APP=manage.py \
        -f ${DIR}/python/Dockerfile .

#docker build -t "python-prod-email-api" \
 #       --build-arg APP=email_api \
  #      --build-arg REQUIREMENT_FOLDER= \
   #     --build-arg ENTRYPOINT_APP=manage.py \
    #    -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-geocoding-gps-api" \
        --build-arg APP=geocoding \
        --build-arg REQUIREMENT_FOLDER=gps_api \
        --build-arg ENTRYPOINT_APP=gps_api.py \
        -f ${DIR}/python/Dockerfile .

docker build -t "python-prod-geocoding-gym-referencer" \
        --build-arg APP=geocoding \
        --build-arg REQUIREMENT_FOLDER=gym_referencer \
        --build-arg ENTRYPOINT_APP=gym_referencer.py \
        -f ${DIR}/python/Dockerfile .
