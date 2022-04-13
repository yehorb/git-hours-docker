FROM node:14-alpine3.15 as build

RUN set -eux; \
    apk update; \
    apk add \
        build-base \
        krb5-dev \
        libcom_err \
        pcre-dev \
        python3 \
    ; \
    npm config set global true; \
    npm config set production true; \
    npm config set unsafe-perm true; \
    BUILD_ONLY=true npm install \
        git-hours@1.5.0 \
    ;

ARG BUILD_DATE
ARG VCS_REF
ARG IMAGE_NAME

LABEL Maintainer="Yehor Borkov <yehor.borkov@gmail.com>" \
      Description="Light Docker image (based on alpine) for using git-hours." \
      org.label-schema.name=$IMAGE_NAME \
      org.label-schema.description="Light Docker image (based on alpine) for using git-hours." \
      org.label-schema.vcs-url="https://github.com/yehorb/git-hours-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

RUN set -eux; \
    apk update; \
    apk add --no-cache \
        tini \
    ; \
    rm -rf \
        /tmp/* \
        /usr/share/man \
        /var/cache/apk/* \
    ;

WORKDIR /var/task

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/node", "/usr/local/lib/node_modules/git-hours/src/index.js"]
