FROM sitespeedio/browsertime:latest

RUN sudo apt-get update && sudo apt-get -y install dh-autoreconf \
  apache2 \
  dnsmasq \
  protobuf-compiler \
  apache2-dev \
  libprotobuf-dev \
  xcb \
  libxcb-present-dev \
  libpango1.0-dev \
  python-flup \
  python3-tz \
  python3-pip \
  python3-setuptools \
  python3-dev \
  libssl-dev \
  unzip build-essential \
  cmake \
  libuv1-dev \
  python-sphinx \
  bc \
  git \
  curl \
  iptables \
  iproute2 && \
  sudo pip3 install --upgrade pip && \
  sudo pip3 install mitmproxy && \
  sudo pip3 install protobuf

WORKDIR /work

# h2o dependency not available in Debian yet
RUN git clone https://github.com/tatsuhiro-t/wslay && \
  git clone https://github.com/gi11es/h2o  && \
  git clone https://github.com/gi11es/mahimahi-h2o  && \
  git clone https://github.com/worenga/mitmproxy2mahimahi


WORKDIR /work/wslay
RUN autoreconf -i && \
  automake && \
  autoconf && \
  ./configure && \
  make && \
  sudo make install

WORKDIR /work/h2o
RUN cmake . && \
  make h2o && \
  sudo make install

WORKDIR /work/mahimahi-h2o
RUN ./autogen.sh && \
  autoreconf -f -i -Wall,no-obsolete && \
  ./configure && \
  make && \
  sudo make install

WORKDIR /browsertime

COPY start.sh /start.sh

# Enable passwordless sudo for users under the "sudo" group
RUN useradd --user-group --create-home --shell /bin/false app && \
  usermod -aG sudo app && \
  sed -i.bkp -e \
  's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
  /etc/sudoers

RUN mkdir /work/mitmdump && \
  chown app /work/mitmdump

USER app

ENTRYPOINT ["/start.sh"]
