<?php
	include "functions.php";
	if(!isset($_POST['users_object_id']))
		exit;
	$users_object_id = $_POST['users_object_id'];

	$query = "SELECT * from broadcast where users_object_id='".$users_object_id."'";
	$result = mysql_query($query);
	$row = mysql_fetch_assoc($result);

	http_response_code(200);
	header("Content-Type: application/json");
	echo json_encode(array('listener_count' => $row['listener_count']));
?>
