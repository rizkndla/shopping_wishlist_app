<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

error_reporting(E_ALL);
ini_set('display_errors', 1);

include_once '../config/database.php';

// Tangkap raw input
$input = file_get_contents("php://input");
error_log("Login Input: " . $input);

$data = json_decode($input);

if (empty($data)) {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "No data received"));
    exit;
}

if (!empty($data->username) && !empty($data->password)) {
    $database = new Database();
    $db = $database->getConnection();

    $username = trim($data->username);

    $query = "SELECT id, username, email, password, monthly_budget FROM users WHERE username = :username";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':username', $username);

    try {
        $stmt->execute();

        if ($stmt->rowCount() == 1) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            $id = $row['id'];
            $username = $row['username'];
            $email = $row['email'];
            $password_hashed = $row['password'];
            $monthly_budget = $row['monthly_budget'];

            if (password_verify($data->password, $password_hashed)) {
                http_response_code(200);
                echo json_encode(array(
                    "status" => "success",
                    "message" => "Login successful.",
                    "user" => array(
                        "id" => $id,
                        "username" => $username,
                        "email" => $email,
                        "monthly_budget" => $monthly_budget
                    )
                ));
            } else {
                http_response_code(401);
                echo json_encode(array("status" => "error", "message" => "Login failed. Invalid password."));
            }
        } else {
            http_response_code(404);
            echo json_encode(array("status" => "error", "message" => "User not found."));
        }
    } catch (PDOException $e) {
        error_log("PDO Exception: " . $e->getMessage());
        http_response_code(500);
        echo json_encode(array("status" => "error", "message" => "Database error: " . $e->getMessage()));
    }
} else {
    http_response_code(400);
    echo json_encode(array("status" => "error", "message" => "Unable to login. Data is incomplete."));
}
?>