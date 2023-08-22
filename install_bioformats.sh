# To see where, if it fails
set -x
set -e

# disable git warnings about saving edits to head
git config --global advice.detachedHead false

# Please remember to update version here
git clone https://github.com/camicroscope/BFBridge.git bfbridge -q --branch v0.1 --depth 1
cd bfbridge
mkdir /root/src/bfbridge/jar_files/
cd /root/src/bfbridge/jar_files/

## BioFormats

# URL from: https://downloads.openmicroscopy.org/bio-formats/7.0.0/artifacts/
wget -q https://downloads.openmicroscopy.org/bio-formats/7.0.0/artifacts/bioformats_package.jar -O bioformats_all_in_one_compressed.jar

# uncompress early and store without compression for performance
unzip -q bioformats_all_in_one_compressed.jar -d temp
cd temp
zip -0 -q -r ../bioformats_all_in_one.jar *
cd ..
rm -r temp
rm bioformats_all_in_one_compressed.jar

# remove this the following lines to print all debug info
# link can be found by searching slf4j simple jar 1.X (not 2.X as of BioFormats 7)
wget -q https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.36/slf4j-simple-1.7.36.jar -O logger_printing_errors_only_compressed.jar

# likewise
unzip -q logger_printing_errors_only_compressed.jar -d temp
cd temp
zip -0 -q -r logger_printing_errors_only.jar *
cd ..
rm -r temp
rm logger_printing_errors_only_compressed.jar



## BioFormats wrapper

cd /root/src/bfbridge/java

# todo deleteme
#ls /root/src/bfbridge/jar_files/
#ls ../jar_files/
#jar tvf ../jar_files/bioformats_all_in_one.jar
#apt install file
#file /root/src/bfbridge/jar_files/bioformats_all_in_one.jar
#xqddw

# Classpath of "." and "../jar_files/*" means look for Java classes in this folder
# (which contains:  org/camicroscope/*) and in ../jar_files/* (containing:
# bioformats package jar). So each element is a folder containing classes or a Jar file
# hence not "../jar_files/", as this is a folder containing a Jar file, so neither.
javac -cp ".:../jar_files/*" org/camicroscope/BFBridge.java

# pack into uncompressed Jar
jar c0f BfBridge.jar org/camicroscope/*.class


## Move them to a single directory
mv /root/src/bfbridge/java/BfBridge.jar /usr/lib/java
mv /root/src/bfbridge/jar_files/* /usr/lib/java

#### Missing optimization: Packing them to a single Jar