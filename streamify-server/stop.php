<?php
	include "functions.php";
	if(!isset($_POST['username']))
	 exit;
	$username = $_POST['username'];
	$user_folder = "/var/www/streams/".$username;
	$content = $content."\n#EXT-X-ENDLIST\n";
	file_put_contents($user_folder.'/a.m3u8', $content, FILE_APPEND);
?>
