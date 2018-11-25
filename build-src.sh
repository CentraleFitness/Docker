#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p dist
mkdir -p src

#rm -r dist/*

#docker rm $(docker ps -aq -f name=nginx-build)

#docker build -t "fit/java-build" -f $DIR/java/build/Dockerfile .
#docker run "fit/java-build" -n "fit/java-build/run"

#nginx dessert les fronts

#on build le Dockerfile qu'une seule fois
docker build -t "fit/nginx-build" -f "$DIR/nginx/build/Dockerfile" .

#build le site vitrine
docker run --name "nginx-build" -w="//opt/app/site_vitrine" "fit/nginx-build"
docker cp "nginx-build":/opt/app/site_vitrine/dist dist/site_vitrine
docker rm "nginx-build"

#build l'intra gérant
docker run --name "nginx-build" -w="//opt/app/intra_gerant" "fit/nginx-build" "yarn && yarn build"
docker cp "nginx-build":/opt/app/intra_gerant/build dist/intra_gerant
docker rm "nginx-build"

#build intra-admin
docker run --name "nginx-build" -w="//opt/app/intra_admin" "fit/nginx-build" "npm install && npm run-script build --prod"
docker cp "nginx-build":/opt/app/intra_admin/build dist/intra_admin
docker rm "nginx-build"

