# License: apache-2.0
LABEL org.opencontainers.image.licenses="apache-2.0"

FROM alpine:3
RUN apk add git bash make gawk
RUN mkdir -p /workspace &&  \
    addgroup -g 1000 dev && \
    adduser -D -u 1000 -G dev dev && \
    chown -R dev:dev /workspace
WORKDIR /opt
# renovate: datasource=github-releases depName=reconquest/shdoc
ENV shdoc_version="v1.1"
RUN git clone --recursive https://github.com/reconquest/shdoc && \
    cd shdoc && \
    git checkout ${shdoc_version} && \
    make install
USER dev
WORKDIR /workspace
COPY --chown=dev:dev ./src /workspace
ENTRYPOINT ["/bin/bash", "-c"]
