# Plugin: iptables/stats_rules_add.sh
# Fonction: mise en place des compteurs de volumetrie

########################################################################

for i in 0 1 2 3 ; do

	IPT -C UP${i} -s ${ip} 2>/dev/null || IPT -A UP${i} -s ${ip} -j ACCEPT
	IPT -C DL${i} -d ${ip} 2>/dev/null || IPT -A DL${i} -d ${ip} -j ACCEPT

done

########################################################################

true
