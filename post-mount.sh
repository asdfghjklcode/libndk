#!/system/bin/sh
MODDIR=${0%/*}

resetprop ro.dalvik.vm.native.bridge "libndk_translation.so"
resetprop ro.dalvik.vm.isa.arm "x86"
resetprop ro.dalvik.vm.isa.arm64 "x86_64"
resetprop ro.enable.native.bridge.exec "1"

if [ ! -d /proc/sys/fs/binfmt_misc ]; then
    exit 1
fi

if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
fi

if [ -f /proc/sys/fs/binfmt_misc/register ]; then
    [ -f "$MODDIR/system/etc/binfmt_misc/arm64_dyn" ] && cat "$MODDIR/system/etc/binfmt_misc/arm64_dyn" > /proc/sys/fs/binfmt_misc/register 2>/dev/null
    [ -f "$MODDIR/system/etc/binfmt_misc/arm64_exe" ] && cat "$MODDIR/system/etc/binfmt_misc/arm64_exe" > /proc/sys/fs/binfmt_misc/register 2>/dev/null
    [ -f "$MODDIR/system/etc/binfmt_misc/arm_dyn" ] && cat "$MODDIR/system/etc/binfmt_misc/arm_dyn" > /proc/sys/fs/binfmt_misc/register 2>/dev/null
    [ -f "$MODDIR/system/etc/binfmt_misc/arm_exe" ] && cat "$MODDIR/system/etc/binfmt_misc/arm_exe" > /proc/sys/fs/binfmt_misc/register 2>/dev/null
fi

resetprop ro.product.cpu.abilist "x86_64,arm64-v8a"
resetprop ro.product.cpu.abilist64 "x86_64,arm64-v8a"

stop && start

