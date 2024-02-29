<?php
include '../connect.php';

$userId = filterRequest($_POST['userId']);

$stmt = $con->prepare('SELECT * from notes where userId = ?');
$stmt->execute(array($userId));
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(array(
    'status' => 'success',
    'data' => $data
));
