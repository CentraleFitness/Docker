FROM alpine:latest

MAINTAINER Géraldine de Vanssay version: 1.0

ENV APP_HOME=/opt/app

RUN apk add --no-cache mongodb-tools bash

VOLUME /mango

WORKDIR $APP_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["bash"]