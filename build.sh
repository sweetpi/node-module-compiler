#!/bin/sh -e
if [ -z "$HOST" ]; then
  HOST=arm-bcm2708hardfp-linux-gnueabi
fi

DIR=`pwd`
export PATH=$PATH:$DIR/tools/arm-bcm2708/$HOST/bin
export CPP="${HOST}-gcc -E"
export STRIP="${HOST}-strip"
export OBJCOPY="${HOST}-objcopy"
export AR="${HOST}-ar"
export RANLIB="${HOST}-ranlib"
#export LD="${HOST}-ld"
export OBJDUMP="${HOST}-objdump"
export CC="${HOST}-gcc"
export CXX="${HOST}-g++"
export LD="$CXX"
export NM="${HOST}-nm"
export AS="${HOST}-as"
export PS1="[${HOST}] \w$ "
export GYP_DEFINES="armv7=0"
export CCFLAGS='-march=armv6'
export CXXFLAGS='-march=armv6'
uname -a 
# file /home/travis/build/sweetpi/node-module-compiler/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-gcc
# file $DIR/tools/arm-bcm2708/$HOST/bin/arm-bcm2708-linux-gnueabi-gcc
# ls -al $DIR/tools/arm-bcm2708/$HOST/bin/arm-bcm2708-linux-gnueabi-gcc
$CPP --version
PARAMS="--build-from-source --platform=linux --arch=x64 --target_arch=arm --target_platform=linux"
VERBOSE=1 npm install ${MODULE} ${PARAMS}
if [ "$MODULE" = "pimatic" ]; then
  cd node_modules/pimatic
  VERBOSE=1 npm install sqlite3 ${PARAMS}
  cd $DIR
fi
npm install coffee-script@1.8.0 fs.extra colors
node ./coffee-cache-compiler.js ./node_modules/${MODULE}
