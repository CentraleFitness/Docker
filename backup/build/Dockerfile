FROM alpine:latest

MAINTAINER Géraldine de Vanssay version: 1.0

ENV APP_HOME=/opt/app \
    MONGO_VERSION 3.6.9

RUN apk add --no-cache mongodb \
    apk mongo-tools

VOLUME /mango

EXPOSE 27017 28017

COPY run.sh /root


WORKDIR $APP_HOME
ENTRYPOINT [ "/root/run.sh" ]
CMD [ "mongod", "--bind_ip", "0.0.0.0" ]