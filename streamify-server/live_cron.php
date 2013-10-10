<?php
	include "functions.php";
	/*$broadcasts = doRequest(
                        "https://api.parse.com/1/classes/Broadcast?where=".urlencode(json_encode(array('live' => 0)))
                        , "GET");
	$broadcasts = json_decode($broadcasts, true);
	*/

	$broadcasts = getObjectsWhere('broadcast', 'live', 0);
	$query = "SELECT * from broadcast where live=0 and last_upload != NULL";
	$result = mysql_query($query);

	while($row = mysql_fetch_assoc($result))
		$broadcasts[] = $row;

	print_array($broadcasts);
	foreach($broadcasts as $row){
		
		if($row['last_upload'] == "" || !isset($row['last_upload']))
			continue;
		
		$first_created = strtotime($row['first_created']);
		$now = strtotime(date("Y-m-d H:i:s"));
		
		if($now - $first_created >= 30){
			$query = "UPDATE broadcast set live=1 WHERE users_object_id='".$row['users_object_id']."'"; 
			mysql_query($query);
		}
	}
?>
