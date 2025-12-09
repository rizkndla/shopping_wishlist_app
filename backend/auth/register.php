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
error_log("Register Input: " . $input);

$data = json_decode($input);

// Debug logging
error_log("Username: " . ($data->username ?? 'NULL'));
error_log("Email: " . ($data->email ?? 'NULL'));
error_log("Password: " . (isset($data->password) ? '[SET]' : 'NULL'));

if (empty($data)) {
    http_response_code(400);
    echo json_encode(array(
        "status" => "error",
        "message" => "No data received",
        "received" => $input
    ));
    exit;
}

if (
    !empty($data->username) &&
    !empty($data->email) &&
    !empty($data->password)
) {
    $database = new Database();
    $db = $database->getConnection();

    $username = trim($data->username);
    $email = trim($data->email);
    $password = $data->password;

    // Check if user already exists
    $query = "SELECT id FROM users WHERE username = :username OR email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':username', $username);
    $stmt->bindParam(':email', $email);

    try {
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            http_response_code(400);
            echo json_encode(array(
                "status" => "error",
                "message" => "Username or email already exists."
            ));
        } else {
            // Insert new user
            $query = "INSERT INTO users (username, email, password, monthly_budget, created_at) 
                      VALUES (:username, :email, :password, 0.00, NOW())";
            $stmt = $db->prepare($query);

            $stmt->bindParam(':username', $username);
            $stmt->bindParam(':email', $email);

            // Hash password
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt->bindParam(':password', $password_hash);

            if ($stmt->execute()) {
                $last_id = $db->lastInsertId();
                http_response_code(201);
                echo json_encode(array(
                    "status" => "success",
                    "message" => "User created successfully.",
                    "user_id" => $last_id,
                    "user" => array(
                        "id" => $last_id,
                        "username" => $username,
                        "email" => $email,
                        "monthly_budget" => 0.00
                    )
                ));
            } else {
                error_log("Insert Error: " . print_r($stmt->errorInfo(), true));
                http_response_code(503);
                echo json_encode(array(
                    "status" => "error",
                    "message" => "Unable to create user.",
                    "error_info" => $stmt->errorInfo()
                ));
            }
        }
    } catch (PDOException $e) {
        error_log("PDO Exception: " . $e->getMessage());
        http_response_code(500);
        echo json_encode(array(
            "status" => "error",
            "message" => "Database error: " . $e->getMessage()
        ));
    }
} else {
    http_response_code(400);
    echo json_encode(array(
        "status" => "error",
        "message" => "Unable to create user. Data is incomplete.",
        "received_data" => $data
    ));
}
?>