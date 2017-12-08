# Plugin: check/user.sh
# Fonction: verifier si l'utilisateur est en liste noire

########################################################################

{ [ -f ${CONF}/userblacklist.conf ] && cat ${CONF}/userblacklist.conf ;\
  [ -f ${CONF}/userblacklist_${HOSTNAME}.conf ] && cat ${CONF}/userblacklist_${HOSTNAME}.conf ; }\
  |grep -q "^${login}$"

if [ $? -eq 0 ] ; then
	[ -z ${HTML} ] || echo -n "Votre identifiant est en liste noire !"
	reject=1
fi

########################################################################

if [ -z ${reject} ] ; then
	true
else
	false
fi
