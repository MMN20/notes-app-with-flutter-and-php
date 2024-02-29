<?php
include '../connect.php';

$email = filterRequest($_POST['email']);
$username = filterRequest($_POST['username']);
$password = filterRequest($_POST['password']);


$stmt = $con->prepare('SELECT * FROM `users` where email = ?');
$stmt->execute(array($email));

$count = $stmt->rowCount();

if($count > 0)
{
   echo json_encode(array(
        'status' => 'fail',
        'data' => 'this email is already in use'
    ));
    exit;
}

$stmt = $con->prepare('INSERT INTO `users` (`username`,`email`,`password`) values (?,?,?)');
$stmt->execute(array($username,$email,$password));

$count = $stmt->rowCount();

if($count > 0)
{
    $data = $con->lastInsertId();
   echo json_encode(array(
        'status' => 'success',
        'data' => $data
    ));
}
else
{
    echo json_encode(array(
        'status' => 'fail',
        'data' => 'Error'
    ));    
    
}



?>