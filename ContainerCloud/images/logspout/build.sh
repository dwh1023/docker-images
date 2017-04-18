#!/bin/sh
set -e

export GOPATH=/go
export LOGSPOUT_VERSION=3.1
export LOGSPOUT_URL=https://github.com/gliderlabs/logspout/archive

apk upgrade
apk update
apk add curl jq
apk add --virtual .build-deps wget go git svn build-base

mkdir -p /go/src/github.com/gliderlabs

wget -O /tmp/v${LOGSPOUT_VERSION}.tar.gz \
  ${LOGSPOUT_URL}/v${LOGSPOUT_VERSION}.tar.gz && \
  tar xzf /tmp/v${LOGSPOUT_VERSION}.tar.gz \
    -C /go/src/github.com/gliderlabs && \
  ln -s /go/src/github.com/gliderlabs/logspout-${LOGSPOUT_VERSION} \
    /go/src/github.com/gliderlabs/logspout

svn co https://svn.cms.waikato.ac.nz/svn/weka/trunk/weka

cd /go/src/github.com/gliderlabs/logspout
go get -x # || find ${GOPATH} && go env && find ${GOROOT}
#sed 's/\/context/github\.com\/gorilla\/context/' /go/src/github.com/fsouza/go-dockerclient/client_unix.go > /go/src/github.com/fsouza/go-dockerclient/client_unix.go.tmp
#mv /go/src/github.com/fsouza/go-dockerclient/client_unix.go.tmp /go/src/github.com/fsouza/go-dockerclient/client_unix.go
cat /go/src/github.com/fsouza/go-dockerclient/client_unix.go
#go build -v -x -ldflags "-X main.Version dev" -o /bin/logspout

#apk del .build-deps
#rm -rf /go
#rm -rf /var/cache/apk/*
#rm /tmp/v${LOGSPOUT_VERSION}.tar.gz
