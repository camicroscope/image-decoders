# To see where, if it fails
set -x
set -e

mkdir equivs
cd equivs
cp ../libopenslide0 .

# libopenslide0
equivs-build libopenslide0
dpkg -i libopenslide0_4.1.0_all.deb

# libopenslide-dev
sed -i 's/libopenslide0/libopenslide-dev/g' libopenslide0
mv libopenslide0 libopenslide-dev
equivs-build libopenslide-dev
dpkg -i libopenslide-dev_4.1.0_all.deb
