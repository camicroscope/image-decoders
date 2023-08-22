FROM ubuntu:lunar

### update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update
RUN apt-get -q -y upgrade

RUN apt-get -q -y install g++ git cmake meson pkg-config equivs sed wget
RUN apt-get -q -y install zlib1g-dev libpng-dev libjpeg-dev libtiff5-dev libgdk-pixbuf2.0-dev libxml2-dev libsqlite3-dev libcairo2-dev libglib2.0-dev

RUN mkdir /root/src
WORKDIR /root/src

### JDK
ARG TARGETARCH

RUN if [ "$TARGETARCH" = arm64 ]; then  \ 
echo aarch64 >> /platformid; \
else \
echo x64 >> /platformid; \
fi

COPY install_jdk.sh .
RUN chmod a+x install_jdk.sh
RUN ./install_jdk.sh

ENV JAVA_HOME=/java_home
ENV PATH="/java_home/bin:$PATH"

### bring the remaining
COPY . /root/src

### openjpeg version in ubuntu 14.04 is 1.3, too old and does not have openslide required chroma subsampled images support.  download 2.5.0 from source and build
WORKDIR /root/src
RUN ./install_openjpeg.sh

### OpenSlide
# alternative: apt-get install libopenslide-dev
WORKDIR /root/src
RUN ./install_openslide.sh

## Install dummy apt packages against competitor versions being installed
WORKDIR /root/src
RUN ./register_openslide_apt.sh

WORKDIR /
