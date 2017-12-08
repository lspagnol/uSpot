# Plugin: html/last_connexion.sh
# Fonction: afficher la date de la derniere connexion

########################################################################

if [  ! -z ${HTML} ] ; then
	[ "${last_session}" = "" ] || echo -n "<b>Derni&egrave;re connexion le ${last_session% *} &agrave; ${last_session#* }</b><br>"
fi

########################################################################

true
