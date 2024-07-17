<?php 
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);
    $title = mysqli_real_escape_string($connect, $_POST['title']);
    $weekday = mysqli_real_escape_string($connect, $_POST['weekday']);
    $details = mysqli_real_escape_string($connect, $_POST['details']);
    $startTime = mysqli_real_escape_string($connect, $_POST['startTime']);
    $endTime = mysqli_real_escape_string($connect, $_POST['endTime']);
    $done = mysqli_real_escape_string($connect, $_POST['done']);

    $sql = "select password, username from users_tbl Where username like('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                
                $query = "INSERT INTO `tasks_tbl` (`taskTitle`, `username`, `weekday`, `taskDetails`, `startTime`, `endTime`, `done`) VALUES ('$title', '$username', '$weekday', '$details', '$startTime', '$endTime', '$done');";
                $results = mysqli_query($connect, $query);
                if($results>0)
                    echo 'ok';
                break;
            }
        }

    }
	  

?>