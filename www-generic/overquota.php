<?php
include '/etc/uSpot/conf.php';
$ip = $_SERVER['REMOTE_ADDR'];
$mac = shell_exec("/usr/sbin/arp -a ". $ip);
preg_match('/..:..:..:..:..:../',$mac , $matches);
@$mac = $matches[0];
$class=$_GET['class'];
?>
<html>
<head>
<link rel="stylesheet" href="/style.css">
<?php header ("Refresh: ".$REDIRECT_TIMEWAIT.";URL=$ACCESS_DENIED_URL"); ?>
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br><b>Votre quota est d&eacute;pass&eacute; !</b>
<br>
<br>
<table border=1>
<tr><th align="center">Traffic</th><td align="center">Heures creuses</td><td align="center">Heures pleines</td></tr>
<?php
switch ($class) {
case '0':
echo<<<END
<tr><td align="center">URCA</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
<tr><td align="center">Renater</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
<tr><td align="center">Internet</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
END;
break;
case '1':
echo<<<END
<tr><td align="center">URCA</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="green">Autoris&eacute;</font></td></tr>
<tr><td align="center">Renater</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
<tr><td align="center">Internet</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
END;
break;
case '2':
echo<<<END
<tr><td align="center">URCA</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="green">Autoris&eacute;</font></td></tr>
<tr><td align="center">Renater</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="green">Autoris&eacute;</font></td></tr>
<tr><td align="center">Internet</td><td align="center"><font color="red">Interdit</font></td><td align="center"><font color="red">Interdit</font></td></tr>
END;
break;
case '3':
echo<<<END
<tr><td align="center">URCA</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="green">Autoris&eacute;</font></td></tr>
<tr><td align="center">Renater</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="green">Autoris&eacute;</font></td></tr>
<tr><td align="center">Internet</td><td align="center"><font color="green">Autoris&eacute;</font></td><td align="center"><font color="red">Interdit</font></td></tr>
END;
break;
}
?>
</table>
<br>Veuillez contacter le correspondant CRI de votre campus.
<br>Vous devrez lui communiquer les informations suivantes:
<br>
<br>Votre <b>identifiant de connexion</b>
<br>Adresse IP: <b><?php echo "$ip"; ?></b>
<br>Adresse MAC: <b><?php echo "$mac"; ?></b>
</div>
</body>
</html>
