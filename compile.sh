#!/bin/bash
cd `dirname $0`
MYDIR=`pwd`
cd $MYDIR/../buildroot
rm -rf ~/buildroot/dl
if [ "$1" != "" ]; then
 rm -rf output/build/$1*
fi
make BR2_INSTRUMENTATION_SCRIPTS="$MYDIR/log.sh"