#!/bin/sh

echo "[OUROBOROS] SHUTTING DOWN SERVICES..."
/etc/init.d/S99ouroboros stop

echo "[OUROBOROS] PREPARING RAM-BASED EXECUTION..."
# Create a robust RAM-disk
mkdir -p /tmp/suicide_zone
mount -t tmpfs -o size=20M tmpfs /tmp/suicide_zone
mkdir -p /tmp/suicide_zone/bin /tmp/suicide_zone/lib /tmp/suicide_zone/lib64

# Copy everything needed to RAM
cp -a /bin/busybox /tmp/suicide_zone/bin/
cp -a /lib/* /tmp/suicide_zone/lib/
[ -d /lib64 ] && cp -a /lib64/* /tmp/suicide_zone/lib64/

echo "[OUROBOROS] BINDING RAM TO ROOT..."
# This is the magic: tell the kernel that /bin and /lib are now in RAM
mount --bind /tmp/suicide_zone/bin /bin
mount --bind /tmp/suicide_zone/lib /lib
[ -d /lib64 ] && mount --bind /tmp/suicide_zone/lib64 /lib64

echo "[OUROBOROS] BEGINNING DISK WIPE..."
# We use the 'busybox' command directly. 
# It works now because /bin/busybox and /lib/* are pointed to RAM!
busybox rm -rf /etc /root /sbin /usr /var /home

echo "[OUROBOROS] WIPE COMPLETE. TRIGGERING KERNEL PANIC..."
# No more path errors. The system thinks these files are still in /bin
echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger
