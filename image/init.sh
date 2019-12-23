#!/bin/sh
#Create all the symlinks to /bin/busybox
/bin/busybox --install -s

#Mount things needed by this script
mount -t proc proc /proc
mount -t sysfs sysfs /sys

#Disable kernel messages from popping onto the screen
echo 0 > /proc/sys/kernel/printk

#Clear the screen
clear


#Create device nodes
mknod /dev/null c 1 3
mknod /dev/tty c 5 0
mdev -s

#Function for parsing command line options with "=" in them
# get_opt("init=/sbin/init") will return "/sbin/init"
get_opt() {
	echo "$@" | cut -d "=" -f 2
}

#load kernel modules
#modprobe virtio
#modprobe virtio_pci
#modprobe virtio_net

#modprobe ip6table_filter
#modprobe ip6table_mangle
#modprobe ip6table_raw
#modprobe ipv6
#modprobe nf_conntrack_ipv6

#network config
#ifconfig lo 127.0.0.1
#ifconfig lo up
#ifconfig eth0 10.0.0.138
#ifconfig eth0 up

#install iptables
ln -s -f /bin/xtable-multis /sbin/iptables
ln -s -f /bin/xtable-multis /sbin/iptables-save
ln -s -f /bin/xtable-multis /sbin/iptables-restore
ln -s -f /bin/xtable-multis /sbin/ip6tables
ln -s -f /bin/xtable-multis /sbin/ip6tables-save
ln -s -f /bin/xtable-multis /sbin/ip6tables-restore

#Defaults
init="/sbin/init"
root="/dev/hda1"

#Process command line options
for i in $(cat /proc/cmdline); do
	case $i in
		root\=*)
			root=$(get_opt $i)
			;;
		init\=*)
			init=$(get_opt $i)
			;;
	esac
done

#Mount the root device
#mount "${root}" /newroot

#Check if $init exists and is executable
#if [[ -x "/newroot/${init}" ]] ; then
	#Unmount all other mounts so that the ram used by
	#the initramfs can be cleared after switch_root
	#umount /sys /proc
	
	#Switch to the new root and execute init
	#exec switch_root /newroot "${init}"
#fi

#This will only be run if the exec above failed
echo "Failed to switch_root, dropping to a shell"
exec sh
