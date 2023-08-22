FROM ubuntu:lunar

### update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -q update
RUN apt-get -q -y upgrade

RUN apt-get -q -y install g++ git cmake meson pkg-config equivs sed
RUN apt-get -q -y install zlib1g-dev libpng-dev libjpeg-dev libtiff5-dev libgdk-pixbuf2.0-dev libxml2-dev libsqlite3-dev libcairo2-dev libglib2.0-dev

RUN mkdir /root/src
COPY . /root/src
WORKDIR /root/src

### openjpeg version in ubuntu 14.04 is 1.3, too old and does not have openslide required chroma subsampled images support.  download 2.5.0 from source and build
RUN ./install_openjpeg.sh

### Openslide
WORKDIR /root/src
RUN git clone https://github.com/openslide/openslide.git --branch=main --depth=1

## build openslide
WORKDIR /root/src/openslide
# For now, use head, dicom is getting new fixes

## test that openslide still automatically installs libdicom as a meson submodule
RUN test -e subprojects/libdicom.wrap
# if not, modify this Dockerfile to install it
# also for uthash, which is a dependency of libdicom

# RUN git checkout tags/v3.4.1
#RUN ./configure --enable-static --enable-shared=no
# may need to set OPENJPEG_CFLAGS='-I/usr/local/include' and OPENJPEG_LIBS='-L/usr/local/lib -lopenjp2'
# and the corresponding TIFF flags and libs to where bigtiff lib is installed.

RUN meson setup build_openslide -Ddicom=enabled

RUN meson compile -C build_openslide
RUN meson install -C build_openslide
RUN rm -r build_openslide

## build dummy apt packages
RUN mkdir equivs
RUN cd equivs
ADD libopenslide0 .

# libopenslide0
RUN equivs-build libopenslide0
RUN dpkg -i libopenslide0_3.4.2_all.deb

# libopenslide-dev
RUN sed -i 's/libopenslide0/libopenslide-dev/g' libopenslide0
RUN mv libopenslide0 libopenslide-dev
RUN equivs-build libopenslide-dev
RUN dpkg -i libopenslide-dev_3.4.2_all.deb

WORKDIR /
