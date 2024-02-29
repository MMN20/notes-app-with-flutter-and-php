<?php

include '../connect.php';

$noteId = filterRequest($_POST['noteId']);
$title = filterRequest($_POST['title']);
$content = filterRequest($_POST['content']);


$stmt =  $con->prepare('select * from notes where noteId = ?');
$stmt->execute(array($noteId));
$data = $stmt->fetch(PDO::FETCH_ASSOC);




$imageName = null;

if(count($_FILES) != 0)
{
    if ($data['image'] != $_FILES['file']['name']) {
        deleteImage($data['image']);
        $imageName = uploadImage2('file');
    }
}
 

$stmt = $con->prepare('UPDATE `notes` set `title` = ?, `content` = ?, `image` = ? where `noteId` = ?');
$stmt->execute(array($title, $content, $imageName, $noteId));

$count = $stmt->rowCount();


if ($count > 0) {
    echo json_encode(array(
        'status' => 'success'
    ));
} else {
    echo json_encode(array(
        'status' => 'fail'
    ));
}
