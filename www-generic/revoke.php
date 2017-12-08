<html>
<head>
<link rel="stylesheet" href="/style.css">
<?php
include '/etc/uSpot/conf.php';
$ip = $_SERVER['REMOTE_ADDR'];
$mac = shell_exec("/usr/sbin/arp ". $ip);
preg_match('/..:..:..:..:..:../',$mac , $matches);
@$mac = $matches[0];
# Demande de revocation d'acces
exec("/usr/bin/sudo /usr/local/uSpot/uSpot-revoke $mac $ip $login",$retvalue,$retcode);
?>
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br>Votre acc&egrave;s Wifi <b>EduSpot</b> est coup&eacute;.
<br>
<br>Vous pouvez fermer votre navigateur.
</div>
</body>
</html>
