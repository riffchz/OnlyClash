#!/system/bin/sh

SKIPUNZIP=1
ASH_STANDALONE=1
ADB_PATH="/data/adb"
SERVICE_DIR="$ADB_PATH/service.d"

check_util() {
	if [ "$BOOTMODE" != true ]; then
		abort "Please install in Magisk Manager or KernelSU Manager"
	elif [ "$KSU" = true ] && [ "$KSU_VER_CODE" -lt 10670 ]; then
		abort "ERROR: Please update your KernelSU and KernelSU Manager"
	fi

	if [ "$API" -lt 28 ]; then
		abort "Min supported sdk is 28 (Android 9)"
	else
		ui_print "Device sdk: $API"
	fi

	if [ "$KSU" = true ]; then
		[ "$KSU_VER_CODE" -lt 10683 ] && SERVICE_DIR="${ADB_PATH}/ksu/service.d"
	fi
	if [ ! -d ${SERVICE_DIR} ]; then
		mkdir -p ${SERVICE_DIR}
	fi
}

init_file() {
	ui_print "Installing Clash Magisk/KernelSU"
	unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
	mv -f "$MODPATH/onlyclash" "${ADB_PATH}/"
	mv -f "$MODPATH/onlyclash_service.sh" "${SERVICE_DIR}/"
}

set_perm_file() {
	set_perm "${SERVICE_DIR}/onlyclash_service.sh" 0 0 0755
	set_perm_recursive "$ADB_PATH/onlyclash/scripts" 0 0 0755 0755
	set_perm_recursive "$MODPATH" 0 0 0777 0755
	set_perm_recursive "$MODPATH/system/bin" 0 0 0777 0755
}

main() {
	check_util
	init_file
	set_perm_file
}

main
