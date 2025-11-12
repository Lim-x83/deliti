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
        // Get user's cart
        $stmt = $pdo->prepare("SELECT id FROM user_carts WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $cart = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if(!$cart) {
            // Create new cart
            $stmt = $pdo->prepare("INSERT INTO user_carts (user_id) VALUES (?)");
            $stmt->execute([$user_id]);
            $cart_id = $pdo->lastInsertId();
        } else {
            $cart_id = $cart['id'];
        }
        
        // Check if item already in cart
        $stmt = $pdo->prepare("SELECT id, quantity FROM cart_items WHERE cart_id = ? AND menu_item_id = ?");
        $stmt->execute([$cart_id, $menu_item_id]);
        $existing_item = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if($existing_item) {
            // Update quantity
            $stmt = $pdo->prepare("UPDATE cart_items SET quantity = quantity + 1 WHERE id = ?");
            $stmt->execute([$existing_item['id']]);
        } else {
            // Add new item
            $stmt = $pdo->prepare("INSERT INTO cart_items (cart_id, menu_item_id, quantity) VALUES (?, ?, 1)");
            $stmt->execute([$cart_id, $menu_item_id]);
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