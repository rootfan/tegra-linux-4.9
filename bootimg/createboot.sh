#! /bin/bash
# for this script to work, place a stock boot.img in its directory

# see if magisk files are available and download if necessary
if [ ! -e ./magiskboot ]
then
echo "Downloading magisk app..."
rm Magisk*apk

curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest \
| grep "browser_download_url.*Magisk-v.*" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

rm -r lib
unzip $(ls | grep "Magisk.*apk") lib/x86/libmagiskboot.so lib/armeabi-v7a/libmagisk32.so lib/arm64-v8a/libmagisk64.so lib/arm64-v8a/libmagiskinit.so
mv lib/x86/libmagiskboot.so magiskboot
chmod 755 magiskboot
./magiskboot compress=xz lib/armeabi-v7a/libmagisk32.so magisk32.xz
./magiskboot compress=xz lib/arm64-v8a/libmagisk64.so magisk64.xz

fi

cp ../out/arch/arm64/boot/zImage kernel.gz
rm kernel
gunzip kernel.gz

# Force kernel to load rootfs
# skip_initramfs -> want_initramfs
./magiskboot hexpatch kernel \
736B69705F696E697472616D667300 \
77616E745F696E697472616D667300

# collect all modules in a tar archive
rm -r modules.tar.gz

for module in $(cat modlist.txt)
do 
find ../out -name $module -execdir tar rf $PWD/modules.tar $module \;
done

gzip modules.tar

rm ramdisk.cpio

./magiskboot cpio ramdisk.cpio \
"add 0750 init lib/arm64-v8a/libmagiskinit.so" \
"mkdir 0700 overlay.d" \
"add 0700 overlay.d/modules.rc modules.rc" \
"mkdir 0700 overlay.d/sbin" \
"add 0700 overlay.d/sbin/magisk32.xz magisk32.xz" \
"add 0700 overlay.d/sbin/magisk64.xz magisk64.xz" \
"add 0700 overlay.d/sbin/modloader.sh modloader.sh" \
"add 0700 overlay.d/sbin/modules.tar.gz modules.tar.gz" 

./magiskboot repack boot.img
