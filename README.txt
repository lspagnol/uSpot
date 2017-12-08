uSpot est un portail captif concu pour Eduspot:

- basé sur le fitrage niveau 2 du noyau Linux,
- "multi-VLANs",
- "multi-sites",
- construit autour de composants robustes et courants,
- modulaire,
- facilement adaptable à d'autres besoins,
- sous licence GNU GPL.

La fonction "authentification" est déléguée aux modules Apache, la
fonction "autorisation" est assurée par les scripts "uSpot".

Pour le noeud dedié à la gestion des portails et à la base de données,
installer les paquets suivants:
apache2
mariadb-server mariadb-client
phpmyadmin php5-mcrypt
munin-node munin libcgi-fast-perl libapache2-mod-fcgid

Resources:

Wiki: https://dokuwicri.univ-reims.fr/wiki/doku.php?id=uspot:start
Code: https://dokuwicri.univ-reims.fr/files/uSpot/
Liste: https://listes.univ-reims.fr/sympa/info/uspot

laurent[DOT]spagnol[AT]univ[DOT]reims[DOT]fr
DSI - Université de Reims Champagne-Ardenne
