<?php
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);
    $password = mysqli_real_escape_string($connect, $_POST['password']);

    $sql = "select password, username from users_tbl Where username like('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        $res = 'username or pass incorrect!';

        while($row = mysqli_fetch_assoc($result)) {
            if ($row["password"] == $password && $row["username"] == $username){
                $res = 'ok';
                break;
            }
        }

        echo $res;

    }

?>