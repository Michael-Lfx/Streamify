<?php
	include "functions.php";

	switch($_POST['action']){
		case "createFollow" : {
			if(
			   !isset($_POST['follower_object_id']) ||
			   !isset($_POST['user_followed_object_id']) ||
			   !isset($_POST['follower_fb_id']) ||
			   !isset($_POST['user_followed_fb_id'])
			   )
				exit;

			$in_array['follower_object_id'] = $_POST['follower_object_id'];
			$in_array['user_followed_object_id'] = $_POST['user_followed_object_id'];
			$in_array['follower_fb_id'] = $_POST['follower_fb_id'];
			$in_array['user_followed_fb_id'] = $_POST['user_followed_fb_id'];
			$query = "SELECT * from follow where follower_object_id='".$follower_object_id."' and user_followed_object_id='".$user_followed_object_id."'";
			$result = mysql_query($query);
			
			if(mysql_num_rows($result) <= 0)
				createObject('follow', $in_array);
			
			http_response_code(200);
			header("Content-Type: application/json");
			echo json_encode(array());
			break;
		}

		case "deleteFollow" : {
			if(!isset($_POST['follower_object_id']) || !isset($_POST['user_followed_object_id']))
				exit;
			$follower_object_id = $_POST['follower_object_id'];
			$user_followed_object_id = $_POST['user_followed_object_id'];

			$query = "DELETE from follow where follower_object_id='".$follower_object_id."' and user_followed_object_id='".
									$user_followed_object_id."'";
			mysql_query($query);
			http_response_code(200);
			header("Content-Type: application/json");
			echo json_encode(array());
			break;
		}

		case "getAllFollowingAndStatus": {
			if(!isset($_POST['follower_object_id']))
				exit;

			$follower_object_id = $_POST['follower_object_id'];
			$query = "SELECT f.user_followed_object_id, f.user_followed_fb_id, b.live FROM follow f, broadcast b WHERE f.follower_object_id='".$follower_object_id.
								"' and f.user_followed_object_id = b.users_object_id";
			// echo $query;
			$result = mysql_query($query);
			if(mysql_num_rows($result) > 0){
				while($row = mysql_fetch_assoc($result))
					$to_be_returned[] = $row;
			}
			else{
				$to_be_returned = array();
			}
			http_response_code(200);
			header("Content-Type: application/json");
			echo json_encode($to_be_returned);
			break;
		}

		case "getAllFollowers" : {
			if(!isset($_POST['user_followed_object_id']))
				exit;

			$user_followed_object_id = $_POST['user_followed_object_id'];
			$query = "SELECT * FROM follow WHERE user_followed_object_id = '".$user_followed_object_id."'";
			$result = mysql_query($query);
			if(mysql_num_rows($result) > 0){
				while($row = mysql_fetch_assoc($result))
					$to_be_returned[] = $row;
			}
			else{
				$to_be_returned = array();
			}

			http_response_code(200);
			header("Content-Type: application/json");
			//echo json_encode($to_be_returned);
			echo json_encode(array('followerCount' => mysql_num_rows($result)));
			break;
		}
	} 
?>
