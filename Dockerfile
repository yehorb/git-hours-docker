FROM node:14-alpine3.15 as build

# git-hours required nodegit. nodegit has C++ sources, and requires building from
# source, as there are no prebuilt package for alpine.
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
    ; \
    # Cleaning up after nodegit build. Essentially only build/Release/*.node files
    # are required for module to work properly in alpine.
    NODEGIT=/usr/local/lib/node_modules/git-hours/node_modules/nodegit; \
    rm -rf \
        $NODEGIT/vendor \
    ; \
    # Delete all files from build directory (including files from build/Release
    # subdirectories) except for the *.node files from build/Release directory.
    find $NODEGIT/build \
        ! -regex .*/Release/[^/]*\.node \
        -delete \
    ;

# Two-stage build allows not worrying too much about cleaning up build dependencies.
FROM node:14-alpine3.15

ARG IMAGE_NAME
ARG COMMIT_HASH

LABEL Maintainer="Yehor Borkov <yehor.borkov@gmail.com>" \
      Description="Light Docker image (based on alpine) for using git-hours." \
      org.opencontainers.image.title=$IMAGE_NAME \
      org.opencontainers.image.version="1.5.0" \
      org.opencontainers.image.description="Light Docker image (based on alpine) for using git-hours." \
      org.opencontainers.image.source="https://github.com/yehorb/git-hours-docker.git" \
      org.opencontainers.image.revision=$COMMIT_HASH

RUN set -eux; \
    apk update; \
    apk add --no-cache \
        krb5-libs \
        tini \
    ; \
    rm -rf \
        /tmp/* \
        /usr/share/man \
        /var/cache/apk/* \
    ;

COPY --from=build \
    /usr/local/lib/node_modules/git-hours \
    /usr/local/lib/node_modules/git-hours

WORKDIR /var/task

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/node", "/usr/local/lib/node_modules/git-hours/src/index.js"]
