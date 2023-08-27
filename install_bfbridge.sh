# To see where, if it fails
set -x
set -e

# disable git warnings about saving edits to head
git config --global advice.detachedHead false

# Please remember to update version here
git clone https://github.com/camicroscope/BFBridge.git -q --branch v0.15 --depth 1 && rm -r BFBridge/.git

## BioFormats wrapper

cd /root/src/BFBridge/java

# Classpath of "." and "/usr/lib/java/*" means look for Java classes in this folder
# (which contains:  org/camicroscope/*) and in /usr/lib/java/* (containing:
# bioformats package jar). So each element is a folder containing classes or a Jar file
# hence not "/usr/lib/java/", as this is a folder containing a Jar file, so neither.
javac -cp ".:/usr/lib/java/*" org/camicroscope/BFBridge.java

# pack into uncompressed Jar
jar c0f BfBridge.jar org/camicroscope/*.class

## Move them to a single directory
mv /root/src/BFBridge/java/BfBridge.jar /usr/lib/java
