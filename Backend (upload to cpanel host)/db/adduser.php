<?php 
include "config.php";

$fullname = mysqli_real_escape_string($connect, $_POST['fullname']);
$username = mysqli_real_escape_string($connect, $_POST['username']);
$password = mysqli_real_escape_string($connect, $_POST['password']);
$email = mysqli_real_escape_string($connect, $_POST['email']);

	  
$query = "INSERT INTO `users_tbl` (`fullName`, `username`, `password`, `email`) VALUES ('$fullname', '$username', '$password', '$email');";

$results = mysqli_query($connect, $query);
if($results>0)
    echo "ok";
    
?>