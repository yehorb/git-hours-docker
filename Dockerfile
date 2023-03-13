FROM node:14-alpine3.15 as build

# git-hours depends on nodegit. nodegit has C++ sources, and building from source
# is required, as there are no prebuilt package for alpine.
RUN set -eux; \
    apk update; \
    apk add \
        build-base \
        git \
        krb5-dev \
        libcom_err \
        pcre-dev \
        python3 \
    ;

# Installing and building as separate RUN steps helps caching, and does not affect image
# size as we are using two-stage build.
RUN set -eux; \
    npm config set global true; \
    npm config set production true; \
    npm config set unsafe-perm true; \
    BUILD_ONLY=true npm install \
        # Latest master commit at a time, not available on npmjs.
        https://github.com/kimmobrunfeldt/git-hours.git#c589eea5174ee6439b68b4b437e443e7b6e4bf7b \
    ;


# Cleaning up after nodegit build. Essentially only build/Release/*.node files
# are required for module to work properly in alpine.
RUN set -eux; \
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

# Two-stage build skips cleaning up build dependencies, caches, npm configuration.
FROM node:14-alpine3.15

ARG IMAGE_NAME
ARG COMMIT_HASH

LABEL Maintainer="Yehor Borkov <yehor.borkov@gmail.com>" \
      Description="git-hours - Light Docker image (based on alpine)." \
      org.opencontainers.image.title=$IMAGE_NAME \
      org.opencontainers.image.version="1.5.0" \
      org.opencontainers.image.description="git-hours - Light Docker image (based on alpine)." \
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
    ; \
    ln -sf \
        /usr/local/lib/node_modules/git-hours/src/index.js \
        /usr/local/bin/git-hours \
    ;

COPY --from=build \
    /usr/local/lib/node_modules/git-hours \
    /usr/local/lib/node_modules/git-hours

WORKDIR /var/task

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/git-hours"]
