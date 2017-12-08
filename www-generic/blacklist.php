<?php
$ip = $_SERVER['REMOTE_ADDR'];
$mac = shell_exec("/usr/sbin/arp -a ". $ip);
preg_match('/..:..:..:..:..:../',$mac , $matches);
@$mac = $matches[0];
?>
<html>
<head>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br><b>Votre machine est en liste noire !</b>
<br>
<br>Veuillez contacter le correspondant CRI de votre campus.
<br>Vous devrez lui communiquer les informations suivantes:
<br>
<br>Votre <b>identifiant de connexion</b>
<br>Adresse IP: <b><?php echo "$ip"; ?></b>
<br>Adresse MAC: <b><?php echo "$mac"; ?></b>
</div>
</body>
</html>
