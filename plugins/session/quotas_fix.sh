# Plugin: session/quotas_fix.sh
# Fonction: affecter les quotas par defaut si necessaire

########################################################################

max_sessions=${max_sessions-${MAX_SESSIONS}}
max_duration=${max_duration-${MAX_DURATION}}
max_time=${max_time-${MAX_TIME}}

for i in 0 1 2 3 ; do
	max_bytes_class[${i}]=${max_bytes_class[${i}]-${MAX_BYTES_CLASS[${i}]}}
done

########################################################################

true
