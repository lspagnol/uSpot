# Plugin: periodic/check_quotas.sh
# Fonction: verification de TOUS les quotas de volumetrie

########################################################################

# Traiter les sessions du cache OVERQUOTAS
cat ${OVERQUOTAS}/* 2>/dev/null |while read session ; do

	session=(${session})

	mac=${session[0]}
	ip=${session[1]}
	login=${session[2]}

	# RAZ des valeurs
	for i in 0 1 2 3 ; do
		unset overquota[${i}]
		unset max_bytes_dl[${i}]
		unset max_bytes_up[${i}]
		unset max_bytes_class[${i}]
		unset total_bytes_dl[${i}]
		unset total_bytes_up[${i}]
		unset total_bytes_class[${i}]
	done

	for plugin in mysql/quotas_get.sh mysql/stats_get.sh session/stats_get.sh session/stats_fix.sh session/quotas_fix.sh check/quotas.sh ; do
		. ${USPOT}/plugins/${plugin}
	done

done

########################################################################

true
