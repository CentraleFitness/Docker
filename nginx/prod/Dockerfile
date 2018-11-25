FROM nginx:1.14.0

MAINTAINER Géraldine de Vanssay version: 1.0

ARG CURRENT_APP

ENV APP_HOME=/usr/share/nginx/html \
    DIST=dist

COPY $DIST/$CURRENT_APP $APP_HOME/