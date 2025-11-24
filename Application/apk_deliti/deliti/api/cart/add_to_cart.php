<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['user_id']) && !empty($data['menu_item_id'])) {
    $user_id = $data['user_id'];
    $menu_item_id = $data['menu_item_id'];
    
    try {
        // Check if item already in cart (using user_id directly)
        $stmt = $pdo->prepare("SELECT id, quantity FROM cart_items WHERE user_id = ? AND menu_item_id = ?");
        $stmt->execute([$user_id, $menu_item_id]);
        $existing_item = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if($existing_item) {
            // Update quantity
            $stmt = $pdo->prepare("UPDATE cart_items SET quantity = quantity + 1 WHERE id = ?");
            $stmt->execute([$existing_item['id']]);
        } else {
            // Add new item (using user_id directly)
            $stmt = $pdo->prepare("INSERT INTO cart_items (user_id, menu_item_id, quantity) VALUES (?, ?, 1)");
            $stmt->execute([$user_id, $menu_item_id]);
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Item added to cart'
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
        'message' => 'User ID and menu item ID required'
    ]);
}
?>