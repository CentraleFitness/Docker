FROM alpine:latest

MAINTAINER Géraldine de Vanssay version: 1.0

# Config env
ENV APP_HOME=/opt/app \
    VITRINE=site_vitrine \
    INTRA_GERANT=intra_gerant \
    INTRA_ADMIN=intra_admin \
    SRC_FILES_VITRINE=src/$VITRINE/ \
    SRC_FILES_INTRA_G=src/$INTRA_GERANT/ \
    SRC_FILES_INTRA_A=src/$INTRA_ADMIN/ \
    OUTPUT_FILES=dist/node

RUN apk upgrade --update && apk add nodejs npm yarn
RUN npm i npm@latest -g

COPY $SRC_FILES_VITRINE $APP_HOME/
COPY $SRC_FILES_INTRA_G $APP_HOME/
COPY $SRC_FILES_INTRA_A $APP_HOME/


WORKDIR $APP_HOME/
ENTRYPOINT ["sh", "-c"]
CMD ["yarn"]