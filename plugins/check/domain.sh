# Plugin: check/domain.sh
# Fonction: verifier si le domaine de l'identifiant est autorise

########################################################################

if [ ! -z ${BLACKLISTED_DOMAINS} ] ; then
	echo "${login}" |egrep -q "${BLACKLISTED_DOMAINS}"
	if [ $? -eq 0 ] ; then
		[ -z ${HTML} ] || echo -n "Votre domaine est en liste noire !"
		reject=1
	fi
fi

########################################################################

if [ -z ${reject} ] ; then
	true
else
	false
fi
