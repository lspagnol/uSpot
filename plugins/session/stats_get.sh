# Plugin: session/stats_get.sh
# Fonction: lecture des stats de session

########################################################################

for i in 0 1 2 3 ; do

	# Recuperer les stats dans netfilter
	data_dl[${i}]="$(IPT -nvxL DL${i} 2>/dev/null |awk '$1 ~ /^[0-9]+$/ { print $9" "$2 }' |grep "^${ip} ")"
	data_up[${i}]="$(IPT -nvxL UP${i} 2>/dev/null |awk '$1 ~ /^[0-9]+$/ { print $8" "$2 }' |grep "^${ip} ")"

	# Extraire la volumetrie
	bytes_dl[${i}]=${data_dl[${i}]#* }
	bytes_up[${i}]=${data_up[${i}]#* }

	# Affecter '0' aux valeurs nulles
	bytes_dl[${i}]=${bytes_dl[${i}]:-0}
	bytes_up[${i}]=${bytes_up[${i}]:-0}

done

########################################################################

true
