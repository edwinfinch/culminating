<?php
$url = 'https://api.particle.io/v1/devices/53ff6c066667574830391267/MOVE?access_token=c2f589c281a4453e851da6c031d38f06355b0114';

// use key 'http' even if you send the request to https
$options = array(
    'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => "args=" . $_GET["dir"],
    ),
);
$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);

var_dump($result);
?>
