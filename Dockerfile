FROM lsiobase/alpine:3.8

# package version
ARG MEDIAINF_VER="18.05"
ARG RTORRENT_VER="0.9.7"
ARG LIBTORRENT_VER="0.13.7"
ARG CURL_VER="7.61.0"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV CONTEXT_PATH=/
ENV PUID=0
ENV PGID=0
ENV RTORRENT_SCGI=0
    
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    bash-completion \
    ca-certificates \
    ffmpeg \
    curl \
    gzip \
    dtach \
    tar \
    unrar \
    unzip \
    sox \
    wget \
    mediainfo \
    libmediainfo \
    zlib \
    zlib-dev \
    git \
    libressl \
    binutils \
    findutils \
    python \
    zip && \
# install build packages
  apk add --no-cache --virtual=build-dependencies \
    autoconf \
    automake \
    cppunit-dev \
    perl-dev \
    file \
    g++ \
    gcc \
    libtool \
    make \
    ncurses-dev \
    build-base \
    libtool \
    subversion \
    cppunit-dev \
    linux-headers \
    curl-dev \
    libressl-dev && \
# compile curl to fix ssl for rtorrent
  cd /tmp && \
  mkdir curl && \
  cd curl && \
  wget -qO- https://curl.haxx.se/download/curl-${CURL_VER}.tar.gz | tar xz --strip 1 && \
  ./configure --with-ssl && make -j ${NB_CORES} && make install && \
  ldconfig /usr/bin && ldconfig /usr/lib && \
# compile xmlrpc-c
  cd /tmp && \
  svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c && \
  cd /tmp/xmlrpc-c && \
  ./configure --with-libwww-ssl --disable-wininet-client --disable-curl-client --disable-libwww-client --disable-abyss-server --disable-cgi-server && make -j ${NB_CORES} && make install && \
# compile libtorrent
  apk add -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main -U cppunit-dev==1.13.2-r1 cppunit==1.13.2-r1 && \
  cd /tmp && \
  mkdir libtorrent && \
  cd libtorrent && \
  wget -qO- https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/libtorrent-${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 && \
  ./autogen.sh && ./configure && make -j ${NB_CORES} && make install && \
# compile rtorrent
  cd /tmp && \
  mkdir rtorrent && \
  cd rtorrent && \
  wget -qO- https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/rtorrent-${RTORRENT_VER}.tar.gz | tar xz --strip 1 && \
  ./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install && \
# cleanup
  apk del --purge build-dependencies && \
  apk del -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main \
    cppunit-dev && \
  rm -rf /tmp/* && \
# create home folder
  mkdir /home/torrent     