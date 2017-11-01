FROM sitespeedio/browsertime:latest

RUN sudo apt-get update && sudo apt-get install libnss3-tools curl git iproute2 -y

WORKDIR /work
RUN curl -O https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz && \
  tar -xvf go1.9.linux-amd64.tar.gz && \
  sudo mv go /usr/local

ENV PATH="/usr/local/go/bin:${PATH}"

RUN go get github.com/urfave/cli && \
  go get golang.org/x/net/http2 && \
  go get github.com/catapult-project/catapult/web_page_replay_go/src/webpagereplay


RUN mkdir -p $HOME/.pki/nssdb && \
  certutil -d $HOME/.pki/nssdb -N

WORKDIR /root/go/src/github.com/catapult-project/catapult/web_page_replay_go

RUN go run src/wpr.go installroot && \
  npm install webpagereplaywrapper -g

COPY start.sh /start.sh

WORKDIR /browsertime

ENTRYPOINT ["/start.sh"]
