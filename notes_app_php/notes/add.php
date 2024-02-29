<?php
include '../connect.php';

$title = filterRequest($_POST['title']);
$content = filterRequest($_POST['content']);
$userId = filterRequest($_POST['userId']);

$image = null;
if(count($_FILES) != 0)
{   
    $image = uploadImage2('file');
}


$stmt = $con->prepare('INSERT INTO `notes` (`title`,`content`,`image`,`userId`) values (?,?,?,?)');
$stmt->execute(array($title, $content, $image, $userId));

$count = $stmt->rowCount();

if ($count > 0) {

    $data = $con->lastInsertId();
    echo json_encode(array(
        'status' => 'success',
        'data' => $data
    ));
} else {
    echo json_encode(array(
        'status' => 'fail',
        'data' => 'Error'
    ));
}
