<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get user budget
        $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : '';

        if (!empty($user_id)) {
            $query = "SELECT monthly_budget FROM users WHERE id = :user_id";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':user_id', $user_id);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                http_response_code(200);
                echo json_encode(array(
                    "monthly_budget" => $row['monthly_budget']
                ));
            } else {
                http_response_code(404);
                echo json_encode(array("message" => "User not found."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "User ID is required."));
        }
        break;

    case 'POST':
    case 'PUT':
        // Set/Update user budget
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->user_id) && isset($data->monthly_budget)) {
            $query = "UPDATE users SET monthly_budget = :monthly_budget WHERE id = :user_id";
            $stmt = $db->prepare($query);

            $stmt->bindParam(':user_id', $data->user_id);
            $stmt->bindParam(':monthly_budget', $data->monthly_budget);

            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode(array("message" => "Budget updated successfully."));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to update budget."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Unable to update budget. Data is incomplete."));
        }
        break;
}
?>