# Plugin: misc/stats_syslog.sh
# Fonction: envoyer stats de session vers SYSLOG

########################################################################

for i in 0 1 2 3 ; do

	log "SESSION,BYTES_DL${i},BYTES_UP${i}: ${access_data},${bytes_dl[${i}]},${bytes_up[${i}]}"

done

########################################################################

true
