#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p dist
mkdir -p src

#rm -r dist/*

#docker rm $(docker ps -aq -f name=nginx-build)

docker build -t "fit/java-build" -f $DIR/java/build/Dockerfile .
docker run --name "java-build" "fit/java-build"
docker cp "java-build":/opt/app/build/libs/ dist/server
docker cp "java-build":/opt/app/ServerSettings.ini dist/server
docker rm "java-build"

docker build -t "fit/nginx-build" -f $DIR/nginx/build/Dockerfile .

docker run --name "nginx-build" -w="//opt/app/site_vitrine" "fit/nginx-build"
docker cp "nginx-build":/opt/app/site_vitrine/dist dist/site_vitrine
docker rm "nginx-build"

docker run --name "nginx-build" -w="//opt/app/intra_gerant" "fit/nginx-build" "yarn && yarn build"
docker cp "nginx-build":/opt/app/intra_gerant/build dist/intra_gerant
docker rm "nginx-build"