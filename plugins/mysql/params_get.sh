# Plugin: mysql/params_get.sh
# Fonction: lecture des parametres par defaut

########################################################################

req="
 SELECT param_value AS MAX_SESSIONS FROM params WHERE param_item='MAX_SESSIONS';
 SELECT param_value AS MAX_DURATION FROM params WHERE param_item='MAX_DURATION';
 SELECT param_value AS MAX_TIME FROM params WHERE param_item='MAX_TIME';
 SELECT param_value AS MAX_BYTES_CLASS0 FROM params WHERE param_item='MAX_BYTES_CLASS0';
 SELECT param_value AS MAX_BYTES_CLASS1 FROM params WHERE param_item='MAX_BYTES_CLASS1';
 SELECT param_value AS MAX_BYTES_CLASS2 FROM params WHERE param_item='MAX_BYTES_CLASS2';
 SELECT param_value AS MAX_BYTES_CLASS3 FROM params WHERE param_item='MAX_BYTES_CLASS3';
 "

eval "$(echo "${req}" |MYSQLGET)"

########################################################################

true
