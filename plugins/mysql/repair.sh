# Plugin: mysql/repair.sh
# Fonction: suppression des logs sans date de revocation

########################################################################

req="
 DELETE FROM logs
 WHERE
  log_revoke IS NULL AND log_host='${HOSTNAME}'
 ;"

echo "${req}" |MYSQL

########################################################################

true
