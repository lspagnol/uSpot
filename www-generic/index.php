<?php
# Recuperation de l'URL d'origine
$url=$_GET['url'];
?>
<html>
<head>
<link rel="stylesheet" href="/style.css">
</head>
<body>
<div align=center>
<img src="/eduspot300x209.png">
<br>
<br><a><b>Veuillez choisir un mode d'authentification:</b></a>
<br>
<br><a href=/auth.php?auth=cas&url=<?php echo "$url";?> >Compte URCA</a>
<br>
<br><a href=/auth.php?auth=shib&url=<?php echo "$url";?> >Autre &eacute;tablissement Universitaire</a>
<br>
<br><a href=/auth.php?auth=guest&url=<?php echo "$url";?> >Invit&eacute;</a>
<br>
<!--
<br><a><font color="red">Ce service est exp&eacute;rimental !</font></a>
<br><a>Merci de signaler les probl&egrave;mes &agrave; eduspot-admin@univ-reims.fr</a>
-->
</div>
</body>
</html>
