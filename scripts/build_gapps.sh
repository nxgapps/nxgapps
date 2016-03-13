#!/bin/sh
#This file is part of The NX GApps Project script of @AlexLartsev19.
#
#    The NX GApps Project scripts are free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    These scripts are distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
##
# var
#
DATE=$(date +"%Y%m%d")
TOP=$(realpath .)
ANDROIDV=5.1.1
OUT=$TOP/out
SCRIPTS=$TOP/scripts
INSTALL=$SCRIPTS/installshell
SIGN=$SCRIPTS/signshell
CORE=$TOP/sources/gapps/core
GLOG=/tmp/gapps_log

##
# functions
#
function printerr(){
  echo "$(tput setaf 1)$1$(tput sgr 0)"
}

function printdone(){
  echo "$(tput setaf 2)$1$(tput sgr 0)"
}

function clean(){
    echo "Cleaning up..."
    rm -r $OUT/$ARCH
    rm /tmp/$BUILDZIP
    return $?
}

function Gfailed(){
    printerr "Build failed, check $GLOG"
    exit 1
}

function create(){
    test -f $GLOG && rm -f $GLOG
    echo "Starting GApps compilation" > $GLOG
    echo "ARCH= $ARCH" >> $GLOG
    echo "OS= $(uname -s -r)" >> $GLOG
    echo "NAME= $(whoami) at $(uname -n)" >> $GLOG
    SOURCES=$TOP/sources/gapps/$ARCH
    test -d $OUT || mkdir $OUT;
    test -d $OUT/$ARCH || mkdir -p $OUT/$ARCH
    echo "Build directories are now ready" >> $GLOG
    echo "Getting prebuilts..."
    echo "Copying stuffs" >> $GLOG
    cp -r $SOURCES $OUT/$ARCH >> $GLOG
    mv $OUT/$ARCH/$ARCH $OUT/$ARCH/arch >> $GLOG
    cp -r $CORE $OUT/$ARCH >> $GLOG
}

function zipit(){
    BUILDZIP=nx-gapps-$ARCH-$ANDROIDV-$DATE.zip
    echo "Copying installation scripts..."
    cp -r $INSTALL $OUT/$ARCH/META-INF && echo "Meta copied" >> $GLOG
    echo "Creating zip package..."
    cd $OUT/$ARCH
    zip -r /tmp/$BUILDZIP . >> $GLOG
    rm -rf $OUT/tmp >> $GLOG
    cd $TOP
    if [ -f /tmp/$BUILDZIP ]; then
        echo "Signing zip package..."
        java -Xmx2048m -jar $SIGN/signapk.jar -w $SIGN/testkey.x509.pem $SIGN/testkey.pk8 /tmp/$BUILDZIP $OUT/$BUILDZIP >> $GLOG
    else
        printerr "Couldn't zip files!"
        echo "Couldn't find unsigned zip file, aborting" >> $GLOG
        return 1
    fi
}

function getmd5(){
    if [ -x $(which md5sum) ]; then
        echo "md5sum is installed, getting md5..." >> $GLOG
        echo "Getting md5sum..."
        GMD5=$(md5sum $OUT/$BUILDZIP)
        echo -e "$GMD5" > $OUT/nx-gapps-$ARCH-$ANDROIDV-$DATE.zip.md5
        echo "md5 exported at $OUT/nx-gapps-$ARCH-$ANDROIDV-$DATE.zip.md5"
        return 0
    else
        echo "md5sum is not installed, aborting" >> $GLOG
        return 1
    fi
}

##
# main
#
ARCH=$1
create
LASTRETURN=$?
if [ -x $(which realpath) ]; then
    echo "Realpath found!" >> $GLOG
else
    TOP=$(cd . && pwd) # some os X love
    echo "No realpath found!" >> $GLOG
fi
if [ "$LASTRETURN" == 0 ]; then
    zipit
    LASTRETURN=$?
    if [ "$LASTRETURN" == 0 ]; then
        getmd5
        LASTRETURN=$?
        if [ "$LASTRETURN" == 0 ]; then
            clean
            LASTRETURN=$?
            if [ "$LASTRETURN" == 0 ]; then
                echo "Done!" >> $GLOG
                printdone "Build completed: $GMD5"
                exit 0
            else
                Gfailed
            fi
        else
            Gfailed
        fi
    else
        Gfailed
    fi
else
    Gfailed
fi
