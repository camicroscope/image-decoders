FROM ubuntu:lunar

### update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update
RUN apt-get -q -y upgrade

RUN apt-get -q -y install g++ git cmake meson pkg-config equivs sed wget zip unzip
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

### BioFormats
RUN mkdir -p /usr/lib/java
ENV BFBRIDGE_CLASSPATH=/usr/lib/java
ENV CLASSPATH=/usr/lib/java
ENV BFBRIDGE_CACHEDIR=/tmp/

WORKDIR /root/src
COPY install_bioformats.sh .
RUN chmod a+x install_bioformats.sh
RUN ./install_bioformats.sh

WORKDIR /root/src
COPY install_bfbridge.sh .
RUN chmod a+x install_bfbridge.sh
RUN ./install_bfbridge.sh

### bring the remaining files
## (previous ones needed extra caching due to their size)
COPY . /root/src

### openjpeg version in ubuntu 14.04 is 1.3, too old and does not have openslide required chroma subsampled images support.  download 2.5.0 from source and build
WORKDIR /root/src
RUN chmod a+x install_openjpeg.sh
RUN ./install_openjpeg.sh

### OpenSlide
# alternative: apt-get install libopenslide-dev
WORKDIR /root/src
RUN chmod a+x install_openslide.sh
RUN ./install_openslide.sh

## Install dummy apt packages against competitor versions being installed
WORKDIR /root/src
RUN chmod a+x register_openslide_apt.sh
RUN ./register_openslide_apt.sh

WORKDIR /
