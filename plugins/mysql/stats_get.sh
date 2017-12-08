# Plugin: mysql/stats_get.sh
# Fonction: lecture des stats de session

########################################################################

req="
 SELECT
  COUNT(*) as sessions
 FROM logs
 WHERE
  log_login='${login}' AND log_revoke IS NULL
 ;
 SELECT
  unix_timestamp()-log_grant AS duration
 FROM logs
 WHERE
  log_login='${login}' AND log_revoke IS NULL
 ;
 SELECT
  SUM(log_revoke-log_grant) AS total_time
 FROM logs
 WHERE
  log_login='${login}' AND log_grant>='${QUOTA_SEARCH}'
 ;
 SELECT
  SUM(log_bytes_dl0) AS total_bytes_dl0,
  SUM(log_bytes_up0) AS total_bytes_up0,
  SUM(log_bytes_dl1) AS total_bytes_dl1,
  SUM(log_bytes_up1) AS total_bytes_up1,  
  SUM(log_bytes_dl2) AS total_bytes_dl2,
  SUM(log_bytes_up2) AS total_bytes_up2,
  SUM(log_bytes_dl3) AS total_bytes_dl3,
  SUM(log_bytes_up3) AS total_bytes_up3
 FROM logs
 WHERE
  log_login='${login}' AND log_grant>='${QUOTA_SEARCH}'
 ;"

eval "$(echo "${req}" |MYSQLGET)"

########################################################################

true
