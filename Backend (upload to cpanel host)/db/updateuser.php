<?php
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);
    $id = mysqli_real_escape_string($connect, $_POST['id']);
    $fullname = mysqli_real_escape_string($connect, $_POST['fullname']);
    $newusername = mysqli_real_escape_string($connect, $_POST['newusername']);
    $email = mysqli_real_escape_string($connect, $_POST['email']);

    $sql = "SELECT `username`,`password` FROM users_tbl WHERE `username` LIKE('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                
                $sql2 = "UPDATE `users_tbl` SET `fullname` = '$fullname', `username` = '$newusername', `email` = '$email' WHERE `users_tbl`.`ID` = $id;";
                $result2 = mysqli_query($connect, $sql2);

                $sql3 = "UPDATE `tasks_tbl` SET `username` = '$newusername' WHERE `tasks_tbl`.`username` LIKE('$username');";
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