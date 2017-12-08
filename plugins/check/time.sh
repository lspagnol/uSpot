# Plugin: check/time.sh
# Fonction: verifier la duree de connexion totale

########################################################################

if [ ${max_time} -ne 0 ] && [ ${total_time} -ge ${max_time} ] ; then
	[ -z ${HTML} ] || echo -n "Quota atteint: dur&eacute;e totale de connexion"
	reject=1
fi

########################################################################

if [ -z ${reject} ] ; then
	true
else
	false
fi
