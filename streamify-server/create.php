<?php
	include "functions.php";
	if(!isset($_POST['username']))
	  exit;
	$username = $_POST['username'];

	$user_folder = '/var/www/streams/'.$username;
	shell_exec('rm -rf '.$user_folder);
	mkdir($user_folder);
	chmod($user_folder, 0777);

	mkdir($user_folder.'/audio');
	chmod($user_folder.'/audio', 0777);

	$content = "#EXTM3U\n#EXT-X-VERSION:5\n#EXT-X-TARGETDURATION:11\n#EXT-X-MEDIA-SEQUENCE:1";
	file_put_contents($user_folder.'/a.m3u8', $content);

	chmod($user_folder.'/a.m3u8', 0777);
	
	//make live
	//doRequest("https://api.parse.com/1/classes/Broadcast", "POST" , array(users_object_id => $username,
		//								'live' => 0, 'first_created' => date("Y-m-d H:i:s")));
	deleteObject('broadcast', $username);
	createObject('broadcast', array('users_object_id' => $username,'live' => 0, 'first_created' => gmdate("Y-m-d H:i:s")));
?>
