<?php
	include  "functions.php";
		if(!isset($_POST['users_object_id']))
		exit;
	$users_object_id = $_POST['users_object_id'];

	$query = "SELECT * from broadcast where users_object_id='".$users_object_id."'";
	mysql_query($query);
	$result = mysql_query($query);
	$row = mysql_fetch_assoc($result);

	$listener_count = intval($row['listener_count']) + intval($_POST['change_amount']);
	$query = "UPDATE broadcast set listener_count=".$listener_count." WHERE users_object_id='".$users_object_id."'"; 
	mysql_query($query);
?>
