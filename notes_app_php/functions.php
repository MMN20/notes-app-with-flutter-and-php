<?php
define('MB', 1048576);

function filterRequest($request)
{
    return htmlspecialchars(strip_tags($request));
}

function uploadImage($imageRequest)
{

    global $msgError;
    $imagename =    $_FILES[$imageRequest]['name'];
    $imagetmp = $_FILES[$imageRequest]['tmp_name'];
    $imagesize = $_FILES[$imageRequest]['size'];
    $allowExt = array('jpg', 'png', 'gif', 'mp3', 'pdf');
    $stToArray = explode('.', $imagename);
    $ext = end($stToArray);
    $ext = strtolower($ext);
    if (!empty($imagename) && !in_array($ext, $allowExt)) {
        $msgError[] = "Ext";
    }
    if ($imagesize > 2 * MB) {
        $msgError[] = 'size';
    }
    if (empty($msgError)) {
        move_uploaded_file($imagetmp, "../upload/" . $imagename);
        return $imagename;
    } else {
        return 'fail';
    }
}


function uploadImage2($imageRequest)
{
    if(count($_FILES) == 0)
    {
        return null;
    }
    if($_FILES['file']['name'] == '')
    {
        return null;
    }
    global $msgError;
    $imageName = $_FILES[$imageRequest]['name'];
    $imageTmp = $_FILES[$imageRequest]['tmp_name'];
    $allowedExt = array('jpg', 'png', 'gif', 'mp3', 'pdf');
    $nameParts = explode('.', $imageName);
    $nameExt = end($nameParts);
    $nameExt = strtolower($nameExt);
    if (!empty($imageName) && !in_array($nameExt, $allowedExt)) {
        $msgError[] = "Ext";
    }

    if (empty($msgError)) {
        move_uploaded_file($imageTmp,  "../upload/" . $imageName);
        return $imageName;
    } else {
        return null;
    }
}

function deleteImage($imageName)
{
    if($imageName == null)
    {return;}
    if (file_exists("../upload/" . $imageName)) {
        unlink("../upload/" . $imageName);
    }
}
