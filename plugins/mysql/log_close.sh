# Plugin: mysql/log_close.sh
# Fonction: fermeture de session: mise a jour

########################################################################

req="
 UPDATE logs
 SET
  log_revoke='${revoke}',
  log_bytes_dl0='${bytes_dl[0]}',
  log_bytes_dl1='${bytes_dl[1]}',
  log_bytes_dl2='${bytes_dl[2]}',
  log_bytes_dl3='${bytes_dl[3]}',
  log_bytes_up0='${bytes_up[0]}',
  log_bytes_up1='${bytes_up[1]}',
  log_bytes_up2='${bytes_up[2]}',
  log_bytes_up3='${bytes_up[3]}'
 WHERE
  log_mac='${mac}' AND log_ip='${ip}' AND log_login='${login}' AND log_grant='${grant}'
 ;"

echo "${req}" |MYSQL

########################################################################

true
