<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id'])) {
    $user_id = $data['user_id'];
    
    try {
        // Get cart items with menu item details (using user_id directly)
        $stmt = $pdo->prepare("
            SELECT 
                ci.id,
                ci.user_id,
                ci.menu_item_id,
                ci.quantity,
                ci.created_at,
                ci.updated_at,
                mi.name, 
                mi.price, 
                mi.image_path, 
                mi.description 
            FROM cart_items ci 
            JOIN menu_items mi ON ci.menu_item_id = mi.id 
            WHERE ci.user_id = ? AND ci.quantity > 0
        ");
        $stmt->execute([$user_id]);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode([
            'success' => true,
            'items' => $items
        ]);
        
    } catch(PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'User ID required'
    ]);
}
?>