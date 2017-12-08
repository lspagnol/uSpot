# Plugin: check/quotas.sh
# Fonction: verifier les quotas de volumetrie 

########################################################################

for i in 0 1 2 3 ; do

	unset overquota[${i}]

	if [ ${max_bytes_class[${i}]} -ne 0 ] && [ ${total_bytes_class[${i}]} -ge ${max_bytes_class[${i}]} ] ; then
		if [ -z ${PERMIT_OVERQUOTA} ] ; then
			[ -z ${HTML} ] || echo -n "Quota atteint: ${NAME[${i}]}"
			reject=1
		else
			overquota[${i}]=1
		fi
	fi

done

########################################################################
# Mise en place des marques netfilter si necessaire

for i in 0 1 2 3 ; do

	if [ -z ${overquota[${i}]} ] ; then # Pas de depassement => supprimer la marque si necessaire

#		IPT -t mangle -C overquota -m mac --mac-source ${mac} -s ${ip} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]} 2>/dev/null
		IPT -t mangle -C overquota -m mac --mac-source ${mac} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]} 2>/dev/null
		if [ $? -eq 0 ] ; then
#			IPT -t mangle -D overquota -m mac --mac-source ${mac} -s ${ip} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]}
			IPT -t mangle -D overquota -m mac --mac-source ${mac} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]}
			[ -f "${OVERQUOTAS}/${mac} ${ip}" ] && rm "${OVERQUOTAS}/${mac} ${ip}"
			log "USER,QUOTA,STATUS: ${login},class${i},OK"
		fi

	else # Depassement => mise en place de la marque si necessaire

#		IPT -t mangle -C overquota -m mac --mac-source ${mac} -s ${ip} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]} 2>/dev/null
		IPT -t mangle -C overquota -m mac --mac-source ${mac} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]} 2>/dev/null
		if [ $? -ne 0 ] ; then
#			IPT -t mangle -A overquota -m mac --mac-source ${mac} -s ${ip} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]}
			IPT -t mangle -A overquota -m mac --mac-source ${mac} -j MARK --set-xmark ${MARK[${i}]}/${MARK[${i}]}
			echo "${mac} ${ip} ${login} CLASS${i}" > "${OVERQUOTAS}/${mac} ${ip}"
			log "USER,QUOTA,STATUS: ${login},class${i},OVERQUOTA"
		fi

	fi

done

########################################################################
# Rejet eventuel de la demande de session ('PERMIT_OVERQUOTA' vide)

if [ -z ${reject} ] ; then
	true
else
	false
fi
