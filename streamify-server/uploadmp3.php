<?php
	include  "functions.php";
	$username = $_POST['username'];
	$user_folder = '/var/www/streams/'.$username;
	$audio_folder = $user_folder.'/audio/';

	$uploadfile = $audio_folder.basename($_FILES['userfile']['name']);
	move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile);
	$num_files = shell_exec('ls -l '.$audio_folder.'| wc -l');
	$num_files =  intval($num_files) - 1;
	$num_files = $num_files==0 ? 0 : $num_files-1;

	$content = "";
	$content = $content."\n#EXTINF:10.0";
	$content = $content."\nhttp://54.251.250.31/streams/".$username."/audio/sound".$num_files.".mp3";
	file_put_contents($user_folder.'/a.m3u8', $content, FILE_APPEND);
	// unlink($audio_folder.'sound'.($num_files-3).'.mp3');

	/*$user_broadcast_object_id = doRequest(
                        "https://api.parse.com/1/classes/Broadcast?where=".urlencode(json_encode(array('users_object_id' => $username)))
                        , "GET");
	$user_broadcast_object_id = json_decode($user_broadcast_object_id, true);
	$user_broadcast_object_id = $user_broadcast_object_id['results'][0]['objectId'];
	doRequest("https://api.parse.com/1/classes/Broadcast/".$user_broadcast_object_id, "PUT" , array(
										'last_upload' => date("Y-m-d H:i:s")
										));*/
	// $query = "UPDATE broadcast set last_upload='".gmdate("Y-m-d H:i:s")."' WHERE users_object_id='".$username."'"; 
	// mysql_query($query);
?>
