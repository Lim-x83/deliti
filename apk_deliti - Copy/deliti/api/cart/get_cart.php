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
        // Get or create user cart
        $stmt = $pdo->prepare("SELECT id FROM user_carts WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $cart = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if(!$cart) {
            // Create new cart for user
            $stmt = $pdo->prepare("INSERT INTO user_carts (user_id) VALUES (?)");
            $stmt->execute([$user_id]);
            $cart_id = $pdo->lastInsertId();
        } else {
            $cart_id = $cart['id'];
        }
        
        // Get cart items with menu item details
        $stmt = $pdo->prepare("
            SELECT ci.*, mi.name, mi.price, mi.image_path, mi.description 
            FROM cart_items ci 
            JOIN menu_items mi ON ci.menu_item_id = mi.id 
            WHERE ci.cart_id = ? AND ci.quantity > 0
        ");
        $stmt->execute([$cart_id]);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode([
            'success' => true,
            'cart_id' => $cart_id,
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