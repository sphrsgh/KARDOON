<?php
    include "config.php";

    $username = mysqli_real_escape_string($connect, $_POST['username']);

    $sql = "SELECT `username` FROM users_tbl WHERE `username` LIKE('$username')";
    $result = mysqli_query($connect, $sql);

    if ($result>0) {

        

        while($row = mysqli_fetch_assoc($result)) {
            
            $res = 'ok';
            
        }

        echo $res;

    }

?>