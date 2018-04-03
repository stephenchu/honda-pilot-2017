#!/system/bin/sh

lmem_clear_dctr_data

sh2a_audio_onoff 0

submicom_reset -f

umount /mnt/shell/emulated

echo -n "0000" | dd of=/dev/block/mtdblock25 obs=4 seek=1 count=1

mkdir /tmp/reset_backup
cp /data/system/alps/evolution/csr8311_eeprom.psr /tmp/reset_backup/
cp /data/system/alps/evolution/default_mib.txt /tmp/reset_backup/
cp /data/property/persist.da_settings.carplay.on /tmp/reset_backup/
cp /data/property/persist.da_settings.andauto.on /tmp/reset_backup/
#restore sharedpreferences
if [ -e /data/data/com.clarion.displayaudio.antitheftapl/shared_prefs/antitheft.xml ];then
    cp /data/data/com.clarion.displayaudio.antitheftapl/shared_prefs/antitheft.xml /tmp/reset_backup/
fi
if [ -e /data/data/com.clarion.displayaudio.smartphonediag/shared_prefs/SmartPhoneDiagSharedPref.xml ];then
    cp /data/data/com.clarion.displayaudio.smartphonediag/shared_prefs/SmartPhoneDiagSharedPref.xml /tmp/reset_backup/
fi
if [ -e /data/data/com.google.android.projection.sink/shared_prefs/OAASettingSharedPref.xml ];then
    cp /data/data/com.google.android.projection.sink/shared_prefs/OAASettingSharedPref.xml /tmp/reset_backup/
fi

mkdir /tmp/mnt
mount -t ext4 /dev/block/mmcblk0p8 /tmp/mnt
if [ -e /tmp/mnt/data_org.tar.gz ];then
	echo -n "FRST" | dd of=/dev/block/mtdblock16 obs=4 seek=1 count=1
	cp /data/system/alps/evolution/csr8311_eeprom.psr /tmp/mnt/
	cp /data/system/alps/evolution/default_mib.txt /tmp/mnt/
	cp /data/property/persist.da_settings.carplay.on /tmp/mnt/
	cp /data/property/persist.da_settings.andauto.on /tmp/mnt/
	touch /tmp/mnt/factory_reset

    if [ -e /tmp/mnt/antitheft.xml ];then
        rm /tmp/mnt/antitheft.xml
    fi
    if [ -e /data/data/com.clarion.displayaudio.antitheftapl/shared_prefs/antitheft.xml ];then
    	cp /data/data/com.clarion.displayaudio.antitheftapl/shared_prefs/antitheft.xml /tmp/mnt/
    fi
    if [ -e /data/data/com.clarion.displayaudio.smartphonediag/shared_prefs/SmartPhoneDiagSharedPref.xml ];then
    	cp /data/data/com.clarion.displayaudio.smartphonediag/shared_prefs/SmartPhoneDiagSharedPref.xml /tmp/mnt/
    fi
    if [ -e /data/data/com.google.android.projection.sink/shared_prefs/OAASettingSharedPref.xml ];then
    	cp /data/data/com.google.android.projection.sink/shared_prefs/OAASettingSharedPref.xml /tmp/mnt/
    fi
	sync
#	busybox gunzip -c /tmp/mnt/data_org.tar.gz | busybox tar x -C /data
#	sync
#	if [ -e /tmp/mnt/warp_management.img ];then
#		dd if=/tmp/mnt/warp_management.img of=/dev/block/mtdblock22
#	fi
else
	rm -rf /data/*
	cp -rp /system/etc/data.org/* /data/
	cp /tmp/reset_backup/csr8311_eeprom.psr /data/system/alps/evolution/
	chown 1000.1000  /data/system/alps/evolution/csr8311_eeprom.psr
	chmod 0644 /data/system/alps/evolution/csr8311_eeprom.psr
	cp /tmp/reset_backup/default_mib.txt /data/system/alps/evolution/
	chown 1000.1000  /data/system/alps/evolution/default_mib.txt
	chmod 0644 /data/system/alps/evolution/default_mib.txt
    if [ ! -e /data/property ];then
        mkdir -p /data/property/
    fi
	cp /tmp/reset_backup/persist.da_settings.carplay.on /data/property/
	cp /tmp/reset_backup/persist.da_settings.andauto.on /data/property/

	mkdir /data/system/backup
	chown 1000.1000 /data/backup
	chmod 0700 /data/backup
	cp /tmp/reset_backup/*.xml /data/system/backup/

	rm -rf /var/log/*
	sync
	sync

	dd if=/dev/zero of=/dev/block/mtdblock16
fi
umount /tmp/mnt

dd if=/dev/zero of=/dev/block/mtdblock22

reboot
