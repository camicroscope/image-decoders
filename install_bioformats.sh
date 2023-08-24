# To see where, if it fails
set -x
set -e

## BioFormats

mkdir bioformats
cd bioformats

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

# to verify jar contents, you may do:
# jar tvf ../jar_files/bioformats_all_in_one.jar

## Move them to a single directory
mv /root/src/bioformats/* /usr/lib/java

#### Missing optimization: Packing all Jars to a single Jar
