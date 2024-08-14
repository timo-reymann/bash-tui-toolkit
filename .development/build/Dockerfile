FROM golang:1.23-alpine
RUN apk add bash git && \
    mkdir -p /opt &&  \
    mkdir -p /workspace && \
    addgroup -g 1000 dev && \
    adduser -D -u 1000 -G dev dev && \
    chown -R dev:dev /workspace /opt
WORKDIR /opt
USER dev

# renovate: datasource=github-releases depName=malscent/bash_bundler
ENV bash_bundler_version="v1.0.2"
RUN go install github.com/malscent/bash_bundler@${bash_bundler_version}

WORKDIR /workspace
COPY --chown=dev:dev ./src /workspace/src
ENTRYPOINT ["/bin/bash", "-c"]

