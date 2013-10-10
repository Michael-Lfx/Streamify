<?php
	require('Pusher.php');
	$key = "6b31ed49fb16b7150047";
	$secret = "21264302621a1a1f310b";
	$app_id = "41280";
	$socket_id = $_POST['socket_id'];

	$pusher = new Pusher($key, $secret, $app_id);
	$pusher->trigger('private-test_channel', 'my_event', array('message' => 'fuck you') );
?>