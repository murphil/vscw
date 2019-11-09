FROM node:10-buster-slim as b

ARG vscode_version=1.40.0
ARG vscode_url=https://github.com/microsoft/vscode/archive/${vscode_version}.tar.gz

ENV build_deps \
        make \
        gcc \
        g++ \
        pkg-config \
        libx11-dev \
        libxkbfile-dev \
        libsecret-1-dev \
        python

RUN set -eux \
  ; sed -i 's/\(.*\)\(security\|deb\).debian.org\(.*\)main/\1ftp.cn.debian.org\3main contrib non-free/g' /etc/apt/sources.list \
  ; apt update \
  ; DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends ${build_deps}

RUN set -eux \
  ; mkdir -p /opt/vscode \
  ; wget -q -O- ${vscode_url} \
    | tar zxf - -C /opt/vscode --strip-components=1

WORKDIR /opt/vscode
RUN yarn

FROM node:10-buster-slim

WORKDIR /opt/vscode

COPY --from=b /opt/vscode /opt/vscode