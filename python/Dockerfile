FROM alpine:latest

MAINTAINER Géraldine de Vanssay version: 1.0

ARG REQUIREMENT_FOLDER=client
ARG APP=app
ARG ENTRYPOINT_APP=server.py

# Config env
ENV APP_HOME=/opt/app \
    SRC_FILES=src/ \
    OUTPUT_FILES=dist/node \
    ENTRYPOINT_APP_ENV=$ENTRYPOINT_APP

RUN apk upgrade --update && apk add python3 bash py-pip
RUN pip3 install --upgrade pip

COPY $SRC_FILES/$APP $APP_HOME/
WORKDIR $APP_HOME/$REQUIREMENT_FOLDER

RUN pip3 install -r requirements.txt

ENTRYPOINT ["sh", "-c"]
CMD ["python3 $ENTRYPOINT_APP_ENV"]