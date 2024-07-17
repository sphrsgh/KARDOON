<?php
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);
    $id = mysqli_real_escape_string($connect, $_POST['id']);
    $done = mysqli_real_escape_string($connect, $_POST['done']);

    $sql = "SELECT `username`,`password` FROM users_tbl WHERE `username` LIKE('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                
                $sql2 = "UPDATE `tasks_tbl` SET `done` = '$done' WHERE `tasks_tbl`.`ID` = $id;";
                $result2 = mysqli_query($connect, $sql2);
                
                if ($result2>0){
                    echo 'ok';
                }
                
                break;
            }
        }

        echo $res;

    }

?>