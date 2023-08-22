# To see where, if it fails
set -x
set -e

# Note: This script should be early in any Dockerfile as JDKs are big

# Set up Java
# The link is from https://github.com/graalvm/graalvm-ce-builds/releases/
# To update, please remember to download the archive on your real machine
# and unzip it and update the "mv" source directory name here
wget -q "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-20.0.2/graalvm-community-jdk-20.0.2_linux-$(cat /platformid)_bin.tar.gz" -O jdk.tar.gz
tar -xzvf jdk.tar.gz > /dev/null
rm jdk.tar.gz
mv graalvm-community-openjdk-20.0.2+9.1 /java_home
