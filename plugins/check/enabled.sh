# Plugin: check/enabled.sh
# Fonction: verifier si le portail est diponible

########################################################################

enabled

if [ $? -ne 0 ] ; then
	[ -z ${HTML} ] || echo -n "Le service EduSpot est indisponible !"
	reject=1
fi

########################################################################

if [ -z ${reject} ] ; then
	true
else
	false
fi

