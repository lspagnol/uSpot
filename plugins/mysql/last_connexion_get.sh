# Plugin: mysql/last_cnx_get.sh
# Fonction: lecture de la date de la derniere session

########################################################################

req="
 SELECT
  DATE_FORMAT(FROM_UNIXTIME(log_grant),\"%d/%m/%Y %H:%i\") AS last_session
 FROM logs
 WHERE log_login='${login}'
 ORDER BY log_grant DESC
 LIMIT 1;
"

last_session="$(echo "${req}" |MYSQL -N)"

########################################################################

true
