<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get all wishlist items for a user
        $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : '';

        if (!empty($user_id)) {
            $query = "SELECT * FROM wishlist_items WHERE user_id = :user_id ORDER BY created_at DESC";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':user_id', $user_id);
            $stmt->execute();

            $wishlist_items = array();
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $wishlist_items[] = $row;
            }

            http_response_code(200);
            echo json_encode($wishlist_items);
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "User ID is required."));
        }
        break;

    case 'POST':
        // Add new wishlist item
        $data = json_decode(file_get_contents("php://input"));

        if (
            !empty($data->user_id) &&
            !empty($data->name) &&
            !empty($data->price) &&
            !empty($data->category)
        ) {
            $query = "INSERT INTO wishlist_items SET 
                user_id=:user_id, 
                name=:name, 
                price=:price, 
                category=:category, 
                priority=:priority, 
                product_url=:product_url";

            $stmt = $db->prepare($query);

            $stmt->bindParam(':user_id', $data->user_id);
            $stmt->bindParam(':name', $data->name);
            $stmt->bindParam(':price', $data->price);
            $stmt->bindParam(':category', $data->category);
            $stmt->bindParam(':priority', $data->priority);
            $stmt->bindParam(':product_url', $data->product_url);

            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode(array(
                    "message" => "Wishlist item was created.",
                    "item_id" => $db->lastInsertId()
                ));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to create wishlist item."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Unable to create item. Data is incomplete."));
        }
        break;

    case 'PUT':
        // Update wishlist item
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->id)) {
            $query = "UPDATE wishlist_items SET 
                name=:name, 
                price=:price, 
                category=:category, 
                priority=:priority, 
                product_url=:product_url,
                is_bought=:is_bought
                WHERE id=:id";

            $stmt = $db->prepare($query);

            $stmt->bindParam(':id', $data->id);
            $stmt->bindParam(':name', $data->name);
            $stmt->bindParam(':price', $data->price);
            $stmt->bindParam(':category', $data->category);
            $stmt->bindParam(':priority', $data->priority);
            $stmt->bindParam(':product_url', $data->product_url);
            $stmt->bindParam(':is_bought', $data->is_bought);

            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode(array("message" => "Wishlist item was updated."));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to update wishlist item."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Item ID is required."));
        }
        break;

    case 'DELETE':
        // Delete wishlist item
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->id)) {
            $query = "DELETE FROM wishlist_items WHERE id = :id";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':id', $data->id);

            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode(array("message" => "Wishlist item was deleted."));
            } else {
                http_response_code(503);
                echo json_encode(array("message" => "Unable to delete wishlist item."));
            }
        } else {
            http_response_code(400);
            echo json_encode(array("message" => "Item ID is required."));
        }
        break;
}
?>