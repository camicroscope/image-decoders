# To see where, if it fails
set -x
set -e

git clone https://github.com/uclouvain/openjpeg.git --branch=v2.5.0 --depth=1
mkdir /root/src/openjpeg/build
cd /root/src/openjpeg/build
cmake -DBUILD_JPIP=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_CODEC=ON -DBUILD_PKGCONFIG_FILES=ON -DBUILD_JAVA=OFF ../
make
make install
