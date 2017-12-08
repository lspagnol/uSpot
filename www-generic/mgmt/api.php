<?php

include '/etc/uSpot/conf.php';

$cmd=$_GET['cmd'];
$action=$_GET['action'];
$id=$_GET['id'];
$login=$_GET['login'];
$passwd=$_GET['passwd'];
$proposer=$_GET['proposer'];
$comment=$_GET['comment'];
$quota=$_GET['quota'];
$value=$_GET['value'];
$mac=$_GET['mac'];
$ip=$_GET['ip'];
$host=$_GET['host'];
$order=$_GET['order'];
$limit=$_GET['limit'];
$date=$_GET['date'];
$view=$_GET['view'];

switch ($cmd) {

	case 'guest':
		$do='/usr/bin/sudo /usr/local/uSpot/uSpot-guest';
		switch ($action) {
			case 'add':
				if (isset($date)) { $args=$args.' -date '.$date; }
				if (isset($passwd)) { $args=$args.' -passwd '.$passwd; }
				if (isset($proposer)) { $args=$args.' -proposer '.$proposer; }
				if (isset($comment)) { $args=$args.' -comment "'.$comment.'"'; }
				$do="$do add ".$login.$args;
			break;
			case 'show':
				if (isset($proposer)) { $args=$args.' -proposer '.$proposer; }
				if (isset($comment)) { $args=$args.' -comment "'.$comment.'"'; }
				if (isset($login)) { $args=$args.' -login '.$login; }
				$do="$do show".$args;
			break;
			case 'mod':
				if (isset($date)) { $args=$args.' -date '.$date; }
				$do="$do mod ".$id.$args;
			break;
			case 'del':
				$do="$do del ".$id;
			break;
			case 'enable':
				$do="$do enable ".$id;
			break;
			case 'disable':
				$do="$do disable ".$id;
			break;
		}
		
	break;

	case 'quotas':
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot-quotas $action $login $quota $value";
	break;

	case 'sql':
		if (isset($view)) {$action=$view;}
		if (isset($login)) { $args=$args.' -login '.$login; }
		if (isset($mac)) { $args=$args.' -mac '.$mac; }
		if (isset($ip)) { $args=$args.' -ip '.$ip; }
		if (isset($host)) { $args=$args.' -host '.$host; }
		if (isset($order)) { $args=$args.' -order "'.$order.'"'; }
		if (isset($limit)) { $args=$args.' -limit '.$limit; }
		if (isset($date)) { $args=$args.' -date '.$date; }
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot-sql $view".$args;
	break;

	case 'sessions';
		$action="sessions";
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot $action";
	break;

	case 'leases';
		$action="leases";
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot $action";
	break;

	case 'userblacklist';
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot userblacklist $action $login";
	break;

	case 'macblacklist';
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot macblacklist $action $mac";
	break;

	case 'kick';
		$action='kick';
		$do="/usr/bin/sudo /usr/local/uSpot/uSpot $action $login";
	break;

}

if (isset($action)) {
	exec($do,$retvalue,$retcode);
} else { $retcode=1; }
header ("X-Return-Code: $retcode");
header ("Content-Type: text/plain");
foreach ($retvalue as $v) {
  echo "$v\n";
}

?>
