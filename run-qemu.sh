#!/bin/sh

BINARIES_DIR="${0%/*}/"
# shellcheck disable=SC2164
cd "${BINARIES_DIR}"

mode_serial=true
mode_sys_qemu=false
while [ "$1" ]; do
    case "$1" in
    --serial-only|serial-only) mode_serial=true; shift;;
    --use-system-qemu) mode_sys_qemu=true; shift;;
    --) shift; break;;
    *) echo "unknown option: $1" >&2; exit 1;;
    esac
done

if ${mode_serial}; then
    EXTRA_ARGS='-nographic'
else
    EXTRA_ARGS='-serial stdio'
fi

if ! ${mode_sys_qemu}; then
    export PATH="/home/smaran/Desktop/OuroborOS/buildroot/output/host/bin:${PATH}"
fi

exec qemu-system-x86_64 -M pc \
    -kernel "buildroot/output/images/bzImage" \
    -drive file="buildroot/output/images/rootfs.ext2",if=virtio,format=raw \
    -append "rootwait root=/dev/vda console=ttyS0 lpj=10000000 clocksource=pit notsc noapic" \
    -net nic,model=virtio -net user,hostfwd=tcp::9000-:9000 \
    ${EXTRA_ARGS} -accel tcg "$@" \
    -rtc base=utc,clock=vm -icount shift=auto,sleep=on
