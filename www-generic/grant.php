<html>
<head>
<link rel="stylesheet" href="/style.css">
<?php
include '/etc/uSpot/conf.php';

if ($_SERVER['AUTH_TYPE'] = 'shibboleth') { # Auth Shibboleth
 if (isset($_SERVER['email'])) {
  $login = $_SERVER['email'];
 } else if (isset($_SERVER['Shib-Identity-Provider'])) {
	if (isset($_SERVER['uid'])) {
     $login = $_SERVER['Shib-Identity-Provider'].":".$_SERVER['uid'];
    } else if (isset($_SERVER['Shib-Session-ID'])) {
     $login = $_SERVER['Shib-Identity-Provider'].":".$_SERVER['Shib-Session-ID'];
    }
 }
}

if (!isset($login)) { # Pas d'auth Shibboleth
 //$login = $_SERVER['PHP_AUTH_USER'];
 $login = $_SERVER['REMOTE_USER'];
}

if (!isset($login)) { # Impossible de recuperer un identifiant => fin
 echo "The remote identity provider didn't give any user id => access denied";
 exit;
}

$ip = $_SERVER['REMOTE_ADDR'];
$mac = shell_exec("/usr/sbin/arp ". $ip);
preg_match('/..:..:..:..:..:../',$mac , $matches);
@$mac = $matches[0];
# Lecture de l'URL d'origine dans le cache
$fp = fopen($REDIRECTS . "/" . $mac . " " . $ip, "r");
if($fp){
$url=fgets($fp);
fclose ($fp);
}
# Demande d'autorisation d'acces
exec("/usr/bin/sudo /usr/local/uSpot/uSpot-grant -html $mac $ip $login",$retvalue,$retcode);
if ( $retcode == '0' ) {
# ACCES AUTORISE: le texte retourne par les modules est affiche en vert
# Redirection vers le site demande
header ("Refresh: ".$REDIRECT_TIMEWAIT.";URL=http://$url");
echo<<<END
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br>Votre acc&egrave;s Wifi <b>EduSpot</b> est ouvert.
<br>
<br>Il sera coup&eacute; automatiquement lorsque votre appareil sera deconnect&eacute;.
<br>Vous pouvez utiliser ce lien pour vous d&eacute;connecter manuellement:
<br><a href=http://eduspot.univ-reims.fr>D&eacute;connexion Eduspot URCA</a>
<br>
<br>Vous allez &ecirc;tre redirig&eacute; automatiquement vers le <a href=http://$url>site demand&eacute;</a>.
<br>
<br>$retvalue[0]
END;
} else {
# ACCES REFUSE: le texte retourne par les modules est affiche en rouge
# Redirection vers la page d'info
header ("Refresh: ".$REDIRECT_TIMEWAIT.";URL=$ACCESS_DENIED_URL");
echo<<<END
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br>L'acc&egrave;s Wifi <b>EduSpot</b> est refus&eacute; pour la raison suivante:
<br>
<br><font color="red"><b>$retvalue[0]</b></font>
END;
}
?>
</div>
</body>
</html>
