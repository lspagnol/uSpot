# Plugin: html/quotas.sh
# Fonction: afficher les quotas

########################################################################

# Les quotas ne sont affiches que s'ils existent
unset out
for i in 0 1 2 3 ; do
	[ ${max_bytes_class[${i}]} -ne 0 ] && out=1
done
[ ${max_time} -ne 0 ] && out=1

if [ ! -z ${out} ] && [ ! -z ${HTML} ] ; then

	cat<<EOF
<br>
<table border=1>
<tr>
<th align="center" colspan="3" bgcolor="lightgray">R&eacute;sum&eacute; du trafic depuis le $(date -d "${QUOTAS_PERIOD}" +%d/%m/%Y)</th>
</tr>
EOF

	if [ ${max_time} -ne 0 ] ; then
	cat<<EOF
<tr>
<th align="center">Quota
</th><th align="center">Cumul</th><th align="center">Limite</th>
</tr>
<tr>
<td align="center">Dur&eacute;e</td>
<td align="center">$(( ${total_time} / 3600 )) H</td>
<td align="center">$(( ${max_time} / 3600 )) H</td>
</tr>
EOF
	fi

	cat<<EOF
<tr>
<th align="center">Trafic</th><th align="center">Volume</th><th align="center">Limite</th>
</tr>
EOF

	for i in 0 1 2 3 ; do
		_total_bytes_class[${i}]="$((${total_bytes_class[${i}]}/${DEFAULT_DIV})) Mo"
		[ ${max_bytes_class[${i}]} -eq 0 ] && _max_bytes_class[${i}]="aucune" || _max_bytes_class[${i}]="$((${max_bytes_class[${i}]}/${DEFAULT_DIV})) Mo"

	cat<<EOF
<tr>
<td align="center">${NAME[${i}]}</td>
<td align="center">${_total_bytes_class[${i}]}</td>
<td align="center">${_max_bytes_class[${i}]}</td>
</tr>
EOF

	done

cat<<EOF
</table>
<br>
EOF

fi |tr -d "\n\t"

########################################################################

true
