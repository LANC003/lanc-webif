#!/bin/bash

#

TOOLS=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. ${TOOLS}/env.sh

#

function rw_sysfs
{
	if [ -z  "$2" ] ; then
		cat "${SYS}/$1"
	else
		echo -n "$2" > "${SYS}/$1"
	fi
}

#

function lanc_default_settings
{
	# default 'lanc' settings

	uci_set "lanc" "general" "g1" "xxx"
	uci_set "lanc" "general" "g2" "yyy"

	uci_set "lanc" "advanced" "v1" "10"
	uci_set "lanc" "advanced" "v2" "100"

	uci_set "lanc" "expert" "e1" "0"
	uci_set "lanc" "expert" "e2" "1"

	uci_commit "lanc"
}

#

function lanc_prepare_settings
{
	uci_load lanc

	config_get g1 "general" "g1"
	config_get g2 "general" "g2"

	config_get a1 "advanced" "v1"
	config_get a1 "advanced" "v2"

	config_get e1 "expert" "e1"
	config_get e2 "expert" "e2"

	# use $g1, $g2, $a1, $a2, $e1, $e2

}

#
# put_to_video <address> <file>
#

function put_to_video
{
	# devmem4 { device } { address } { type }  { file } [ { size } ]
	devmem4 /dev/mtd6 $1 w $2 2>&1 1>/dev/null
}

#
# get_from_video <address> <output file> <size>
#

function get_from_video
{
	# devmem4 { device } { address } { type }  { file } [ { size } ]
	devmem4 /dev/mtd6 $1 r $2 $3  2>&1 1>/dev/null
}

#
# put_to_control <address> <file>
#

function put_to_control
{
	addr=$((0x10000000 + $1))
	# devmem4 { device } { address } { type }  { file } [ { size } ]
	devmem4 /dev/mtd6 $addr w $2 2>&1 1>/dev/null
}

#
# get_from_control <address> <output file> <size>
#

function get_from_control
{
	addr=$((0x10000000 + $1))
	# devmem4 { device } { address } { type }  { file } [ { size } ]
	devmem4 /dev/mtd6 $addr r $2 $3  2>&1 1>/dev/null
}

#

SYS_SMC=/sys/devices/platform/lanc-smc.0

function smc_timing
{
	if [ -z  "$2" ] ; then
		cat "${SYS_SMC}/$1"
	else
		echo -n "$2" > "${SYS_SMC}/$1"
	fi
}
