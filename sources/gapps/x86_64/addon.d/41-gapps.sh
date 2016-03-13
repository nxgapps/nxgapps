#!/sbin/sh
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
# /system/addon.d/41-gapps.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
addon.d/41-gapps.sh
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/PrebuiltGmsCore/lib/x86_64/libAppDataSearch.so
priv-app/PrebuiltGmsCore/lib/x86_64/libappstreaming_jni.so
priv-app/PrebuiltGmsCore/lib/x86_64/libconscrypt_gmscore_jni.so
priv-app/PrebuiltGmsCore/lib/x86_64/libdirect-audio.so
priv-app/PrebuiltGmsCore/lib/x86_64/libgcastv2_base.so
priv-app/PrebuiltGmsCore/lib/x86_64/libgcastv2_support.so
priv-app/PrebuiltGmsCore/lib/x86_64/libgmscore.so
priv-app/PrebuiltGmsCore/lib/x86_64/libgms-ocrclient.so
priv-app/PrebuiltGmsCore/lib/x86_64/libjgcastservice.so
priv-app/PrebuiltGmsCore/lib/x86_64/libleveldbjni.so
priv-app/PrebuiltGmsCore/lib/x86_64/linNearbyApp.so
priv-app/PrebuiltGmsCore/lib/x86_64/libsslwrapper_jni.so
priv-app/PrebuiltGmsCore/lib/x86_64/libwearable-selector.so
priv-app/PrebuiltGmsCore/lib/x86_64/libWhisper.so
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac