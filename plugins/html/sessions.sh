# Plugin: html/sessions.sh
# Fonction: afficher le nombre de sessions ouvertes

########################################################################

if [  ! -z ${HTML} ] ; then
	echo -n "Sessions actives: $(( ${sessions} + 1))"
	[ ${max_sessions} -ne 0 ] && echo -n "/${max_sessions}"
	echo -n "<br>"
fi

########################################################################

true
