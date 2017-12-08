# Plugin: mysql/log_open.sh
# Fonction: ouverture de session: inscription

########################################################################

req="
 INSERT INTO logs
  (log_host,log_wlan_id,log_mac,log_ip,log_login,log_grant)
 VALUES
  ('${HOSTNAME}','${wlan_id}','${mac}','${ip}','${login}','${grant}')
 ;"

echo "${req}" |MYSQL

########################################################################

true
