# Plugin: mysql/quotas_get.sh
# Fonction: lecture des quotas

########################################################################

req="
 SELECT
  quota_sessions AS max_sessions,
  quota_duration AS max_duration,
  quota_time AS max_time,
  quota_bytes_class0 AS max_bytes_class0,
  quota_bytes_class1 AS max_bytes_class1,
  quota_bytes_class2 AS max_bytes_class2,
  quota_bytes_class3 AS max_bytes_class3
 FROM quotas
 WHERE quota_login='${login}'
 ;"

eval "$(echo "${req}" |MYSQLGET)"

########################################################################

true
