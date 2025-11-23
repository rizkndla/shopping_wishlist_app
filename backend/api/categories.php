<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

// GET all categories
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $query = "SELECT * FROM categories ORDER BY name";
    $stmt = $db->prepare($query);
    $stmt->execute();

    $categories = array();
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $categories[] = $row;
    }

    http_response_code(200);
    echo json_encode($categories);
} else {
    http_response_code(405);
    echo json_encode(array("message" => "Method not allowed."));
}
?>