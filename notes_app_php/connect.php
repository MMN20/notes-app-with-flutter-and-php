<?php
 include "functions.php";
$dsn = "mysql:host=localhost;dbname=notes_app";
$user = 'root';
$pass = "";
$option = array(
    PDO::MYSQL_ATTR_INIT_COMMAND
);

try {

    $con = new PDO($dsn,$user,$pass,$option);
    $con->setAttribute(PDO::ATTR_ERRMODE , PDO::ERRMODE_EXCEPTION);
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Access-Control-Allow-Origin");
    header("Access-Control-Allow-Methods: POST, OPTIONS , GET");
        
} catch (PDOException $th) {
    
    echo  $th-> getMessage();

}

