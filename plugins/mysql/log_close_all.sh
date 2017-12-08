# Plugin: mysql/log_close_all.sh
# Fonction: fermeture de session: mise a jour pour toutes les sessions

########################################################################

req="
 UPDATE logs
 SET
  log_revoke='${EPOCH}'
 WHERE
  log_revoke IS NULL AND log_host='${HOSTNAME}
 ;"

echo "${req}" |MYSQL

########################################################################

true
