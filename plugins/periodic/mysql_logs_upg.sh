# Plugin: periodic/mysql_log_upg.sh
# Fonction: mise a jour de TOUTES les stats de volumetrie

########################################################################

for i in 0 1 2 3 ; do

	IPT -nvxL DL${i} \
	 |egrep "^[[:space:]]*[0-9]+"\
	 |awk -v i=${i} '{print "UPDATE logs SET log_bytes_dl"i"="$2" WHERE log_ip="$9" AND log_revoke IS NULL;"}'

	IPT -nvxL UP${i} \
	 |egrep "^[[:space:]]*[0-9]+"\
	 |awk -v i=${i} '{print "UPDATE logs SET log_bytes_up"i"="$2" WHERE log_ip="$8" AND log_revoke IS NULL;"}'

done |sed -e "s/=/=\'/g ; s/ WHERE /\' WHERE /g ;  s/ AND /\' AND /g" |MYSQL

########################################################################

true
