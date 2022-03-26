#!/vendor/bin/sh

cd $1
/system/bin/tar xzf modules.tar.gz
cp /vendor/bin/lkm_loader.sh .
/system/bin/sed -i "s:do_insmod.*/:do_insmod :" lkm_loader.sh
/vendor/bin/sh lkm_loader.sh early
/vendor/bin/sh lkm_loader.sh
