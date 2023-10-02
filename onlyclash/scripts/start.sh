#!/system/bin/sh

MODDIR=/data/adb/modules/onlyclash
SCRIPTS_DIR=/data/adb/onlyclash/scripts
BIN_DIR=/data/adb/modules/onlyclash/system/bin/onlyclash

start_proxy() {
	${BIN_DIR} -start &>>/data/adb/onlyclash/run/onlyclash.log
}

if [ ! -f /data/adb/onlyclash/manual ]; then
	${BIN_DIR} &>/data/adb/onlyclash/run/onlyclash.log
	rm -rf /data/adb/onlyclash/run/core.pid
	if [ ! -f ${MODDIR}/disable ]; then
		start_proxy
	fi
	inotifyd ${SCRIPTS_DIR}/onlyclash.inotify ${MODDIR} &>>/data/adb/onlyclash/run/onlyclash.log &
fi
