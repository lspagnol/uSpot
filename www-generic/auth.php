<html>
<head>
<link rel="stylesheet" href="/style.css">
<?php
include '/etc/uSpot/conf.php';
$auth=$_GET['auth'];
$url=$_GET['url'];
$url=rtrim($url,"?");
$ip = $_SERVER['REMOTE_ADDR'];
$mac = shell_exec("/usr/sbin/arp -a ". $ip);
preg_match('/..:..:..:..:..:../',$mac , $matches);
@$mac = $matches[0];
# Ecriture de l'URL d'origine en cache
$fp = fopen($REDIRECTS . "/" . $mac . " " . $ip, "w");
if($fp){
fputs ($fp, $url);
fclose ($fp);
}
switch ($auth) {
case 'cas':
header ("Refresh: 0;URL=auth_cas");
break;
case 'shib':
header ("Refresh: 0;URL=auth_shib");
break;
case 'guest':
header ("Refresh: 0;URL=auth_guest");
break;
}
?>
</head>
<body>
</body>
</html>
