<?php
header('Access-Control-Allow-Origin: *');
date_default_timezone_set('UTC');
require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';

$fb = new Facebook\Facebook([
    'app_id' => '708819499280004', // Replace {app-id} with your app id
    'app_secret' => '16d2fd867653b5fa1bb9c08a541258c3',
    'default_graph_version' => 'v2.8',
]);
$accessToken = "EAAKEquZA25oQBAMoE6NRZBZAoMMqE86cSfVHYrjHSKos0mQMEYECZCo07zIZAuwzaR4U86m5jLQTkqg6n7Q3dpP3kzHHa4QmP7vcz37KORtwQQifb51B1CgGGUBM0j677drJ7iJ4JPUEZBuHQrmuddGOpWtsDieoYZD";
$extentURL = '';

if(isset($_GET['keyword'])&&isset($_GET['type'])&&!isset($_GET['detail_keyword'])&&!isset($_GET['detail_type'])&&!isset($_GET['detail_id'])){
    if(isset($_GET['keyword'])&&trim($_GET['keyword'])){$extentURL = $extentURL."q=".$_GET['keyword'];}
    if(isset($_GET['type'])&&trim($_GET['type'])) {$extentURL = $extentURL."&type=".$_GET['type'];}
    if(isset($_GET['lat'])&&trim($_GET['lat'])&&isset($_GET['lng'])&&trim($_GET['lng'])&&$_GET['lat']!=''&&$_GET['lng']!='') {$extentURL = $extentURL."&center=".$_GET['lat'].','.$_GET['lng'];}
    if(isset($_GET['limit'])&&trim($_GET['limit'])) {$extentURL = $extentURL."&limit=".$_GET['limit'];}

    $q = $_GET['keyword'];
    $type = $_GET['type'];
    if($extentURL != "error"){
        $newURL = ($type == "event")?"&fields=id,name,picture.width(700).height(700),place":"&fields=id,name,picture.width(700).height(700)";
        $result = $fb->get('/search?'.str_replace(' ', '%20', $extentURL.$newURL), $accessToken);
        if(!count($result->getGraphEdge())) echo '{"Result":"Empty"}';
        else if(count($result->getGraphEdge())){
            echo $result->getBody();
            //echo $result->getGraphEdge();
        }else{
            echo '{"Result":"Negative?"}';
        }
    }else{
        echo '{"$extentURL":"Error"}';
    }
}

if(isset($_GET['detail_id'])&&isset($_GET['detail_type'])&&isset($_GET['detail_keyword'])){
    $fb->setDefaultAccessToken($accessToken);
    $id = $_GET['detail_id'];
    $q = $_GET['detail_keyword'];
    $type = $_GET['detail_type'];
    $extentURL = ''."q=".$q."&type=".$type;

    if($extentURL != "error"){
        $result = $fb->get('/'.$id.'?'.str_replace(' ', '%20', $extentURL."&fields=id,name,picture,albums.limit(5){name,photos.limit(2){name, picture}},posts.limit(5)"), $accessToken);
        if(!count($result->getGraphObject())) echo '{"Result":"Empty"}';
        else if(count($result->getGraphObject())){
            echo $result->getGraphObject();
        }else{
            echo '{"Result":"Negative?"}';
        }
    }else{
        echo '{"$extentURL":"Error"}';
    }
}
