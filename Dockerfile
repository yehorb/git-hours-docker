FROM node:14-alpine as build

RUN set -eux; \
    apk update; \
    apk add \
        curl-dev \
        g++ \
        gcc \
        git \
        krb5-libs \
        libc-dev \
        libressl-dev \
        make \
        python3 \
    ; \
    npm config set unsafe-perm true; \
    BUILD_ONLY=true npm install --global \
        nodegit@^0.27.0 \
    ; \
    npm install --global \
        git-hours@1.5.0 \
    ;

FROM node:14-alpine

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
        git \
        krb5-libs \
        libc-dev \
        libressl-dev \
        tini \
    ; \
    rm -rf \
        /tmp/* \
        /usr/share/man \
        /var/cache/apk/* \
    ;

COPY --from=build /usr/local/lib/node_modules/ /usr/local/lib/node_modules/

WORKDIR /var/task

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/local/bin/node", "/usr/local/lib/node_modules/git-hours/src/index.js"]
