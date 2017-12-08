#!/bin/bash
. /etc/uSpot/mysql.conf

function MYSQL {
mysql --vertical --host="${MYSQL_HOST}" --user="${MYSQL_USER}" --password="${MYSQL_PASSWD}" --database="${MYSQL_DB}" --execute="${@}" 2>/dev/null |sed -e '/^$/d ; /^\*/d ; s/^[[:space:]]*//g ; s/: /=/g ; s/\(.*\)=NULL/unset \1/g'
}

user="${1}"
pass="${2}"

eval $(MYSQL "SELECT passwd FROM auth WHERE login='${user}';")
passwd=${passwd:-NULL}

[ "${passwd}" = "NULL" ] && exit 1 # compte inconnu ou pas de session planifiee

pass_sha=$(echo -n "${pass}" |sha1sum)
pass_sha=${pass_sha/ */}

[ "${pass_sha}" = "${passwd}" ] && exit 0 || exit 2 # mot de passe invalide
