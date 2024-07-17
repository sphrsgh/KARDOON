<?php 
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);

    $sql = "select password, username from users_tbl Where username like('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                
                $sql = "Select * From tasks_tbl Where username Like('$username') ORDER BY `startTime`;";
                $result = mysqli_query($connect, $sql);
                $emparray = array();
                while($row =mysqli_fetch_assoc($result))
                {
                    $emparray[] = $row;
                }
                echo json_encode($emparray);
                break;
            }
        }

    }
	  

?>