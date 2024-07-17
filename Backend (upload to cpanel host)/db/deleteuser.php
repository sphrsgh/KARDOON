<?php
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);
    $userid = mysqli_real_escape_string($connect, $_POST['userid']);
    

    $sql = "SELECT `username`,`password` FROM users_tbl WHERE `username` LIKE('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                
                $sql2 = "DELETE FROM `users_tbl` WHERE `users_tbl`.`ID` = $userid;";
                $result2 = mysqli_query($connect, $sql2);

                $sql3 = "DELETE FROM `tasks_tbl` WHERE `tasks_tbl`.`username` LIKE('$username');";
                mysqli_query($connect, $sql3);
                
                if ($result2>0){
                    echo 'ok';
                }
                
                break;
            }
        }

        echo $res;

    }

?>