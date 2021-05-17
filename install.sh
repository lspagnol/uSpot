#!/bin/bash

########################################################################

if [ "$(lsb_release -r 2>/dev/null |awk '{print $2}')" != "14.04" ] ; then
	echo "This uSpot version requires Ubuntu 14.04 LTS !"
	exit
fi

########################################################################

# Destinations
ETC="/etc/uSpot"
BIN="/usr/local/uSpot"

# Paquets
PKGS="\
 bash bash-completion joe sipcalc\
 curl wget rsync logtail\
 vlan isc-dhcp-server arping fping ifupdown\
 munin-node ntp task-spooler\
 apache2 apache2-utils mysql-client\
 libapache2-mod-php5 php5 php5-mysql\
 libapache2-mod-auth-cas libapache2-mod-shib2 libapache2-mod-authnz-external\
"

# Tuning SYSCTL (desactivation IPv6)
SYSCTL="
 net.ipv6.conf.all.disable_ipv6=1
 net.ipv6.conf.default.disable_ipv6=1
 net.ipv6.conf.lo.disable_ipv6=1
"

########################################################################

echo "Installing required pkgs ..."
apt-get -y install ${PKGS}
echo

echo "Creating uSpot dirs ... "
for rep in ${ETC} ${BIN} ; do
	mkdir -p ${rep}
done


echo "Installing uSpot scripts (main script is 'uSpot') ... "
rsync -a ../uSpot/ ${BIN}/
ln -fs ${BIN}/uSpot /usr/local/sbin/


echo "Configuring '/etc/uSpot/interfaces' ... "
grep -q '^source /etc/uSpot/interfaces' /etc/network/interfaces
if [ $? -ne 0 ] ; then
cat<<EOF>>/etc/network/interfaces

# Configuration des interfaces cote Wifi
source /etc/uSpot/interfaces

EOF
fi


echo "Configuring Dot1q support ... "
grep -q "^8021q" /etc/modules
if [ $? -ne 0 ] ; then
	echo "8021q" >> /etc/modules
	modprobe 8021q
fi


echo "Kernel tuning (disable IPv6) ... "
for p in ${SYSCTL} ; do
	echo " ${p}"
	grep -q "^${p}$" /etc/sysctl.conf
	if [ $? -ne 0 ] ; then
		echo "${p}" >> /etc/sysctl.conf
		sysctl ${p}
	fi
done


echo "installing TCS chain certificate ..."
mkdir /usr/share/ca-certificates/extra/ 2>/dev/null
chmod 755 /usr/share/ca-certificates/extra/
cp etc/tcschain.crt /usr/share/ca-certificates/extra
chmod 644 /usr/share/ca-certificates/extra/tcschain.crt
grep -q "^extra/tcschain.crt" /etc/ca-certificates.conf
if [ $? -ne 0 ] ; then
	echo "extra/tcschain.crt" >> /etc/ca-certificates.conf
	update-ca-certificates > /dev/null
fi


echo "Configuring Apache listening ports ... "
cp etc/apache2/ports.conf /etc/apache2
chmod 644 /etc/apache2/ports.conf


echo "Apache tuning (Timeout, KeepAlive) ... "
sed -i "s/^Timeout 300/Timeout 30/g" /etc/apache2/apache2.conf
sed -i "s/^KeepAlive On/KeepAlive Off/g" /etc/apache2/apache2.conf


echo "Disabling Apache default sites ... "
for s in 000-default default-ssl ; do
	echo " ${s}"
	a2dissite ${s} 2>/dev/null >/dev/null
done


echo "Enabling Apache modules ..."
for m in rewrite ssl auth_cas shib2 authnz_external ; do
	echo " ${m}"
	a2enmod ${m} 2>/dev/null >/dev/null
done


echo "Apache pre-configuration (templates) ... "
for f in etc/apache2/sites-available/uSpot.conf.dist etc/apache2/mods-available/auth_cas.conf.dist ; do
	echo " /${f}"
	cp ${f} /${f}
	chmod 644 /${f}
	sed -i "s/##PORTAL_FQDN##/$(hostname -f)/g" /${f}
	sed -i "s/##PORTAL_HOSTNAME##/$(hostname)/g" /${f}
	sed -i "s/##DOMAIN##/$(hostname -d)/g" /${f}
	sed -i "s/##CAS_SERVER_FQDN##/cas.$(hostname -d)/g" /${f}
done


echo "Shibboleth pre-configuration (templates) ... "
for f in etc/shibboleth/shibboleth2.xml.dist etc/shibboleth/attribute-map.xml etc/shibboleth/metadata-federation-renater.crt ; do
	echo " /${f}"
	cp ${f} /${f}
	chmod 644 /${f}
done
sed -i "s/##PORTAL_FQDN##/$(hostname -f)/g" /etc/shibboleth/shibboleth2.xml.dist


echo "Installing uSpot configuration files (templates) ... "
for f in $(ls etc/uSpot/*.dist) ; do
	echo " /${f}"
	cp ${f} /${f}
done
cp ${ETC}/uSpot_HOSTNAME.conf.dist ${ETC}/uSpot_$(hostname).conf.dist
chown -R root:root ${ETC}
chmod 755 ${ETC}
chmod 644 ${ETC}/*
chmod 600 ${ETC}/ldap.conf.dist
chmod 600 ${ETC}/mysql.conf.dist


echo "Installing Munin plugins ..."
ln -fs ${BIN}/munin/uSpot_* /etc/munin/plugins
rm /etc/munin/plugins/if_err_eth* 2>/dev/null
service munin-node restart >/dev/null


echo "Configuring services ..."
for f in etc/cron.d/uSpot etc/logrotate.d/uSpot etc/logrotate.d/dhcpd etc/sudoers.d/10_uSpot ; do
	echo " /${f}"
	cp ${f} /${f}
	chmod 644 /${f}
done


echo "Configuring uSpot startup ..."
ln -fs ${BIN}/uSpot /etc/init.d
update-rc.d -f uSpot remove 2>/dev/null >/dev/null
update-rc.d -f uSpot defaults 2>/dev/null >/dev/null


cat<<EOF

Installation done => you have to copy, check, edit some files.

## Fix Apache configuration:

cp /etc/apache2/mods-available/auth_cas.conf.dist /etc/apache2/mods-available/auth_cas.conf
chmod 644 /etc/apache2/mods-available/auth_cas.conf

cp /etc/apache2/sites-available/uSpot.conf.dist /etc/apache2/sites-available/uSpot.conf
chmod 644 /etc/apache2/sites-available/uSpot.conf

=> Check /etc/apache2/mods-available/auth_cas.conf
         /etc/apache2/sites-available/uSpot.conf
=> INSTALL SSL CERTIFICATE IN /etc/uSpot (use symlinks)

a2ensite uSpot
service apache2 restart


## Fix Shibboleth configuration:

cp /etc/shibboleth/shibboleth2.xml.dist /etc/shibboleth/shibboleth2.xml
chmod 644 /etc/apache2/sites-available/uSpot.conf

=> Check /etc/shibboleth/shibboleth2.xml

service shibd restart


## Fix uSpot configuration:

cp /etc/uSpot/uSpot.conf.dist /etc/uSpot/uSpot.conf
cp /etc/uSpot/uSpot_HOSTNAME.conf.dist /etc/uSpot/uSpot_$(hostname).conf
cp /etc/uSpot/networks.conf.dist /etc/uSpot/networks.conf
chmod 644 /etc/uSpot/uSpot.conf
chmod 644 /etc/uSpot/uSpot_$(hostname).conf
chmod 644 /etc/uSpot/networks.conf

=> Check /etc/uSpot/uSpot.conf
         /etc/uSpot/uSpot_$(hostname).conf
         /etc/uSpot/networks.conf
         
/usr/local/uSpot/uSpot-configure

EOF
