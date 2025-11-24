<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include '../config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(!empty($data['cart_item_id']) && isset($data['quantity'])) {
    $cart_item_id = $data['cart_item_id'];
    $quantity = $data['quantity'];
    
    try {
        if($quantity <= 0) {
            // Remove item if quantity is 0 or less
            $stmt = $pdo->prepare("DELETE FROM cart_items WHERE id = ?");
            $stmt->execute([$cart_item_id]);
        } else {
            // Update quantity
            $stmt = $pdo->prepare("UPDATE cart_items SET quantity = ? WHERE id = ?");
            $stmt->execute([$quantity, $cart_item_id]);
        }
        
        echo json_encode([
            'success' => true,
            'message' => 'Cart updated'
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
        'message' => 'Cart item ID and quantity required'
    ]);
}
?>