# To see where, if it fails
set -x
set -e

# Use the main branch until we have a release with DICOM
# otherwise: --branch=v3.4.1, etc.
# IMPORTANT NOTE: If we're building OpenSlide instead of installing from apt-get
# whenever the version in meson.build in OpenSlide source code is updated,
# the version in our files "libopenslide0" and "register_openslide_apt.sh"
# needs to be updated to be a greater version number (or equal)
git clone https://github.com/openslide/openslide.git --branch=main --depth=1
cd openslide

## test that openslide still automatically installs libdicom as a meson submodule
# if not, modify this Dockerfile to install it
# also for uthash, which is a dependency of libdicom
test -e subprojects/libdicom.wrap

#./configure --enable-static --enable-shared=no
# may need to set OPENJPEG_CFLAGS='-I/usr/local/include' and OPENJPEG_LIBS='-L/usr/local/lib -lopenjp2'
# and the corresponding TIFF flags and libs to where bigtiff lib is installed.

meson setup build_openslide -Ddicom=enabled
meson compile -C build_openslide
meson install -C build_openslide
rm -r build_openslide
