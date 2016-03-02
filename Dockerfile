FROM ubuntu:trusty
MAINTAINER Shane Kumpf version: 0.1

RUN apt-get update && apt-get install -y curl git g++ gcc make

ENV GOLANG_VERSION=1.5.3
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go1.5.3.linux-amd64.tar.gz

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz && tar -C /usr/local -xzf golang.tar.gz  && rm golang.tar.gz

ENV GOPATH=/go
ENV GOPATH_WORKSPACE=/go/src/github.com/sakserv/distribution/Godeps/_workspace:/go
ENV PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

WORKDIR /go
RUN go get github.com/tools/godep  github.com/golang/lint/golint  github.com/sakserv/distribution/cmd/registry  github.com/colinmarc/hdfs
RUN cd $GOPATH/src/github.com/sakserv/distribution  && GOPATH=$GOPATH_WORKSPACE make build  && GOPATH=$GOPATH_WORKSPACE make binaries

EXPOSE 5000

CMD ["/go/src/github.com/sakserv/distribution/bin/registry", "serve", "/go/src/github.com/sakserv/distribution/cmd/registry/config-hdfs.yml"]
