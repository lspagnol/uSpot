# Plugin: check/sessions.sh
# Fonction: verifier le nombre de sessions ouvertes

########################################################################

if [ ${max_sessions} -ne 0 ] && [ ${sessions} -ge ${max_sessions} ] ; then
	[ -z ${HTML} ] || echo -n "Vous ne pouvez pas ouvrir plus de ${max_sessions} sessions simultan&eacute;ment !"
	reject=1
fi

########################################################################

if [ -z ${reject} ] ; then
	true
else
	false
fi
