<?php

header("Access-Control-Allow-Origin: *");

$username="";
$password="";
$host="localhost:3306";
$db_name="kardoon";
	

$connect=mysqli_connect($host,$username,$password,$db_name);
	

if(!$connect)
{
	echo json_encode("Connection Failed!");
}
?>