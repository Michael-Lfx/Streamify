<?php
	include "functions.php";
	/*$broadcasts = doRequest(
                        "https://api.parse.com/1/classes/Broadcast"
                        , "GET");
	$broadcasts = json_decode($broadcasts, true);
*/
	$query = "SELECT * from broadcast where live=1";
		$result = mysql_query($query);

		if(mysql_num_rows($result) <= 0)
			exit;

		while($row = mysql_fetch_assoc($result)){
			$broadcasts[] = $row;
		}

	//$broadcasts = getAllObjects('broadcast');
	
	foreach($broadcasts as $row){
		
		if($row['last_upload'] == "" || !isset($row['last_upload']))
			continue;
		
		$last_upload = strtotime($row['last_upload']);
		$now = strtotime(date("Y-m-d H:i:s"));
		echo $now - $last_upload;
		if($now - $last_upload >= 10){
			//deleteObject('broadcast', $row['users_object_id']);
			$query = "UPDATE broadcast set live=0, listener_count=0, last_upload=NULL where users_object_id='".$row['users_object_id']."'";
			mysql_query($query);
			$user_folder = '/var/www/streams/'.$row['users_object_id'];
			shell_exec('rm -rf '.$user_folder);
		}
	}
?>
