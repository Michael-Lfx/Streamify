<?php
	require('Pusher.php');
	$key = "6b31ed49fb16b7150047";
	$secret = "21264302621a1a1f310b";
	$app_id = "41280";

	$pusher = new Pusher($key, $secret, $app_id);
	//$auth = $pusher->socket_auth($_GET['channel_name'], $_GET['socket_id']);
  
  //$callback = str_replace('\\', '', $_GET['callback']);
  //header('Content-Type: text/javascript');
  //echo($callback . '(' . $auth . ');');
  echo $pusher->socket_auth($_POST['channel_name'], $_POST['socket_id']);
?>