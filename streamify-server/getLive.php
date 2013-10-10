<?php
	include "functions.php";
	if(!isset($_POST['users_object_id']))
		exit;
	$users_object_id = $_POST['users_object_id'];

	$broadcasts = getObjectsWhere('broadcast', 'live', 1);
	if($broadcasts == null)
		$broadcasts = array();
	else{
		$i = 0;
		foreach ($broadcasts as $bc) {
			$query = "SELECT * from follow where follower_object_id='".$users_object_id."' and user_followed_object_id='".$bc['users_object_id'].
						"'";
			$result = mysql_query($query);
			if(mysql_num_rows($result) > 0)
				$broadcasts[$i]['is_followed'] = 1;
			else
				$broadcasts[$i]['is_followed'] = 0;
			++$i;
		}
	}

	http_response_code(200);
	header("Content-Type: application/json");
	echo json_encode($broadcasts);
?>
