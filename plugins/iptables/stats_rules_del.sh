# Plugin: iptables/stats_rules_del.sh
# Fonction: suppression des compteurs de volumetrie

########################################################################

for i in 0 1 2 3 ; do

	IPT -C UP${i} -s ${ip} -j ACCEPT 2>/dev/null >/dev/null && IPT -D UP${i} -s ${ip} -j ACCEPT 
	IPT -C DL${i} -d ${ip} -j ACCEPT 2>/dev/null >/dev/null && IPT -D DL${i} -d ${ip} -j ACCEPT 

done

########################################################################

true
