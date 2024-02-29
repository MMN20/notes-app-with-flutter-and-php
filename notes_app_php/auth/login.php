<?php
include '../connect.php';
$email = filterRequest($_POST['email']);
$password = filterRequest($_POST['password']);

$stmt =  $con->prepare('select * from users where email = ? and password = ?');
$stmt->execute(array($email,$password));


$count = $stmt->rowCount();

if($count > 0)
{
    $data = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode(array(
        'status' => 'success',
        'data' => $data
    ));
}
else
{
    echo json_encode(array(
        'status' => 'fail',
    ));
}
