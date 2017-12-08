# Plugin: periodic/mysql_stats_get.sh
# Fonction: lecture de TOUTES les stats et quotas

########################################################################

req="
CREATE TEMPORARY TABLE quotacheck
 SELECT
  log_login AS login,
  SUM(log_bytes_dl0+log_bytes_up0) AS total_bytes_class0,
  SUM(log_bytes_dl1+log_bytes_up1) AS total_bytes_class1,
  SUM(log_bytes_dl2+log_bytes_up2) AS total_bytes_class2,
  SUM(log_bytes_dl3+log_bytes_up3) AS total_bytes_class3,
  quota_bytes_class0 AS m_bytes_class0,
  quota_bytes_class1 AS m_bytes_class1,
  quota_bytes_class2 AS m_bytes_class2,
  quota_bytes_class3 AS m_bytes_class3,
  (SELECT param_value FROM params WHERE param_item='MAX_BYTES_CLASS0') AS dm_bytes_class0,
  (SELECT param_value FROM params WHERE param_item='MAX_BYTES_CLASS1') AS dm_bytes_class1,
  (SELECT param_value FROM params WHERE param_item='MAX_BYTES_CLASS2') AS dm_bytes_class2,
  (SELECT param_value FROM params WHERE param_item='MAX_BYTES_CLASS3') AS dm_bytes_class3
 FROM (logs JOIN quotas ON (log_login=quota_login))
 WHERE
  log_grant>='${QUOTA_SEARCH}'
 GROUP BY login
;
SELECT
  login
 FROM quotacheck
 WHERE
  (dm_bytes_class0>0 AND m_bytes_class0 IS NULL and total_bytes_class0>=dm_bytes_class0) OR
  (dm_bytes_class1>0 AND m_bytes_class1 IS NULL and total_bytes_class1>=dm_bytes_class1) OR
  (dm_bytes_class2>0 AND m_bytes_class2 IS NULL and total_bytes_class2>=dm_bytes_class2) OR
  (dm_bytes_class3>0 AND m_bytes_class3 IS NULL and total_bytes_class3>=dm_bytes_class3) OR
  (m_bytes_class0>0 AND total_bytes_class0>=m_bytes_class0) OR
  (m_bytes_class1>0 AND total_bytes_class1>=m_bytes_class1) OR
  (m_bytes_class2>0 AND total_bytes_class2>=m_bytes_class2) OR
  (m_bytes_class3>0 AND total_bytes_class2>=m_bytes_class3)
;
"

# Inscrire les sessions en depassement de quotas dans le cache
echo "$req"\
 |MYSQL -N\
 |sed -e "s/\(^.*$\)/SELECT log_mac,log_ip,log_login FROM logs WHERE log_login='\1' AND log_host='${HOSTNAME}' AND log_revoke IS NULL;/g"\
 |MYSQL -N\
 |awk '{print $1" "$2" "$3}'\
 |while read session ; do
	session=(${session})
	mac=${session[0]}
	ip=${session[1]}
	login=${session[2]}
	echo "${mac} ${ip} ${login}" > "${OVERQUOTAS}/${mac} ${ip}"
done

########################################################################

true
