<?php
include '../connect.php';

$noteId = filterRequest($_POST['noteId']);


$stmt = $con->prepare('select * from notes where noteId = ?');
$stmt->execute(array($noteId));

$data = $stmt->fetch(PDO::FETCH_ASSOC);

if($data['image'] != null)
{
    deleteImage($data['image']);
}

$stmt = $con->prepare('delete from notes where noteId = ?');
$stmt->execute(array($noteId));

$count = $stmt->rowCount();

if($count > 0)
{
    echo json_encode(array(
        'status' => 'success'
    ));
} else {
    echo json_encode(array(
        'status' => 'fail'
    ));
}




