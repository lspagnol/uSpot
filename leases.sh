#!/bin/bash

file=/var/lib/dhcp/dhcpd.leases
EPOCH=$(date +%s)

cat ${file} | while read data ; do
	data=( $data )
	case ${data} in
		lease)
			ip=${data[1]}
		;;
		ends)
			ends=${data[2]} ; ends=${ends%;}
		;;
		binding)
			state=${data[2]} ; state=${state%;}
		;;
		hardware)
			mac=${data[2]} ; mac=${mac%;}
		;;
		"}")
			if [ "${state}" = "active" ] && [ ${ends} -gt ${EPOCH} ] ; then
				echo "${mac} ${ip}"
			fi
		;;
	esac
done |sort |uniq
