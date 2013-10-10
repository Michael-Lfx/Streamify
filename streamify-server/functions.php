<?php
	$user = 'root';
	$password = 'streamify';
	$host = 'localhost';

	$con = mysql_connect($host, $user, $password);
	mysql_select_db("streamify");

	function getAllObjects($table_name){
		$query = "SELECT * from ".$table_name;
		$result = mysql_query($query);
		while($row = mysql_fetch_assoc($result)){
			$object[] = $row;
		}
		return $object;
	}

	function getObjectsWhere($table_name, $where_key, $where_value){
		$query = "SELECT * from ".$table_name." WHERE ".$where_key."=".$where_value;
		$result = mysql_query($query);
		while($row = mysql_fetch_assoc($result)){
			$object[] = $row;
		}
		return $object;	
	}

	function createObject($table_name, $in_array){
		$query = "INSERT INTO ".$table_name." (";
		
		$i = 0;
		foreach ($in_array as $key => $value) {
		 	$query = $query.$key;
		 	if($i != count($in_array) - 1)
		 		$query = $query.", ";
		 	++$i;
		 }

		 $query = $query.") VALUES(";

		 $i = 0;
		 foreach ($in_array as $key => $value) {
		 	
		 	if($key != 'live')
		 		$query = $query."'".$value."'";
		 	else
		 		$query = $query.$value;
		 	
		 	if($i != count($in_array) - 1)
		 		$query = $query.", ";
		 	++$i;
		 } 
		 $query = $query.")";
		mysql_query($query);
	}

	function deleteObject($table_name, $users_object_id){
		$query = "DELETE from broadcast where users_object_id='".$users_object_id."'";
		mysql_query($query);
	}

	function doRequest($url, $type, $data = null){
		$ch = curl_init($url);

	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    			'Content-Type: application/json',
    			'X-Parse-Application-Id: '.'YTD2X45oaoNWDeaBPcVGl2H0bMbN8FSFBwwwZ8nz',
    			'X-Parse-REST-API-Key: '.'g2bwR9Na8gyGWO6ot86R23Ol0kOSCM4FRUoS3qID'
		));
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $type);
    		if($data != null)
    		curl_setopt($ch, CURLOPT_POSTFIELDS,json_encode($data));
    		$response = curl_exec($ch);
    		return $response;
	}

	function print_array($in_array){
		echo "<pre>";
		print_r($in_array);
		echo "</pre>";
	}
?>
