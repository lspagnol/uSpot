# Plugin: session/stats_fix.sh
# Fonction: affecter '0' aux stats de session si necessaire

########################################################################

if [ -z ${sessions} ] ; then
	# Aucune valeur retournee par un autre plugin => utiliser le cache local
	sessions=$(cat ${SESSIONS}/* 2>/dev/null |cut -d, -f3 |grep -c "^${login}$")
fi

# Affecter '0' aux stats nulles
sessions=${sessions-0}
duration=${duration-0}
total_time=${total_time-0}

for i in 0 1 2 3 ; do
	total_bytes_dl[${i}]=${total_bytes_dl[${i}]-0}
	total_bytes_up[${i}]=${total_bytes_up[${i}]-0}
done

# Calculer les cumuls
for i in 0 1 2 3 ; do
	total_bytes_class[${i}]=$(( ${total_bytes_dl[${i}]} + ${total_bytes_up[${i}]} ))
done

########################################################################

true
